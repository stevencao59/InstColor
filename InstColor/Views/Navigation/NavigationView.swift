//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var model: ContentViewModel

    @State var imageName = "viewfinder"
    @State var sizeWeight: CGFloat = 1
    @State var showSliderControl = false
    @State var showScaleSlider = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if let error = model.error {
                        Text(error.localizedDescription)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding([.horizontal, .bottom])
                    } else {
                        ToolBarView(model: model, imageName: $imageName, showScaleSlider: $showScaleSlider, showSliderControl: $showSliderControl, containerContentWidth: model.containerCotentWidth)
                    }
                }
                if showScaleSlider {
                    ScaleSliderView(sizeWeight: $sizeWeight)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .animation(.default, value: showScaleSlider)
            .animation(.default, value: showSliderControl)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            model.navigationHeight = geo.size.height
                        }
                }
            )
            .onChange(of: sizeWeight) { scale in
                model.scaleAmount = scale
            }
            .onChange(of: model.frameSource) { source in
                showSliderControl = model.frameSource == .thumbImage
            }
            Spacer()
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(model: ContentViewModel(), showSliderControl: true)
  }
}
