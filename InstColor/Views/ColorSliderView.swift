//
//  ColorSliderView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI

struct ColorSliderGroupView: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    @Binding var redText: String
    @Binding var greenText: String
    @Binding var blueText: String
    
    @Binding var color: UIColor

    var containerCotentWidth: Double
    
    var body: some View {
        VStack {
            ColorSliderView(colorValue: $red, colorValueText: $redText, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.red))
            ColorSliderView(colorValue: $green, colorValueText: $greenText, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.green))
            ColorSliderView(colorValue: $blue, colorValueText: $blueText, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.blue))
        }
    }
}

struct ColorSliderView: View {
    @Binding var colorValue: Double
    @Binding var color: UIColor
    @Binding var colorValueText: String
    
    @State var sliderValue: Double = 0
    
    var containerCotentWidth: Double
    var iconColor: Color
    
    let range = 0.0...255.0
    
    init(colorValue: Binding<Double>, colorValueText: Binding<String>, color: Binding<UIColor>, containerCotentWidth: Double, iconColor: Color) {
        self._colorValue = colorValue
        self._colorValueText = colorValueText
        self._color = color
        
        self.containerCotentWidth = containerCotentWidth
        self.iconColor = iconColor
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    func setColor(value: Double) {
        var clampedValue = value
        if clampedValue < 0 {
            clampedValue = 0
        } else if clampedValue > 255 {
            clampedValue = 255
        }
        if iconColor == Color(.red) {
            color = UIColor(red: Int(clampedValue), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255))
        } else if iconColor == Color(.green) {
            color = UIColor(red: Int(color.components.red * 255), green: Int(clampedValue), blue: Int(color.components.blue * 255))
        } else if iconColor == Color(.blue) {
            color = UIColor(red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(clampedValue))
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(iconColor)
                .frame(width: 10)
            Spacer()
            TextEditor(text: $colorValueText )
                .scrollContentBackground(.hidden)
                .background(Color(UIColor(red: 66, green: 66, blue: 66)))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: containerCotentWidth * 0.11, height: containerCotentWidth * 0.1)
                .cornerRadius(10)
            HStack {
                Slider(value: $sliderValue, in: range)
                    .frame(width: containerCotentWidth * 0.45)
                    .onChange(of: sliderValue) { value in
                        colorValue = value
                    }
                Stepper("", value: $colorValue, in: range)
                    .foregroundColor(.white)
                    .tint(.white)
            }
        }
        .padding([.horizontal])
        .foregroundColor(.white)
        .frame(width: containerCotentWidth)
        .onChange(of: colorValue) { value in
            setColor(value: value)
            withAnimation {
                sliderValue = colorValue
            }
        }
        .onChange(of: colorValueText) { text in
            let valueText = Double(text)
            if let valueText {
                withAnimation() {
                    setColor(value: valueText)
                }
            }
        }
    }
}

struct ColorSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSliderView(colorValue: .constant(0.05), colorValueText: .constant("255"), color: .constant(UIColor(.white)), containerCotentWidth: 400, iconColor: Color(.white))
    }
}
