//
//  DKImagePickerControllerHandler.swift
//  Infinite BackUp
//
//  Created by apple on 27/12/18.
//  Copyright © 2018 Mobile. All rights reserved.
//

import UIKit
import DKImagePickerController

class DKImagePickerHandler:NSObject {
    
    //MARK:- Shared Instance
    static let shared = DKImagePickerHandler()
    private override init() {
        
    }
    
    //MARK:- Variables
    var currentVC: UIViewController!
    var pickerController = DKImagePickerController()
    var assets: [DKAsset]?
    var exportManually = false
    
    //MARK:- Deintialization
    deinit {
        DKImagePickerControllerResource.customLocalizationBlock = nil
        DKImagePickerControllerResource.customImageBlock = nil
        DKImageExtensionController.unregisterExtension(for: .camera)
        DKImageExtensionController.unregisterExtension(for: .inlineCamera)
        DKImageAssetExporter.sharedInstance.remove(observer: self)
    }
    
    //MARK:- Show Image Picker
    func showImagePicker(vc: UIViewController, completion: @escaping(_ :[DKAsset]?) -> Void) {
        if self.exportManually {
            DKImageAssetExporter.sharedInstance.add(observer: self)
        }
        
        if let assets = self.assets {
            pickerController.select(assets: assets)
        }
        
        pickerController.exportStatusChanged = { status in
            switch status {
            case .exporting:
                print("exporting")
            case .none:
                print("none")
            }
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            completion(assets)
            self.updateAssets(assets: assets)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        
        if pickerController.inline {
            self.showInlinePicker(vc: currentVC)
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.black
            vc.present(pickerController, animated: true) {}
            UINavigationBar.appearance().barTintColor = UIColor.black
        }
    }
    
    //MARK:- Done
    @objc func done() {
        self.updateAssets(assets: self.pickerController.selectedAssets)
    }
    
    //MARK:- Update Done Button Title
    func updateDoneButtonTitle(_ doneButton: UIButton) {
        doneButton.setTitle("Done(\(self.pickerController.selectedAssets.count))", for: .normal)
    }
    
    //MARK:- Inline Mode
    func showInlinePicker(vc:UIViewController) {
        let pickerView = self.pickerController.view!
        pickerView.frame = CGRect(x: 0, y: 170, width: vc.view.bounds.width, height: 200)
        vc.view.addSubview(pickerView)
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        doneButton.frame = CGRect(x: 0, y: pickerView.frame.maxY, width: pickerView.bounds.width / 2, height: 50)
        vc.view.addSubview(doneButton)
        self.pickerController.selectedChanged = { [unowned self] in
            self.updateDoneButtonTitle(doneButton)
        }
        self.updateDoneButtonTitle(doneButton)
        
        let albumButton = UIButton(type: .custom)
        albumButton.setTitleColor(UIColor.blue, for: .normal)
        albumButton.setTitle("Album", for: .normal)
        albumButton.addTarget(self, action: #selector(showAlbum), for: .touchUpInside)
        albumButton.frame = CGRect(x: doneButton.frame.maxX, y: doneButton.frame.minY, width: doneButton.bounds.width, height: doneButton.bounds.height)
        vc.view.addSubview(albumButton)
    }
    
    //MARK:- Show Album
    @objc func showAlbum(vc:UIViewController) {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = self.pickerController.maxSelectableCount
        pickerController.select(assets: self.pickerController.selectedAssets)
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
            self.pickerController.setSelectedAssets(assets: assets)
        }
        UINavigationBar.appearance().barTintColor = UIColor.black
        vc.present(pickerController, animated: true, completion: nil)
    }
    
    //MARK:- Update Assets
    func updateAssets(assets: [DKAsset]) {
        print("didSelectAssets")
        self.assets = assets
    }
}
