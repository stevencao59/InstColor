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

// Color converting
extension UIColor {
    func normalize(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        var output = value
        if value > max {
            output = max
        } else if value < min {
            output = min
        }
        return output
    }
    
    private func getColorGeneric(hueValues: [CGFloat]) throws -> [UIColor] {
        let hls = getRgbHls(r: self.components.red, g: self.components.green, b: self.components.blue)
        
        var resultList: [(r: CGFloat, g: CGFloat, b: CGFloat)] = []
        for value in hueValues {
            var convertedVal = (hls.h * 360 + value) %% 360
            convertedVal = convertedVal / 360
            let newHls = (h: convertedVal, l: hls.l, s: hls.s)
            resultList.append(getHlsRgb(h: newHls.h, l: newHls.l, s: newHls.s))
        }
        let result = resultList.map { UIColor(red: Int($0.r * 255), green: Int($0.g * 255), blue: Int($0.b * 255)) }
        return result
    }
    
    private func getMonochromaticColorGeneric() throws -> [UIColor]? {
        let hsv = getRgbHsv(r: self.components.red, g: self.components.green, b: self.components.blue)
        let increment = [0, 0.1]
        
        var result: [(r: CGFloat, g: CGFloat, b: CGFloat)] = []
        var output: [(r: CGFloat, g: CGFloat, b: CGFloat)] = []
        
        for x in increment {
            for y in increment {
                let h = hsv.h
                let s1 = normalize(value: hsv.s, min: 0, max: 100) + x
                let v1 = normalize(value: hsv.v + y, min: 0, max: 100)
                let rgb1 = getHsvRgb(h: h, s: s1, v: v1)
                let item1 = [rgb1.r, rgb1.g, rgb1.b].map { normalize(value: round($0 * 255), min: 0, max: 255) }
                
                let s2 = normalize(value: hsv.s, min: 0, max: 100) - x
                let v2 = normalize(value: hsv.v - y, min: 0, max: 100)
                let rgb2 = getHsvRgb(h: h, s: s2, v: v2)
                let item2 = [rgb2.r, rgb2.g, rgb2.b].map { normalize(value: round($0 * 255), min: 0, max: 255) }
                
                result.append((r: item1[0], g: item1[1], b: item1[2]))
                result.append((r: item2[0], g: item2[1], b: item2[2]))
            }
        }
        
        for c in result {
            let contains = output.contains {
                $0.r == c.r && $0.g == c.g && $0.b == c.b
            }
            if !contains {
                output.append(c)
            }
        }

        let convOutput = output.map { UIColor(red: Int($0.r), green: Int($0.g), blue: Int($0.b)) }
        return convOutput
    }
    
    
    func getComplementaryColor() -> [UIColor]? {
        return try? getColorGeneric(hueValues: [180])
    }
    
    func getTriadicColor() -> [UIColor]? {
        return try? getColorGeneric(hueValues: [120, 240])
    }
    
    func getSplitComplementaryColor() -> [UIColor]? {
        return try? getColorGeneric(hueValues: [150, 210])
    }
    
    func getAnalogousColor() -> [UIColor]? {
        return try? getColorGeneric(hueValues: [30, -30])
    }
    
    func getTetradicColor() -> [UIColor]? {
        return try? getColorGeneric(hueValues: [60, 180, 240])
    }
    
    func getMonochromaticColor() -> [UIColor]? {
        return try? getMonochromaticColorGeneric()
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
    
    func toHexString() -> String? {
        guard let components = self.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
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
    
    func calculateClosestColor() -> (Color: String, BaseColor: String, BaseColorHex: String, Red: Int, Green: Int, Blue: Int) {
        let colorMap: [RGBColor] = Bundle.main.decode("color.json")
        let closestColor = colorMap.reduce(colorMap[0]) { prevItem, currItem in
            let prevAvg = getWeightedAverage(prevItem.Red, prevItem.Green, prevItem.Blue)
            let currAvg = getWeightedAverage(currItem.Red, currItem.Green, currItem.Blue)
            
            return currAvg < prevAvg ? currItem : prevItem
        }
        return (
            closestColor.Color.removeLastInt(),
            closestColor.BaseColor,
            closestColor.BaseColorHex,
            closestColor.Red,
            closestColor.Green,
            closestColor.Blue
        )
    }
    
    func getColorComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        return (r, g, b, a)
    }
    
    func combine(with color: UIColor, amount: CGFloat) -> UIColor {
        let fromComponents = self.getColorComponents()
        let toComponents = color.getColorComponents()
        
        let redAmount = lerp(from: fromComponents.red,
                             to: toComponents.red, alpha: amount)
        let greenAmount = lerp(from: fromComponents.green, to: toComponents.green, alpha: amount)
        let blueAmount = lerp(from: fromComponents.blue, to: toComponents.blue, alpha: amount)
        
        let color = UIColor(red: redAmount, green: greenAmount, blue: blueAmount, alpha:  1)
        return color
    }
}
