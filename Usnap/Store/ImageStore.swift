//
//  ImageStore.swift
//  Usnap
//
//  Created by CSPC141 on 19/03/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

extension UIImage {
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

class ImageStore: UIImage {
    static let sharedDate = ImageStore()
    
     func ConvertImageToData(targetImage: UIImage) ->  Data {
        let data:Data = UIImagePNGRepresentation(targetImage)!
        return data
    }
    
    
    func rotateImage(_ sourceImage: UIImage, clockwise: Bool) -> UIImage {
        let size: CGSize = sourceImage.size
        UIGraphicsBeginImageContext(CGSize(width: size.height, height: size.width))
        UIImage(cgImage: (sourceImage.cgImage)!, scale: 1.0, orientation: clockwise ? .right : .left).draw(in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
