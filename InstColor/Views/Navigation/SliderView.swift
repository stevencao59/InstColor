//
//  ViewScaleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/28/22.
//

import SwiftUI

struct SliderView: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let sliderText: String
    
    init(value: Binding<CGFloat>, range: ClosedRange<CGFloat>, sliderText: String) {
        self._value = value
        self.range = range
        self.sliderText = sliderText
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    var body: some View {
        VStack {
            Text(sliderText)
                .bold()
            HStack {
                Slider(value: $value, in: range)
                    .padding([.horizontal])
                Stepper("", value: $value, in: range, step: 0.1)
                    .labelsHidden()
                    .foregroundColor(.white)
                    .tint(.white)
                Text("\(String(format: "%.1f", value)) / \(String(format: "%.1f", range.upperBound))")
            }
        }
        .font(.footnote)
    }
}

struct ViewScaleView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(value: .constant(1.0), range: CGFloat(1.0)...5.0, sliderText: "Test")
    }
}
