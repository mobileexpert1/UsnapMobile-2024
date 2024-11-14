//
//  DataDownloadStore.swift
//  Usnap
//
//  Created by CSPC141 on 15/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Foundation
import TUCAssetsHelper
import SVProgressHUD
import Photos
class AlbumModel {
    let name:String
    let collection:PHAssetCollection
    init(name:String, collection:PHAssetCollection) {
        self.name = name
        self.collection = collection
    }
}

class DataDownloadStore: ApiStore {
 static let sharedInstance = DataDownloadStore()
    var changeRequest: PHAssetChangeRequest?
    var blockPlaceholder: PHObjectPlaceholder?
    var identifier:String!
   
    //MARK:- Download Images To Custom Album
    func saveImages(_ imagesArray: NSArray, _ albumName: String, completion: @escaping (_ : NSString?) -> Void)  {
        var tempInt = Int()
        tempInt = 0
        
        if showProgress && !SVProgressHUD.isVisible() {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            
        } else {
            showProgress = true
        }
        for image in imagesArray {
            var tempImage = UIImage()
            tempImage = image as! UIImage
            tempImage.tuc_saveTo(album:albumName)
            tempInt = tempInt + 1
            if tempInt == imagesArray.count {
                SVProgressHUD.dismiss()
                completion("1")
            }
        }
    }
    
    //MARK:- Download Images 
    func downlaodImage(_ image: UIImage, _ albumName: String, completion: @escaping (_ : NSString?) -> Void)  {
            image.tuc_saveTo(album:albumName)
                completion("1")
    }
    
//    //MARK:- Download Video
//    func downloadVideo(_ videoUrlString: String, _ albumName: String, completion: @escaping (_ : NSString?) -> Void)  {
//        let videoImageUrl = videoUrlString
//        DispatchQueue.global(qos: .background).async {
//            if let url = URL(string: videoImageUrl),
//                let urlData = NSData(contentsOf: url) {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//                let filePath="\(documentsPath)/tempFile.mp4"
//                DispatchQueue.main.async {
//                    urlData.write(toFile: filePath, atomically: true)
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
//                    }) { completed, error in
//                        if completed {
//                           
//                            completion("1")
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    //MARK:- Download Video
    func downloadVideo(_ videoUrlString: String, _ albumName: String, completion: @escaping (_ : NSString?) -> Void)  {
        let videoImageUrl = videoUrlString
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.MOV"
               
                
                DispatchQueue.main.async {
                    self.saveToGallery(URL(string:filePath)!, albumName)
                    
                }
                
//                DispatchQueue.main.async {
//                    urlData.write(toFile: filePath, atomically: true)
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
//                    }) { completed, error in
//                        if completed {
//
//                            completion("1")
//                        }
//                    }
//                }
            }
        }
    }
    
    
    
    
    func saveToGallery(_ fielURL : URL, _ folderName: String) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            
            let createAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:fielURL)!
            
            //   createAssetRequest.placeholderForCreatedAsset
            self.identifier =  createAssetRequest.placeholderForCreatedAsset?.localIdentifier
        })
        { (success, error) -> Void in
            
            if success {
                
                let  newAsset = PHAsset.fetchAssets(withLocalIdentifiers: [self.identifier], options: nil).firstObject
                self.listAlbums(newAsset!, folderName)
                //popup alert success
               
            }
            else
            {
                //popup alert unsuccess
            }
        }
    }
    
    
    func listAlbums(_ newAsset: PHAsset, _ folderName: String) {
        var album:[AlbumModel] = [AlbumModel]()
        
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: options)
        
        for index in 0..<userAlbums.count {
            let object = userAlbums[index]
            let obj:PHAssetCollection = object
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
            let newAlbum = AlbumModel(name: obj.localizedTitle!, collection:obj)
            album.append(newAlbum)
            
        }
        
        
        if album.contains(where: { $0.name == folderName }) {
            let index = album.index(where: { $0.name == folderName })
            
            
            self.saveToCustomFolder(album[index!].collection, newAsset)
            
            
            
        } else {
            self.createAssetCollectionFolder(newAsset, folderName)
        }
    }
    
    
    
    func createAssetCollectionFolder(_ newAsset: PHAsset,  _ folderName: String) {
        var placeHolderIdentifier:String!
        PHPhotoLibrary.shared().performChanges({
            
            let createRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: folderName)
            
            placeHolderIdentifier = createRequest.placeholderForCreatedAssetCollection.localIdentifier
            
        }, completionHandler: {
            success, error in
            if success {
                var createdCollection: PHAssetCollection? = nil
                if placeHolderIdentifier != nil
                {
                    createdCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeHolderIdentifier!], options: nil).firstObject
                   // self.saveToCustomFolder(createdCollection!,newAsset)
                    self.saveToCustomFolder(createdCollection!, newAsset)
                    
                }
            }
            else
            {
            }
        })
    }
    
    
    func saveToCustomFolder(_ collecton: PHAssetCollection,_ newAsset: PHAsset) {
        PHPhotoLibrary.shared().performChanges({
            
            guard let addAssetRequest = PHAssetCollectionChangeRequest(for: collecton) else { return }
            
            addAssetRequest.addAssets([newAsset] as NSArray)
        }, completionHandler: {
            success, error in
            
            //handle error or stuff you want to do after that here
        })
    }
    
    
    
    
    
    
     func shareImage(_ imagesArray: NSArray, _ albumName: String,_ controller: UIViewController, completion: @escaping (_ : NSString?) -> Void)  {
        var objectsToShare = [Any]()
        for image in imagesArray {
           objectsToShare.append(image)
        }
        if albumName == "" {
            
        }
        else {
            objectsToShare.append(albumName)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

      //  activityVC.se

        activityVC.setValue(albumName, forKey: "subject")

        activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                 completion("0")
                return
            }
             completion("1")
            // User completed activity
        }

        controller.present(activityVC, animated: true, completion: nil)

    }
    
    
    
    func downloadPdf(_ pdffiles: NSArray, _ campName: NSArray, _ controller: UIViewController, completion: @escaping (_ : NSString?) -> Void)  {
        var currentIndex = Int()
        for i in 0..<pdffiles.count {
            let pdf = pdffiles[i] as? String ?? ""
            if let url = URL(string:pdf) {
                let pdfData = try? Data.init(contentsOf: url)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = campName[currentIndex] as! String
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    currentIndex = currentIndex + 1
                } catch {
                    print("Pdf could not be saved")
                }
            }
            
            
            
        }
        
        SVProgressHUD.dismiss()
        
        completion("1")
        
        
           
        
        
