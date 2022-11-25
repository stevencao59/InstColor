//
//  SliderGroupContainerView.swift
//  InstColor
//
//  Created by Lei Cao on 11/17/22.
//

import SwiftUI

struct SliderGroupContainerView: View {
    @ObservedObject var model: ColorDetailViewModel
    @State private var colorType = "RGB"
    
    var containerCotentWidth: Double
    var colorTyes = ["RGB", "HSL"]
    
    init(model: ColorDetailViewModel, containerCotentWidth: Double) {
        self.model = model
        self.containerCotentWidth = containerCotentWidth

        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        VStack {
            Picker("Color Type", selection: $colorType) {
                ForEach(colorTyes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)

            if colorType == "RGB" {
                SliderRgbGroupView(red: $model.red, green: $model.green, blue: $model.blue, redText: $model.redText, greenText: $model.greenText, blueText: $model.blueText, color: $model.color, containerCotentWidth: containerCotentWidth)
            } else if colorType == "HSL" {
                SliderHsbGroupView(hue: $model.hue, satuation: $model.satuation, brightness: $model.brightness, hueText: $model.hueText, satuationText: $model.satuationText, brightnessText: $model.brightnessText, color: $model.color, containerCotentWidth: containerCotentWidth)
            }
        }
        .padding([.horizontal])
        .frame(width: containerCotentWidth / 2)
        .animation(.default, value: colorType)
    }
}

struct SliderGroupContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SliderGroupContainerView(model: ColorDetailViewModel(), containerCotentWidth: 200)
    }
}
