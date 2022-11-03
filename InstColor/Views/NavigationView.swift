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

    var showScaleSlider: Bool {
        return model.frameSource != .wholeImage
    }
    
    let defaultThumbFrameSize = 20.0
    
    func switchCameraPosition() {
        model.cameraManager.cameraPosition = model.cameraManager.cameraPosition == .back ? .front : .back
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if let error = model.error {
                        Text(error.localizedDescription)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        HStack {
                            Group {
                                FrameSourceView(frameSource: $model.frameSource, imageName: $imageName, showSliderControl: $showSliderControl)
                                Button(action: switchCameraPosition) {
                                    Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                                        .scaleEffect(1.5)
                                }
                                .padding([.horizontal])

                                Spacer()
                            }
                            
                        }
                        .padding([.horizontal, .bottom])
                        if showScaleSlider {
                            SliderControlView(showScaleSlider: $showSliderControl)
                        }
                    }
                }
                if showSliderControl && showScaleSlider {
                    ScaleSliderView(sizeWeight: $sizeWeight)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black)
            .opacity(0.8)
            .foregroundColor(.yellow)
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
            .onChange(of: sizeWeight) { weight in
                model.thumbViewSize = defaultThumbFrameSize * weight
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
