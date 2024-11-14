import Photos
import UIKit

// -- To be used for nested folders
class PhotoManager: NSObject {
    static let instance = PhotoManager()
    var folder: PHCollectionList?
    var assetCollection: PHAssetCollection!
    
    private override init() {
        super.init()
        print("Title", UserStore.sharedInstance.title)
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
        fetchOptions.predicate = NSPredicate(format: "title = %@", UserStore.sharedInstance.title)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    /// Fetches an existing folder with the specified identifier or creates one with the specified name
    func fetchFolderWithIdentifier(completion: @escaping (PHCollectionList?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Usnap")
        let fetchRes = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: fetchOptions)
        
        guard let folder = fetchRes.firstObject else {
            createFolderWithName { folder in
                print("folder created")
            }
            return
        }
        self.folder = folder
        completion(folder)
    }

    /// Creates a folder with the specified name
    private func createFolderWithName(completion: @escaping (PHCollectionList?) -> Void) {
        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let changeRequest = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: "Usnap")
            placeholder = changeRequest.placeholderForCreatedCollectionList
        }) { (success, error) in
            guard let placeholder = placeholder else { return }
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", "Usnap")
            let fetchRes = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: fetchOptions)
            
            guard let folder = fetchRes.firstObject else { return }
            self.folder = folder
            completion(folder)
        }
    }

    /// Creates an album with the specified name
    private func createAlbumWithName(completion: @escaping (PHAssetCollection?) -> Void) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            print("Album already exists")
            self.assetCollection = assetCollection
            completion(self.assetCollection)
        } else {
            guard let folder = folder else {
                completion(nil)
                return
            }
            
            var placeholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let listRequest = PHCollectionListChangeRequest(for: folder)
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: UserStore.sharedInstance.title)
                listRequest?.addChildCollections([createAlbumRequest.placeholderForCreatedAssetCollection] as NSArray)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }) { (success, error) in
                guard let placeholder = placeholder else {
                    completion(nil)
                    return
                }
                
                let fetchOptions = PHFetchOptions()
                print(">>>>>>", UserStore.sharedInstance.title)
                fetchOptions.predicate = NSPredicate(format: "title = %@", UserStore.sharedInstance.title)
                let fetchRes = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                let album = fetchRes.firstObject
                completion(album)
            }
        }
    }

    /// Saves the image to a new album with the specified name
    func saveImageToAlbumInRootFolder(image: UIImage?, completion: @escaping (Error?) -> Void) {
        if folder == nil {
            fetchFolderWithIdentifier { success in
                print(success)
                print("created usnap folder")
            }
        } else {
            self.createAlbumWithName { (album) in
                guard let album = album else {
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                    let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset!
                    albumChangeRequest?.addAssets([photoPlaceholder] as NSArray)
                }, completionHandler: { (success, error) in
                    if success {
                        completion(nil)
                        print("image saved successfully")
                    } else if let error = error {
                        // Failed with error
                    } else {
                        // Failed with no error
                    }
                })
            }
        }
        
//        fetchFolderWithIdentifier { folder in
//            if folder != nil {
//                self.createAlbumWithName { (album) in
//                    guard let album = album else {
//                        return
//                    }
//
//                    PHPhotoLibrary.shared().performChanges({
//                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
//                        let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
//                        let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset!
//                        albumChangeRequest?.addAssets([photoPlaceholder] as NSArray)
//                    }, completionHandler: { (success, error) in
//                        if success {
//                            print("Image saved")
//                            completion(nil)
//                        } else if let error = error {
//                            // Failed with error
//                        } else {
//                            // Failed with no error
//                        }
//                    })
//                }
//            }
//        }
        
    
    }
}


// -- To be used for single album
/*
class CustomPhotoAlbum: NSObject {

   // static let albumName = UserStore.sharedInstance.title
    static let shared = CustomPhotoAlbum()
    
    private var assetCollection: PHAssetCollection!
    
    private override init() {
        super.init()
        print("Title", UserStore.sharedInstance.title)
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
    }
    
    private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool) -> Void)) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.checkAuthorizationWithHandler(completion: completion)
            })
        }
        else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.createAlbumIfNeeded { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        else {
            completion(false)
        }
    }
    
    private func createAlbumIfNeeded(completion: @escaping ((_ success: Bool) -> Void)) {
        if let assetCollection = fetchAssetCollectionForAlbum() {
            // Album already exists
            self.assetCollection = assetCollection
            completion(true)
        } else {
            PHPhotoLibrary.shared().performChanges({
                print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: UserStore.sharedInstance.title)   // create an asset collection with the album name
            }) { success, error in
                if success {
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    completion(true)
                } else {
                    // Unable to create album
                    completion(false)
                }
            }
        }
    }
    
    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
        fetchOptions.predicate = NSPredicate(format: "title = %@", UserStore.sharedInstance.title)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
    
    func save(image: UIImage) {
        self.checkAuthorizationWithHandler { (success) in
            if success, self.assetCollection != nil {
                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                    if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                        let enumeration: NSArray = [assetPlaceHolder!]
                        albumChangeRequest.addAssets(enumeration)
                    }
                    
                }, completionHandler: { (success, error) in
                    if success {
                        print("Successfully saved image to Camera Roll.")
                    } else {
                        print("Error writing to image library: \(error!.localizedDescription)")
                    }
                })
                
            }
        }
    }
    
    func saveMovieToLibrary(movieURL: URL) {
        
        self.checkAuthorizationWithHandler { (success) in
            if success, self.assetCollection != nil {
                
                PHPhotoLibrary.shared().performChanges({
                    if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieURL) {
                        let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) {
                            let enumeration: NSArray = [assetPlaceHolder!]
                            albumChangeRequest.addAssets(enumeration)
                        }
                    }
                }, completionHandler:  { (success, error) in
                    if success {
                        print("Successfully saved video to Camera Roll.")
                    } else {
                        print("Error writing to movie library: \(error!.localizedDescription)")
                    }
                })
                
            }
        }
        
    }
}
*/
