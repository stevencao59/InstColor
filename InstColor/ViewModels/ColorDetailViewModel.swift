//
//  ColorDetailViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 11/10/22.
//

import Foundation
import SwiftUI
import Combine

class ColorDetailViewModel: ObservableObject {
    @Published var color: UIColor = .white
    @Published var colorName: String?
    @Published var baseColorName: String?
    
    // All related convertable colors
    @Published var complementaryColor: [UIColor]?
    @Published var triadicColor: [UIColor]?
    @Published var splitComplementaryColor: [UIColor]?
    @Published var analogousColor: [UIColor]?
    @Published var tetradicColor: [UIColor]?
    @Published var monochromaticColor: [UIColor]?
    
    private var subscriptions = Set<AnyCancellable>()
    
    // Rgb color properties
    @Published var red: Double = 0
    @Published var green: Double = 0
    @Published var blue: Double = 0
    
    @Published var redText: String = "0"
    @Published var greenText: String = "0"
    @Published var blueText: String = "0"
    
    // Hsl color properties
    @Published var hue: Double = 0
    @Published var satuation: Double = 0
    @Published var brightness: Double = 0
    
    @Published var hueText: String = "0"
    @Published var satuationText: String = "0"
    @Published var brightnessText: String = "0"
    
    // CMYK color properties
    @Published var cyan: Double = 0
    @Published var magenta: Double = 0
    @Published var yellow: Double = 0
    @Published var key: Double = 0
    
    @Published var cyanText: String = "0"
    @Published var magentaText: String = "0"
    @Published var yellowText: String = "0"
    @Published var keyText: String = "0"
    
    // Hex color properties
    @Published var colorHexString: String = ""
    
    // Debounce frequency
    let debounceSeconds = 0.1
    
    // Color map json object
    let colorMap: [RGBColor]
    
    @Published var colorInfos: [ColorInfo] = [
        ColorInfo(InfoName: "RGB", Value: ""),
        ColorInfo(InfoName: "HEX", Value: ""),
        ColorInfo(InfoName: "HSB", Value: ""),
        ColorInfo(InfoName: "CMYK", Value: ""),
        ColorInfo(InfoName: "XYZ", Value: ""),
        ColorInfo(InfoName: "LAB", Value: ""),
    ]
    
    func assignColorInfo(infoName: String, value: String) {
        if let row = self.colorInfos.firstIndex(where: {$0.InfoName == infoName}) {
            self.colorInfos[row] = ColorInfo(InfoName: infoName, Value: value)
        }
        self.objectWillChange.send()
    }
    
    func assignHex() {
        self.colorHexString = color.toHexString() ?? "Unknown Hex"
        self.assignColorInfo(infoName: "HEX", value: "#\("\(self.colorHexString)")")
    }
    
    func assignHsb() {
        var hue: CGFloat = 0.0
        var satuation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        color.getHue(&hue, saturation: &satuation, brightness: &brightness, alpha: &alpha)
        self.hue = self.hue == 360 ? 360 : hue * 360
        self.satuation = satuation * 100
        self.brightness = brightness * 100
        
        self.hueText = "\("\(String(format: "%.0f", self.hue))")"
        self.satuationText = "\("\(String(format: "%.0f", self.satuation))")"
        self.brightnessText = "\("\(String(format: "%.0f", self.brightness))")"
        
        self.assignColorInfo(infoName: "HSB", value: "\("\(self.hueText)")°, \("\(self.satuationText)")%, \("\(self.brightnessText)")%")
        
        self.red = Double(color.components.red * 255)
        self.green = Double(color.components.green * 255)
        self.blue = Double(color.components.blue * 255)
        
        self.redText = "\("\(String(format: "%.0f", self.red))")"
        self.greenText = "\("\(String(format: "%.0f", self.green))")"
        self.blueText = "\("\(String(format: "%.0f", self.blue))")"
        
        self.assignColorInfo(infoName: "RGB", value: "\("\(self.redText)"), \("\(self.greenText)"), \("\(self.blueText)")")
    }
    
    func assignRgb() {
        self.red = Double(color.components.red * 255)
        self.green = Double(color.components.green * 255)
        self.blue = Double(color.components.blue * 255)
        
        self.redText = "\("\(String(format: "%.0f", self.red))")"
        self.greenText = "\("\(String(format: "%.0f", self.green))")"
        self.blueText = "\("\(String(format: "%.0f", self.blue))")"
        
        self.assignColorInfo(infoName: "RGB", value: "\("\(self.redText)"), \("\(self.greenText)"), \("\(self.blueText)")")
    }
    
    func assignCmyk() {
        let cmykValue = getRgbCmyk(r: color.components.red * 255, g: color.components.green * 255, b: color.components.blue * 255)

        self.cyan = Double(Int(cmykValue.c))
        self.magenta = Double(Int(cmykValue.m))
        self.yellow = Double(Int(cmykValue.y))
        self.key = Double(Int(cmykValue.k))
        
        self.cyanText = "\("\(String(format: "%.0f", self.cyan))")"
        self.magentaText = "\("\(String(format: "%.0f", self.magenta))")"
        self.yellowText = "\("\(String(format: "%.0f", self.yellow))")"
        self.keyText = "\("\(String(format: "%.0f", self.key))")"

        self.assignColorInfo(infoName: "CMYK", value: "\("\(self.cyanText)")%, \("\(self.magentaText)")%, \("\(self.yellowText)")%, \("\(self.keyText)")%")
    }
    
    func assignXyz() {
        let xyzValue = getRgbXyz(r: color.components.red, g: color.components.green, b: color.components.blue)
        self.assignColorInfo(infoName: "XYZ", value: "\("\(String(format: "%.0f", xyzValue.x))")%, \("\(String(format: "%.0f", xyzValue.y))")%, \("\(String(format: "%.0f", xyzValue.z))")%")
    }
    
    func assignLab() {
        let labValue = getRgbLab(r: color.components.red, g: color.components.green, b: color.components.blue)
        self.assignColorInfo(infoName: "LAB", value: "\("\(String(format: "%.0f", labValue.l))")%, \("\(String(format: "%.0f", labValue.a))")%, \("\(String(format: "%.0f", labValue.b))")%")
    }
    
    func startSubscription() {
        $color
            .debounce(for: .seconds(debounceSeconds) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                self.assignHex()
                self.assignHsb()
                self.assignRgb()
                self.assignCmyk()
                self.assignXyz()
                self.assignLab()
            })
            .store(in: &subscriptions)

        $color
            .debounce(for: .seconds(debounceSeconds) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                let rgbColor = color.calculateClosestColor(colorMap: self.colorMap)
                self.colorName = rgbColor.Color
                self.baseColorName = rgbColor.BaseColor

                self.complementaryColor = color.getComplementaryColor()
                self.triadicColor = color.getTriadicColor()
                self.splitComplementaryColor = color.getSplitComplementaryColor()
                self.analogousColor = color.getAnalogousColor()
                self.tetradicColor = color.getTetradicColor()
                self.monochromaticColor = color.getMonochromaticColor()
            })
            .store(in: &subscriptions)
    }
    
    init() {
        self.colorMap = Bundle.main.decode("color.json")
        startSubscription()
    }
    
}
