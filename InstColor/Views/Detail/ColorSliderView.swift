//
//  ColorSliderView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI
import Combine

class ColorSliderViewObject: ObservableObject {
    @Published var value: Double = 0.0
    @Published var valueText: String = ""
    
    var iconText: String
    var setColor: (Double, String) -> Void
    
    private var subscriptions = Set<AnyCancellable>()
    
    func startSubscription() {
        $value
            .debounce(for: .seconds(0.2) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.setColor(value, self.iconText)
            })
            .store(in: &subscriptions)
        
        $valueText
            .debounce(for: .seconds(0.2) , scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { text in
                let valueText = Double(text)
                if let valueText {
                    self.setColor(valueText, self.iconText)
                }
            })
            .store(in: &subscriptions)
    }
    
    init(value: Double, valueText: String, iconText: String, setColor: @escaping (Double, String) -> Void) {
        self.value = value
        self.valueText = valueText
        self.iconText = iconText
        self.setColor = setColor
        self.startSubscription()
    }
}

struct ColorSliderView: View {
    @StateObject var model: ColorSliderViewObject
    
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
        self._model = StateObject(wrappedValue: ColorSliderViewObject(value: colorValue.wrappedValue, valueText: colorValueText.wrappedValue, iconText: iconText, setColor: setColor))
        
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
    
    var body: some View {
        HStack {
            Text(iconText)
                .font(.footnote)
                .foregroundColor(.gray)
            
            TextEditor(text: $colorValueText)
                .focused(keyboardFocusState, equals: path)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor(red: 66, green: 66, blue: 66)))
                .frame(width: "0".widthOfString(usingFont: .systemFont(ofSize: defaultFontSize)) * 4)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .cornerRadius(10)
            
            Slider(value: $colorValue, in: range)
                .frame(maxWidth: .infinity)

            Stepper("", value: $colorValue, in: range, step: step)
                .labelsHidden()
                .foregroundColor(.white)
                .tint(.white)
        }
        .padding([.horizontal])
        .foregroundColor(.white)
        .frame(width: containerCotentWidth)
        .onChange(of: colorValue) { value in
            model.value = value
        }
        .onChange(of: colorValueText) { text in
            model.valueText = text
        }
    }
}

struct ColorSliderView_Previews: PreviewProvider {
    static var focused: FocusState<FocusElement?> = FocusState<FocusElement?>()
    static var previews: some View {
        ColorSliderView(colorValue: .constant(0.05), colorValueText: .constant("255"), containerCotentWidth: 400, iconText: "R", range: 0.0...255.0, step: 0.1, path: .brightness, keyboardFocusState: focused.projectedValue) {_, _ in }
    }
}
