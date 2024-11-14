extension UIImage {

//    func fixedOrientation() -> UIImage {
//
//        if imageOrientation == UIImageOrientation.Up {
//            return self
//        }
//        var transform: CGAffineTransform = CGAffineTransformIdentity
//        switch imageOrientation {
//        case UIImageOrientation.Down, UIImageOrientation.DownMirrored:
//            transform = CGAffineTransformTranslate(transform, size.width, size.height)
//            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
//            break
//        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored:
//            transform = CGAffineTransformTranslate(transform, size.width, 0)
//            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
//            break
//        case UIImageOrientation.Right, UIImageOrientation.RightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, size.height)
//            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
//            break
//        case UIImageOrientation.Up, UIImageOrientation.UpMirrored:
//            break
//        }
//
//        switch imageOrientation {
//        case UIImageOrientation.UpMirrored, UIImageOrientation.DownMirrored:
//            CGAffineTransformTranslate(transform, size.width, 0)
//            CGAffineTransformScale(transform, -1, 1)
//            break
//        case UIImageOrientation.LeftMirrored, UIImageOrientation.RightMirrored:
//            CGAffineTransformTranslate(transform, size.height, 0)
//            CGAffineTransformScale(transform, -1, 1)
//        case UIImageOrientation.Up, UIImageOrientation.Down, UIImageOrientation.Left, UIImageOrientation.Right:
//            break
//        }
//
//        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), CGImageGetBitsPerComponent(CGImage), 0, CGImageGetColorSpace(CGImage), CGImageAlphaInfo.PremultipliedLast.rawValue)!
//
//        CGContextConcatCTM(ctx, transform)
//
//        switch imageOrientation {
//        case UIImageOrientation.Left, UIImageOrientation.LeftMirrored, UIImageOrientation.Right, UIImageOrientation.RightMirrored:
//            CGContextDrawImage(ctx, CGRectMake(0, 0, size.height, size.width), CGImage)
//            break
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0, 0, size.width, size.height), CGImage)
//            break
//        }
//
//        let cgImage: CGImageRef = CGBitmapContextCreateImage(ctx)!
//
//        return UIImage(CGImage: cgImage)
//    }

//    func fixedOrientationOfImage() -> UIImage {
//        if imageOrientation == UIImageOrientation.up {
//            return self
//        }
//        var transform: CGAffineTransform = CGAffineTransform.identity
//        switch imageOrientation {
//        case UIImageOrientation.down, UIImageOrientation.downMirrored:
//            transform = transform.translatedBy(x: size.width, y: size.height)
//            transform = transform.rotated(by: CGFloat(Double.pi))
//            break
//        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
//            transform = transform.translatedBy(x: size.width, y: 0)
//            transform = transform.rotated(by: CGFloat(Double.pi / 2))
//            break
//        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
//            transform = transform.translatedBy(x: 0, y: size.height)
//            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
//            break
//        case UIImageOrientation.up, UIImageOrientation.upMirrored:
//            break
//        }
//
//        switch imageOrientation {
//        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
//            transform.translatedBy(x: size.width, y: 0)
//            transform.scaledBy(x: -1, y: 1)
//            break
//        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
//            transform.translatedBy(x: size.height, y: 0)
//            transform.scaledBy(x: -1, y: 1)
//        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
//            break
//        }
//
//        let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
//
//        ctx.concatenate(transform)
//
//        switch imageOrientation {
//        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
//            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
//            break
//        default:
//            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            break
//        }
//
//        let cgimg:CGImage = ctx.makeImage()!
//        let img:UIImage = UIImage(cgImage: cgimg)
//
//        return img
//    }
//
    
    func fixedOrientationOfImage() -> UIImage? {
        guard imageOrientation != UIImageOrientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

