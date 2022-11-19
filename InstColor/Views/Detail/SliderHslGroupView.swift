//
//  SliderHslGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 11/17/22.
//

import SwiftUI

struct SliderHslGroupView: View {
    @Binding var hue: Double
    @Binding var satuation: Double
    @Binding var lightness: Double
    
    @Binding var hueText: String
    @Binding var satuationText: String
    @Binding var lightnessText: String
    
    @Binding var color: UIColor

    var containerCotentWidth: Double
    
    func setColor(value: Double, iconText: String) {
        var clampedValue = value
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 360 && iconText == "H" {
            clampedValue = 360
        } else if clampedValue > 1 && ["L", "S"].contains(iconText) {
            clampedValue = 1
        }
        
        var rgbColor: (r: CGFloat, g: CGFloat, b: CGFloat)?
        if iconText == "H" {
            rgbColor = getHlsRgb(h: clampedValue / 360, l: lightness, s: satuation)
        } else if iconText == "S" {
            rgbColor = getHlsRgb(h: hue / 360, l: lightness, s: clampedValue)
        } else if iconText == "L" {
            rgbColor = getHlsRgb(h: hue / 360, l: clampedValue, s: satuation)
        }
        if let rgbColor {
            color = UIColor(red: Int(rgbColor.r * 255), green: Int(rgbColor.g * 255), blue: Int(rgbColor.b * 255))
        }
    }
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $hue, colorValueText: $hueText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "H", range: 0.0...360.0, setColor: setColor)
            ColorSliderView(colorValue: $satuation, colorValueText: $satuationText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "S", range: 0.0...1.0, setColor: setColor)
            ColorSliderView(colorValue: $lightness, colorValueText: $lightnessText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "L", range: 0.0...1.0, setColor: setColor)
        }
    }
}

struct SliderHslGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SliderHslGroupView(hue: .constant(100), satuation: .constant(100), lightness: .constant(100), hueText: .constant("H"), satuationText: .constant("S"), lightnessText: .constant("L"), color: .constant(.red), containerCotentWidth: 200)
    }
}
