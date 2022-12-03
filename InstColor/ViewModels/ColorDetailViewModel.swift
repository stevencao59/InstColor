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
    @Published var baseColoeNsme: String?
    
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
    
    @Published var colorHexString: String = ""
    
    func startSubscription() {
        $color
            .debounce(for: .seconds(0.1) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                self.colorHexString = color.toHexString() ?? "Unknown Hex"
            })
            .store(in: &subscriptions)
        
        $color
            .debounce(for: .seconds(0.1) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
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
            })
            .store(in: &subscriptions)
        
        $color
            .debounce(for: .seconds(0.1) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                self.red = Double(color.components.red * 255)
                self.green = Double(color.components.green * 255)
                self.blue = Double(color.components.blue * 255)
                
                self.redText = "\("\(String(format: "%.0f", self.red))")"
                self.greenText = "\("\(String(format: "%.0f", self.green))")"
                self.blueText = "\("\(String(format: "%.0f", self.blue))")"
            })
            .store(in: &subscriptions)
    
        $color
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { color in
                let rgbColor = color.calculateClosestColor()
                self.colorName = rgbColor.Color
                
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
