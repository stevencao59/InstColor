//
//  UIImage.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import Foundation
import SwiftUI

extension UIImage {
    func cropImage(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> CGImage? {
        let imageViewScale = max(self.size.width / viewWidth,
                                 self.size.height / viewHeight)
        
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale , width: cropRect.size.width * imageViewScale , height: cropRect.size.height * imageViewScale)
        
        guard let cutImageRef: CGImage = self.cgImage?.cropping(to: cropZone)
        else {
            return nil
        }
        let resImage = UIImage(cgImage: cutImageRef, scale: self.imageRendererFormat.scale, orientation: self.imageOrientation)
        return resImage.cgImage
    }
    
    func convertToCgImage() -> CGImage? {
        let ciImage = CIImage(image: self)
        let context = CIContext(options: nil)
        if let ciImage {
            return context.createCGImage(ciImage, from: ciImage.extent)
        }
        return nil
    }
}
