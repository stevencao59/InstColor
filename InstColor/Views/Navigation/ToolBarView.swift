//
//  ToolBarView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct ToolBarView: View {
    @ObservedObject var model: ContentViewModel
    @Binding var imageName: String
    @Binding var showScaleSlider: Bool
    @Binding var showSliderControl: Bool

    @State var showFavorites: Bool = false
    @State var showReferences: Bool = false
    
    var containerCotentWidth: CGFloat
    var switchCameraAction: () -> Void
    var turnOnTorch: () -> Void
    
    init(model: ContentViewModel, imageName: Binding<String>, showScaleSlider: Binding<Bool>, showSliderControl: Binding<Bool>, containerContentWidth: CGFloat, switchCameraAction: @escaping () -> Void, turnOnTorch: @escaping () -> Void) {
        self.model = model

        self._imageName = imageName
        self._showScaleSlider = showScaleSlider
        self._showSliderControl = showSliderControl

        self.containerCotentWidth = containerContentWidth
        self.switchCameraAction = switchCameraAction
        self.turnOnTorch = turnOnTorch
    }
    
    func toggleFavorites() {
        showFavorites.toggle()
    }
    
    func toggleReferences() {
        showReferences.toggle()
    }
    
    var body: some View {
        HStack {
            Group {
                FrameSourceView(frameSource: $model.frameSource, imageName: $imageName)
                Button(action: switchCameraAction) {
                    ImageButtonView(imageName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                }
                Button(action: toggleFavorites) {
                    ImageButtonView(imageName: "heart")
                }
                Button(action: toggleReferences) {
                    ImageButtonView(imageName: "list.bullet")
                }
                PressableButtonView(action: turnOnTorch) {
                    ImageButtonView(imageName: "flashlight.on.fill")
                }
                if showSliderControl {
                    SliderControlView(showScaleSlider: $showScaleSlider)
                }
            }
            .padding([.horizontal, .bottom])
            .fullScreenCover(isPresented: $showFavorites) {
                return FavoritesView(containerCotentWidth: containerCotentWidth)
            }
            .onChange(of: showFavorites) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
            .fullScreenCover(isPresented: $showReferences) {
                return ReferencesView(containerCotentWidth: containerCotentWidth)
            }
            .onChange(of: showReferences) { toShow in
                model.cameraManager.cameraRunnning = !toShow
            }
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(model: ContentViewModel(), imageName: .constant("ImageName"), showScaleSlider: .constant(true), showSliderControl: .constant(true), containerContentWidth: 300, switchCameraAction: { }, turnOnTorch: { })
    }
}
