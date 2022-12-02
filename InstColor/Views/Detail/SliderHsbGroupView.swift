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
    
    var keyboardFocusState: FocusState<FocusElement?>.Binding
    var containerCotentWidth: Double
    
    func setColor(value: Double, iconText: String) {
        var clampedValue = value
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 360 && iconText == "H" {
            clampedValue = 360
        } else if clampedValue > 100 && ["S", "B"].contains(iconText) {
            clampedValue = 100
        }

        if iconText == "H" {
            color = UIColor(hue: clampedValue / 360, saturation: satuation / 100, brightness: brightness / 100, alpha: 1)
        } else if iconText == "S" {
            color = UIColor(hue: hue / 360, saturation: clampedValue / 100, brightness: brightness / 100, alpha: 1)
        } else if iconText == "B" {
            color = UIColor(hue: hue / 360, saturation: satuation / 100, brightness: clampedValue / 100, alpha: 1)
        }
    }
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $hue, colorValueText: $hueText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "H", range: 0.0...360.0, step: 1, path: .hue, keyboardFocusState: keyboardFocusState, setColor: setColor)
            ColorSliderView(colorValue: $satuation, colorValueText: $satuationText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "S", range: 0.0...100.0, step: 1, path: .satuation, keyboardFocusState: keyboardFocusState, setColor: setColor)
            ColorSliderView(colorValue: $brightness, colorValueText: $brightnessText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "B", range: 0.0...100.0, step: 1, path: .brightness, keyboardFocusState: keyboardFocusState, setColor: setColor)
        }
    }
}

struct SliderHsbGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SliderHsbGroupView(hue: .constant(100), satuation: .constant(100), brightness: .constant(100), hueText: .constant("H"), satuationText: .constant("S"), brightnessText: .constant("B"), color: .constant(.red), keyboardFocusState: FocusState<FocusElement?>().projectedValue, containerCotentWidth: 200)
    }
}
