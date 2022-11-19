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
    @Published var lightness: Double = 0
    
    @Published var hueText: String = "0"
    @Published var satuationText: String = "0"
    @Published var lightnessText: String = "0"
    
    @Published var colorHexString: String = ""
    
    func startSubscription() {
        $color
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                self.red = Double(color.components.red * 255)
                self.green = Double(color.components.green * 255)
                self.blue = Double(color.components.blue * 255)
                
                self.redText = "\("\(String(format: "%.0f", self.red))")"
                self.greenText = "\("\(String(format: "%.0f", self.green))")"
                self.blueText = "\("\(String(format: "%.0f", self.blue))")"
                
                let hsl = getRgbHls(r: color.components.red, g: color.components.green, b: color.components.blue)
                self.hue = Double(hsl.h * 360)
                self.satuation = hsl.s
                self.lightness = hsl.l
                
                self.hueText = "\("\(String(format: "%.0f", self.hue))")"
                self.satuationText = "\("\(String(format: "%.2f", self.satuation))")"
                self.lightnessText = "\("\(String(format: "%.2f", self.lightness))")"
                
                self.colorHexString = color.toHexString() ?? "Unknown Hex"
                
                let rgbColor = color.calculateClosestColor()
                self.colorName = rgbColor?.English ?? "Unknown Color"
                
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
        startSubscription()
    }
    
}
