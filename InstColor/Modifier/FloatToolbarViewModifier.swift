//
//  FloatButtonViewModifier.swift
//  InstColor
//
//  Created by Lei Cao on 12/24/22.
//

import SwiftUI

struct ContainerSizeAwareModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .overlay() {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            size = CGSize(width: geo.size.width, height: geo.size.height)
                        }
                }
            }
    }
}

struct FloatToolbarViewModifier: ViewModifier {
    @ObservedObject var model: ContentViewModel
    @State var toolbarSize: CGSize = CGSize(width: 0, height: 0)
    @State var imageName = "viewfinder"

    let fillRect = RoundedRectangle(cornerRadius: 20)
    
    func switchCameraPosition() {
        model.cameraManager.cameraPosition = model.cameraManager.cameraPosition == .back ? .front : .back
        withAnimation {
            model.animationAmount += 180
        }
    }
    
    func turnOnTorch() {
        model.cameraManager.torchMode.toggle()
    }
    
    func changeFrameSource() {
        model.frameSource = model.frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                fillRect
                    .strokeBorder(.clear)
                    .frame(width: toolbarSize.width, height: toolbarSize.height)
                    .overlay() {
                        HStack {
                            Group {
                                Button(action: switchCameraPosition) {
                                    ImageButtonView(imageName: "arrow.triangle.2.circlepath")
                                }
                                FrameSourceView(frameSource: $model.frameSource, imageName: $imageName)
                                PressableButtonView(imageName: "flashlight.on.fill", action: turnOnTorch)
                            }
                            .padding([.horizontal], 5)
                            .scaleEffect(1.2)
                        }
                        .padding([.vertical], 5)
                        .modifier(ContainerSizeAwareModifier(size: $toolbarSize))
                    }
                    .background(.black)
                    .clipShape(fillRect)
                    .opacity(0.8)
                    .offset(CGSize(width: 0, height: -toolbarSize.height - 10))
            }
    }
}
