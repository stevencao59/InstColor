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
    
    var containerCotentWidth: CGFloat
    var switchCameraAction: () -> Void
    
    init(model: ContentViewModel, imageName: Binding<String>, showScaleSlider: Binding<Bool>, showSliderControl: Binding<Bool>, containerContentWidth: CGFloat, switchCameraAction: @escaping () -> Void ) {
        self.model = model

        self._imageName = imageName
        self._showScaleSlider = showScaleSlider
        self._showSliderControl = showSliderControl

        self.containerCotentWidth = containerContentWidth
        self.switchCameraAction = switchCameraAction
    }
    
    func toggleFavorites() {
        showFavorites.toggle()
    }
    
    var body: some View {
        HStack {
            Group {
                FrameSourceView(frameSource: $model.frameSource, imageName: $imageName)
                Button(action: switchCameraAction) {
                    ImageButtonView(imageName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                }
                Button(action: toggleFavorites) {
                    ImageButtonView(imageName: "folder")
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
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(model: ContentViewModel(), imageName: .constant("ImageName"), showScaleSlider: .constant(true), showSliderControl: .constant(true), containerContentWidth: 300, switchCameraAction: { })
    }
}
