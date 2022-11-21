//
//  ToolBarView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct ToolBarView: View {
    @Binding var frameSouce: FrameSource
    @Binding var imageName: String
    @Binding var showScaleSlider: Bool
    @Binding var showSliderControl: Bool

    var switchCameraAction: () -> Void
    
    init(frameSource: Binding<FrameSource>, imageName: Binding<String>, showScaleSlider: Binding<Bool>, showSliderControl: Binding<Bool>, switchCameraAction: @escaping () -> Void ) {
        self._frameSouce = frameSource
        self._imageName = imageName
        self._showScaleSlider = showScaleSlider
        self._showSliderControl = showSliderControl

        self.switchCameraAction = switchCameraAction
    }
    
    var body: some View {
        HStack {
            Group {
                FrameSourceView(frameSource: $frameSouce, imageName: $imageName)
                Button(action: switchCameraAction) {
                    ImageButtonView(imageName: "arrow.left.and.right.righttriangle.left.righttriangle.right")
                }
                NavigationLink {
                    FavoritesView()
                } label: {
                    ImageButtonView(imageName: "folder.circle")
                }
                if showSliderControl {
                    SliderControlView(showScaleSlider: $showScaleSlider)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(frameSource: .constant(.cameraImage), imageName: .constant("ImageName"), showScaleSlider: .constant(true), showSliderControl: .constant(true), switchCameraAction: { })
    }
}
