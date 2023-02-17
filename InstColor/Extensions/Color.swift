//
//  AverageColor.swift
//  InstColor
//
//  Created by Lei Cao on 10/2/22.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.width, w: inputImage.extent.height)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    var averageColorLinear: UIColor? {
        guard let cgImage = cgImage else { return nil }
        
        // First, resize the image. We do this for two reasons, 1) less pixels to deal with means faster calculation and a resized image still has the "gist" of the colors, and 2) the image we're dealing with may come in any of a variety of color formats (CMYK, ARGB, RGBA, etc.) which complicates things, and redrawing it normalizes that into a base color format we can deal with.
        // 40x40 is a good size to resize to still preserve quite a bit of detail but not have too many pixels to deal with. Aspect ratio is irrelevant for just finding average color.
        let size = CGSize(width: 40, height: 40)
        
        let width = Int(size.width)
        let height = Int(size.height)
        let totalPixels = width * height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // ARGB format
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        // 8 bits for each color channel, we're doing ARGB so 32 bits (4 bytes) total, and thus if the image is n pixels wide, and has 4 bytes per pixel, the total bytes per row is 4n. That gives us 2^8 = 256 color variations for each RGB channel or 256 * 256 * 256 = ~16.7M color options in total. That seems like a lot, but lots of HDR movies are in 10 bit, which is (2^10)^3 = 1 billion color options!
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        // Draw our resized image
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        guard let pixelBuffer = context.data else { return nil }
        
        // Bind the pixel buffer's memory location to a pointer we can use/access
        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        // Keep track of total colors (note: we don't care about alpha and will always assume alpha of 1, AKA opaque)
        var totalRed = 0
        var totalBlue = 0
        var totalGreen = 0
        
        // Column of pixels in image
        for x in 0 ..< width {
            // Row of pixels in image
            for y in 0 ..< height {
                // To get the pixel location just think of the image as a grid of pixels, but stored as one long row rather than columns and rows, so for instance to map the pixel from the grid in the 15th row and 3 columns in to our "long row", we'd offset ourselves 15 times the width in pixels of the image, and then offset by the amount of columns
                let pixel = pointer[(y * width) + x]
                
                let r = red(for: pixel)
                let g = green(for: pixel)
                let b = blue(for: pixel)
                
                totalRed += Int(r)
                totalBlue += Int(b)
                totalGreen += Int(g)
            }
        }
        
        let averageRed: CGFloat
        let averageGreen: CGFloat
        let averageBlue: CGFloat
        
        
        averageRed = CGFloat(totalRed) / CGFloat(totalPixels)
        averageGreen = CGFloat(totalGreen) / CGFloat(totalPixels)
        averageBlue = CGFloat(totalBlue) / CGFloat(totalPixels)
        
        
        // Convert from [0 ... 255] format to the [0 ... 1.0] format UIColor wants
        return UIColor(red: round(averageRed) / 255.0, green: round(averageGreen) / 255.0, blue: round(averageBlue) / 255.0, alpha: 1.0)
    }
     
     private func red(for pixelData: UInt32) -> UInt8 {
         // For a quick primer on bit shifting and what we're doing here, in our ARGB color format image each pixel's colors are stored as a 32 bit integer, with 8 bits per color chanel (A, R, G, and B).
         //
         // So a pure red color would look like this in bits in our format, all red, no blue, no green, and 'who cares' alpha:
         //
         // 11111111 11111111 00000000 00000000
         //  ^alpha   ^red     ^blue    ^green
         //
         // We want to grab only the red channel in this case, we don't care about alpha, blue, or green. So we want to shift the red bits all the way to the right in order to have them in the right position (we're storing colors as 8 bits, so we need the right most 8 bits to be the red). Red is 16 points from the right, so we shift it by 16 (for the other colors, we shift less, as shown below).
         //
         // Just shifting would give us:
         //
         // 00000000 00000000 11111111 11111111
         //  ^alpha   ^red     ^blue    ^green
         //
         // The alpha got pulled over which we don't want or care about, so we need to get rid of it. We can do that with the bitwise AND operator (&) which compares bits and the only keeps a 1 if both bits being compared are 1s. So we're basically using it as a gate to only let the bits we want through. 255 (below) is the value we're using as in binary it's 11111111 (or in 32 bit, it's 00000000 00000000 00000000 11111111) and the result of the bitwise operation is then:
         //
         // 00000000 00000000 11111111 11111111
         // 00000000 00000000 00000000 11111111
         // -----------------------------------
         // 00000000 00000000 00000000 11111111
         //
         // So as you can see, it only keeps the last 8 bits and 0s out the rest, which is what we want! Woohoo! (It isn't too exciting in this scenario, but if it wasn't pure red and was instead a red of value "11010010" for instance, it would also mirror that down)
         return UInt8((pixelData >> 16) & 255)
     }

     private func green(for pixelData: UInt32) -> UInt8 {
         return UInt8((pixelData >> 8) & 255)
     }

     private func blue(for pixelData: UInt32) -> UInt8 {
         return UInt8((pixelData >> 0) & 255)
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
        let increment = [0, 0.05, 0.1]
        
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
    
    func calculateClosestColor(colorMap: [RGBColor]) -> (Color: String, BaseColor: String, BaseColorHex: String, Red: Int, Green: Int, Blue: Int) {
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
        
        let redAmount = clamp(value: lerp(from: fromComponents.red,
                                          to: toComponents.red, alpha: amount), greater: 0, less: 1)
        let greenAmount = clamp(value: lerp(from: fromComponents.green, to: toComponents.green, alpha: amount), greater: 0, less: 1)
        let blueAmount = clamp(value: lerp(from: fromComponents.blue, to: toComponents.blue, alpha: amount), greater: 0, less: 1)
        
        let color = UIColor(red: redAmount, green: greenAmount, blue: blueAmount, alpha:  1)
        return color
    }
    
    func toDisplayP3HexString() -> String? {
        guard let displayP3Color = self.cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil) else {
            return ""
        }
        return UIColor(cgColor: displayP3Color).toHexString() ?? ""
    }
    
    func toHSL() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
        var (h, s, b) = (CGFloat(), CGFloat(), CGFloat())
        getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        
        let l = ((2.0 - s) * b) / 2.0

        switch l {
        case 0.0, 1.0:
            s = 0.0
        case 0.0..<0.5:
            s = (s * b) / (l * 2.0)
        default:
            s = (s * b) / (2.0 - l * 2.0)
        }

        return (hue: h * 360.0,
                   saturation: s * 100.0,
                   lightness: l * 100.0)
    }
}
