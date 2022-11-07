//
//  AverageColor.swift
//  InstColor
//
//  Created by Lei Cao on 10/2/22.
//

import Foundation

import UIKit

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.width, w: inputImage.extent.height)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func getWeightedAverage(_ red: Int, _ green: Int, _ blue: Int) -> Double {
        let doubleRed = Double(red)
        let weightedRed = 0.3 * pow(doubleRed - (self.components.red * 255.0), 2)
        
        let doubleGreen = Double(green)
        let weightedGreen = 0.59 * pow(doubleGreen - (self.components.green * 255.0), 2)
        
        let doubleBlue = Double(blue)
        let weightedBlue = 0.11 * pow(doubleBlue - (self.components.blue * 255.0), 2)
        
        return weightedRed + weightedGreen + weightedBlue
    }
    
    func calculateClosestColor() -> RGBColor? {
        let colorMap: [RGBColor] = Bundle.main.decode("color.json")
        let closestColor = colorMap.reduce(colorMap[0]) { prevItem, currItem in
            let prevAvg = getWeightedAverage(prevItem.Red, prevItem.Green, prevItem.Blue)
            let currAvg = getWeightedAverage(currItem.Red, currItem.Green, currItem.Blue)
            
            return currAvg < prevAvg ? currItem : prevItem
        }
        return closestColor
    }
}
