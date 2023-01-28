//
//  SliderCmykGroupView.swift
//  InstColor
//
//  Created by Lei Cao on 1/24/23.
//

import SwiftUI

struct SliderCmykGroupView: View {
    @Binding var cyan: Double
    @Binding var magenta: Double
    @Binding var yellow: Double
    @Binding var key: Double
    
    @Binding var cyanText: String
    @Binding var magentaText: String
    @Binding var yellowText: String
    @Binding var keyText: String
    
    @Binding var color: UIColor
    
    var keyboardFocusState: FocusState<FocusElement?>.Binding
    var containerCotentWidth: Double
    
    func setColor(value: Double, iconText: String) {
        var clampedValue = Double(Int(value))
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 100{
            clampedValue = 100
        }
        
        var convertRgb: (r: CGFloat, g: CGFloat, b: CGFloat) = (r: 0, g: 0, b: 0)
        if iconText == "C" {
            convertRgb = getCmykRgb(c: clampedValue, m: magenta, y: yellow, k: key)
        } else if iconText == "M" {
            convertRgb = getCmykRgb(c: cyan, m: clampedValue, y: yellow, k: key)
        } else if iconText == "Y" {
            convertRgb = getCmykRgb(c: cyan, m: magenta, y: clampedValue, k: key)
        } else if iconText == "K" {
            convertRgb = getCmykRgb(c: cyan, m: magenta, y: yellow, k: clampedValue)
        }
        color = UIColor(red: Int(convertRgb.r), green: Int(convertRgb.g), blue: Int(convertRgb.b))
    }
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $cyan, colorValueText: $cyanText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "C", range: 0.0...100, step: 1, path: .cyan, keyboardFocusState: keyboardFocusState, setColor: setColor)
            ColorSliderView(colorValue: $magenta, colorValueText: $magentaText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "M", range: 0.0...100.0, step: 1, path: .magenta, keyboardFocusState: keyboardFocusState, setColor: setColor)
            ColorSliderView(colorValue: $yellow, colorValueText: $yellowText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "Y", range: 0.0...100.0, step: 1, path: .yellow, keyboardFocusState: keyboardFocusState, setColor: setColor)
            ColorSliderView(colorValue: $key, colorValueText: $keyText, color: $color, containerCotentWidth: containerCotentWidth, iconText: "K", range: 0.0...100.0, step: 1, path: .key, keyboardFocusState: keyboardFocusState, setColor: setColor)
        }
    }
}

struct SliderCmykGroupView_Previews: PreviewProvider {
    static var previews: some View {
        SliderCmykGroupView(cyan: .constant(50), magenta: .constant(50), yellow: .constant(50), key: .constant(50), cyanText: .constant("C"), magentaText: .constant("M"), yellowText: .constant("Y"), keyText: .constant("key"), color: .constant(.yellow), keyboardFocusState: FocusState<FocusElement?>().projectedValue, containerCotentWidth: 200)
    }
}
