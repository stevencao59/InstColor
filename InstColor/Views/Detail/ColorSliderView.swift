//
//  ColorSliderView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI
import Combine

struct ColorSliderView: View {
    @Binding var colorValue: Double
    @Binding var colorValueText: String
    
    var keyboardFocusState: FocusState<FocusElement?>.Binding
    
    var containerCotentWidth: Double
    var iconText: String
    var range: ClosedRange<Double>
    var step: Double
    var path: FocusElement?
    
    var setColor: (Double, String) -> Void
    
    init(colorValue: Binding<Double>, colorValueText: Binding<String>, containerCotentWidth: Double, iconText: String, range: ClosedRange<Double>, step: Double, path: FocusElement, keyboardFocusState: FocusState<FocusElement?>.Binding
        , setColor: @escaping (Double, String) -> Void) {
        self._colorValue = colorValue
        self._colorValueText = colorValueText
        
        self.containerCotentWidth = containerCotentWidth
        self.iconText = iconText
        self.range = range
        self.step = step
        self.path = path
        
        self.keyboardFocusState = keyboardFocusState
        
        self.setColor = setColor
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    func onColorValueChanged(val: Double) {
        self.setColor(val, self.iconText)
    }
    
    func onColorValueTextChanged(text: String) {
        let valueText = Double(text)
        if let valueText {
            self.setColor(valueText, self.iconText)
        }
    }
    
    var body: some View {
        HStack {
            Text(iconText)
                .font(.footnote)
                .foregroundColor(.gray)
            
            TextEditor(text: $colorValueText.onChange(onColorValueTextChanged))
                .focused(keyboardFocusState, equals: path)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor(red: 66, green: 66, blue: 66)))
                .frame(width: "0".widthOfString(usingFont: .systemFont(ofSize: defaultFontSize)) * 4)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .cornerRadius(10)
            
            Slider(value: $colorValue.onChange(onColorValueChanged), in: range)
                .frame(maxWidth: .infinity)

            Stepper("", value: $colorValue.onChange(onColorValueChanged), in: range, step: step)
                .labelsHidden()
                .foregroundColor(.white)
                .tint(.white)
        }
        .padding([.horizontal])
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
}

struct ColorSliderView_Previews: PreviewProvider {
    static var focused: FocusState<FocusElement?> = FocusState<FocusElement?>()
    static var previews: some View {
        ColorSliderView(colorValue: .constant(0.05), colorValueText: .constant("255"), containerCotentWidth: 400, iconText: "R", range: 0.0...255.0, step: 0.1, path: .brightness, keyboardFocusState: focused.projectedValue) {_, _ in }
    }
}
