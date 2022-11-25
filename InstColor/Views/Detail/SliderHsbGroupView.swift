//
//  SliderHslGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 11/17/22.
//

import SwiftUI

struct SliderHsbGroupView: View {
    @Binding var hue: Double
    @Binding var satuation: Double
    @Binding var brightness: Double
    
    @Binding var hueText: String
    @Binding var satuationText: String
    @Binding var brightnessText: String
    
    @Binding var color: UIColor

    var containerCotentWidth: Double
    
    func setColor(value: Double, iconText: String) {
        var clampedValue = value
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 1 {
            clampedValue = 1
        }

        if iconText == "H" {
            color = UIColor(hue: clampedValue, saturation: satuation, brightness: brightness, alpha: 1)
        } else if iconText == "S" {
            color = UIColor(hue: hue, saturation: clampedValue, brightness: brightness, alpha: 1)
        } else if iconText == "B" {
            color = UIColor(hue: hue, saturation: satuation, brightness: clampedValue, alpha: 1)
        }
    }
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $hue, colorValueText: $hueText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "H", range: 0.0...1.0, step: 0.01, setColor: setColor)
            ColorSliderView(colorValue: $satuation, colorValueText: $satuationText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "S", range: 0.0...1.0, step: 0.01, setColor: setColor)
            ColorSliderView(colorValue: $brightness, colorValueText: $brightnessText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "B", range: 0.0...1.0, step: 0.01, setColor: setColor)
        }
    }
}

struct SliderHsbGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SliderHsbGroupView(hue: .constant(100), satuation: .constant(100), brightness: .constant(100), hueText: .constant("H"), satuationText: .constant("S"), brightnessText: .constant("B"), color: .constant(.red), containerCotentWidth: 200)
    }
}
