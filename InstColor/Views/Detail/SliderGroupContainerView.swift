//
//  SliderGroupContainerView.swift
//  InstColor
//
//  Created by Lei Cao on 11/17/22.
//

import SwiftUI

struct SliderGroupContainerView: View {
    @ObservedObject var model: ColorDetailViewModel
    @State private var colorTypeIndex = 0

    var keyboardFocusState: FocusState<FocusElement?>.Binding
    
    var containerCotentWidth: Double
    var colorTypes = ["RGB", "HSB", "CMYK"]
    
    init(model: ColorDetailViewModel, keyboardFocusState: FocusState<FocusElement?>.Binding, containerCotentWidth: Double) {
        self.model = model
        self.keyboardFocusState = keyboardFocusState
        self.containerCotentWidth = containerCotentWidth
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        VStack {
            SegmentedPickerView(preselectedIndex: $colorTypeIndex, options: colorTypes)
                .padding([.horizontal, .bottom])
            
            ZStack {
                if colorTypes[colorTypeIndex] == "RGB" {
                    SliderRgbGroupView(red: $model.red, green: $model.green, blue: $model.blue, redText: $model.redText, greenText: $model.greenText, blueText: $model.blueText, color: $model.color, keyboardFocusState: keyboardFocusState, containerCotentWidth: containerCotentWidth)
                } else if colorTypes[colorTypeIndex] == "HSB" {
                    SliderHsbGroupView(hue: $model.hue, satuation: $model.satuation, brightness: $model.brightness, hueText: $model.hueText, satuationText: $model.satuationText, brightnessText: $model.brightnessText, color: $model.color, keyboardFocusState: keyboardFocusState, containerCotentWidth: containerCotentWidth)
                } else if colorTypes[colorTypeIndex] == "CMYK" {
                    SliderCmykGroupView(cyan: $model.cyan, magenta: $model.magenta, yellow: $model.yellow, key: $model.key, cyanText: $model.cyanText, magentaText: $model.magentaText, yellowText: $model.yellowText, keyText: $model.keyText, color: $model.color, keyboardFocusState: keyboardFocusState, containerCotentWidth: containerCotentWidth)
                }
            }
        }
        .padding([.horizontal])
        .frame(maxWidth: .infinity)
    }
}

struct SliderGroupContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SliderGroupContainerView(model: ColorDetailViewModel(), keyboardFocusState: FocusState<FocusElement?>().projectedValue, containerCotentWidth: 200)
    }
}
