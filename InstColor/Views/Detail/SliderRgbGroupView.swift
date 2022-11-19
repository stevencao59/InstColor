//
//  SliderRgbGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 11/17/22.
//

import SwiftUI

struct SliderRgbGroupView: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    @Binding var redText: String
    @Binding var greenText: String
    @Binding var blueText: String
    
    @Binding var color: UIColor

    var containerCotentWidth: Double
    
    func setColor(value: Double, iconText: String) {
        var clampedValue = value
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 255 {
            clampedValue = 255
        }
        if iconText == "R" {
            color = UIColor(red: Int(clampedValue), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255))
        } else if iconText == "G" {
            color = UIColor(red: Int(color.components.red * 255), green: Int(clampedValue), blue: Int(color.components.blue * 255))
        } else if iconText == "B" {
            color = UIColor(red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(clampedValue))
        }
    }
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $red, colorValueText: $redText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "R", range: 0.0...255.0, setColor: setColor)
            ColorSliderView(colorValue: $green, colorValueText: $greenText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "G", range: 0.0...255.0, setColor: setColor)
            ColorSliderView(colorValue: $blue, colorValueText: $blueText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "B", range: 0.0...255.0, setColor: setColor)
        }
    }
}

struct SliderRgbGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SliderRgbGroupView(red: .constant(100), green: .constant(100), blue: .constant(100), redText: .constant("R"), greenText: .constant("G"), blueText: .constant("B"), color: .constant(.red), containerCotentWidth: 200)
    }
}
