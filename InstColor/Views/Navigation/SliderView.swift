//
//  ViewScaleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/28/22.
//

import SwiftUI
import Combine

class SliderViewModel: ObservableObject {
    @Published var value: Int
    let assign: (Int) -> Void
    private var subscriptions = Set<AnyCancellable>()

    init(value: Int, assign: @escaping (Int) -> Void) {
        self.value = value
        self.assign = assign

        $value
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.assign(value)
            })
            .store(in: &subscriptions)
    }
}

struct SliderView: View {
    @StateObject var model: SliderViewModel

    let range: ClosedRange<Double>
    let sliderText: String

    var intProxy: Binding<Double>{
        Binding<Double>(get: {
            //returns the score as a Double
            return Double(model.value)
        }, set: {
            //rounds the double to an Int
            model.value = Int($0)
        })
    }
    
    init(value: Int, range: ClosedRange<Double>, sliderText: String, assign: @escaping (Int) -> Void) {
        self._model = StateObject(wrappedValue: SliderViewModel(value: value, assign: assign))
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
                Slider(value: intProxy, in: range)
                    .padding([.horizontal])
                Stepper("", value: intProxy, in: range, step: 1)
                    .labelsHidden()
                    .foregroundColor(.white)
                    .tint(.white)
                Text("\(String(model.value)) / \(String(format: "%.0f", range.upperBound))")
            }
        }
        .font(.footnote)
    }
}

struct ViewScaleView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(value: 1, range: CGFloat(1.0)...5.0, sliderText: "Test", assign: { _ in })
    }
}