//        if albumName == "" {
//
//        }
//        else {
//            objectsToShare.append(albumName)
//        }
//
//        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//        //  activityVC.se
//
//        activityVC.setValue("Hola", forKey: "subject")
//
//        activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
//            if !completed {
//                // User canceled
//                completion("0")
//                return
//            }
//            completion("1")
//            // User completed activity
//        }
//
//        controller.present(activityVC, animated: true, completion: nil)
        
    }
    
  
    func shareImageWithSubject(_ imagesArray: NSArray, _ albumName: String, _ tagLine: String, _ userName: String, _ campName: String, _ controller: UIViewController, completion: @escaping (_ : NSString?) -> Void)  {
        var objectsToShare = [Any]()
          let tag1 = String(format: "Hi \n\n%@ has shared media with you for %@. Please click this link to download the media.", userName, campName)
        let tag2 = String(format: "\n\nPlease contact %@ if you believe this media was not meant for you. \n\n For any technical support or if you have any questions relating to U Snap please email social@usnap.com.au \n\n Happy snapping \n U Snap PTY LTD \n", userName)
        
        
        objectsToShare.append(tag1)
        objectsToShare.append("\n")
        for image in imagesArray {
            objectsToShare.append(image)
        }
        objectsToShare.append(tag2)
        objectsToShare.append("\n")
        
        
//        if albumName == "" {
//            
//        }
//        else {
//            objectsToShare.append(albumName)
//        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.setValue(albumName, forKey: "subject")
        
        activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                completion("0")
                return
            }
            completion("1")
            // User completed activity
        }
         DispatchQueue.main.async {
            controller.present(activityVC, animated: true, completion: nil)
        }
    }
    
   
    
    
    
}
