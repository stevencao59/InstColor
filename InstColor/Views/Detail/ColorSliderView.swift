//
//  ColorSliderView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI

struct ColorSliderView: View {
    @State var sliderValue: Double = 0
    
    @Binding var colorValue: Double
    @Binding var colorValueText: String
    @Binding var color: UIColor
    
    var containerCotentWidth: Double
    var iconText: String
    var range: ClosedRange<Double>
    var step: Double
    var setColor: (Double, String) -> Void
    
    init(colorValue: Binding<Double>, colorValueText: Binding<String>, color: Binding<UIColor>, containerCotentWidth: Double, iconText: String, range: ClosedRange<Double>, step: Double, setColor: @escaping (Double, String) -> Void) {
        self._colorValue = colorValue
        self._colorValueText = colorValueText
        self._color = color
        
        self.containerCotentWidth = containerCotentWidth
        self.iconText = iconText
        self.range = range
        self.step = step
        self.setColor = setColor
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    var body: some View {
        HStack {
            Text(iconText)
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
            TextEditor(text: $colorValueText )
                .scrollContentBackground(.hidden)
                .background(Color(UIColor(red: 66, green: 66, blue: 66)))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: containerCotentWidth * 0.12, height: containerCotentWidth * 0.1)
                .cornerRadius(10)
            HStack {
                Slider(value: $sliderValue, in: range)
                    .frame(width: containerCotentWidth * 0.45)
                    .onChange(of: sliderValue) { value in
                        colorValue = value
                    }
                Stepper("", value: $colorValue, in: range, step: step)
                    .foregroundColor(.white)
                    .tint(.white)
            }
        }
        .padding([.horizontal])
        .foregroundColor(.white)
        .frame(width: containerCotentWidth)
        .onAppear() {
            withAnimation {
                sliderValue = colorValue
            }
        }
        .onChange(of: colorValue) { value in
            setColor(value, iconText)
            withAnimation {
                sliderValue = colorValue
            }
        }
        .onChange(of: colorValueText) { text in
            let valueText = Double(text)
            if let valueText {
                withAnimation() {
                    setColor(valueText, iconText)
                }
            }
        }
    }
}

struct ColorSliderView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSliderView(colorValue: .constant(0.05), colorValueText: .constant("255"), color: .constant(UIColor(.white)), containerCotentWidth: 400, iconText: "R", range: 0.0...255.0, step: 0.1) {_, _ in }
    }
}
