//
//  ColorResultViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 10/8/22.
//

import Foundation
import SwiftUI

class ColorResultViewModel: ObservableObject {
    private var colorMap: [RGBColor] = Bundle.main.decode("color.json")
    @Published var color: UIColor = UIColor(.white)
    @Published var colorName: String?
    
    func getWeightedAverage(_ red: Int, _ green: Int, _ blue: Int) -> Double {
        let doubleRed = Double(red)
        let weightedRed = 0.3 * pow(doubleRed - (color.components.red * 255.0), 2)
        
        let doubleGreen = Double(green)
        let weightedGreen = 0.59 * pow(doubleGreen - (color.components.green * 255.0), 2)
        
        let doubleBlue = Double(blue)
        let weightedBlue = 0.11 * pow(doubleBlue - (color.components.blue * 255.0), 2)
        
        return weightedRed + weightedGreen + weightedBlue
    }
    
    func calculateClosestColor(_ color: UIColor) -> RGBColor? {
        let closestColor = colorMap.reduce(colorMap[0]) { prevItem, currItem in
            let prevAvg = getWeightedAverage(prevItem.Red, prevItem.Green, prevItem.Blue)
            let currAvg = getWeightedAverage(currItem.Red, currItem.Green, currItem.Blue)
            
            return currAvg < prevAvg ? currItem : prevItem
        }
        return closestColor
    }
    
    init() {
        $color
            .receive(on: RunLoop.main)
            .map { color in
                let closestColor = self.calculateClosestColor(color)
                return closestColor?.English
            }
            .assign(to: &$colorName)
    }
}
