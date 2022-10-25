//
//  CIImage.swift
//  InstColor
//
//  Created by Lei Cao on 10/24/22.
//

import Foundation
import CoreImage

extension CIImage {
    func convertToCGImage() -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: self.extent) {
            return cgImage
        }
        return nil
    }
}
