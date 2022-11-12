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
    @Published var complementaryColor: UIColor?
    @Published var triadicColor: [UIColor]?
    @Published var splitComplementaryColor: [UIColor]?
    @Published var analogousColor: [UIColor]?
    @Published var tetradicColor: [UIColor]?
    @Published var monochromaticColor: [UIColor]?
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var red: Double = 0
    @Published var green: Double = 0
    @Published var blue: Double = 0
    
    func startSubscription() {
        $color
            .receive(on: RunLoop.main)
            .sink(receiveValue: { color in
                let rgbColor = color.calculateClosestColor()
                self.colorName = rgbColor?.English ?? "Unknown Color"

                self.red = Double(color.components.red * 255)
                self.green = Double(color.components.green * 255)
                self.blue = Double(color.components.blue * 255)
                
                let testColor = UIColor(red: 0, green: 255, blue: 255)
                self.complementaryColor = testColor.getComplementaryColor()
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
