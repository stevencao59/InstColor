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
    @State var sizeWeight = 1
    @State var thumbViewSizeDelta = 0
    @State var showSliderControl = false
    @State var showScaleSlider = false
    
    init(model: ContentViewModel) {
        self.model = model
        self.sizeWeight = Int(model.scaleAmount)
        self.thumbViewSizeDelta = Int(model.thumbViewSizeDelta)
    }
    
    func assignScale(value: Int) {
        model.scaleAmount = Double(value)
    }
    
    func assignDelta(value: Int) {
        model.thumbViewSizeDelta = Double(value)
    }
    
    var body: some View {
        VStack {
            VStack {
                BannerContentView(adUnitId: adUnitID)
                    .padding([.bottom])
                HStack {
                    ToolBarView(model: model, showScaleSlider: $showScaleSlider, showSliderControl: $showSliderControl, containerContentWidth: model.containerCotentWidth)
                }
                if showScaleSlider {
                    SliderView(value: Int(model.scaleAmount), range: 1...5, sliderText: "Scale Size", assign: assignScale)
                        .padding([.horizontal])
                    Group {
                        Divider()
                            .tint(.gray)
                        SliderView(value: Int(model.thumbViewSizeDelta), range: -10...10, sliderText: "Detect Area", assign: assignDelta)
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .foregroundColor(.white)
            .animation(.default, value: showScaleSlider)
            .animation(.default, value: showSliderControl)
            .onChange(of: model.frameSource) { source in
                showSliderControl = model.frameSource == .thumbImage
            }
            Spacer()
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(model: ContentViewModel())
  }
}
