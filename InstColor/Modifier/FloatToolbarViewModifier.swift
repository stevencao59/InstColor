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
    @EnvironmentObject var states: States
    @ObservedObject var model: ContentViewModel
    
    @State var showDescription = false
    @State var toolbarSize: CGSize = CGSize(width: 0, height: 0)
    @State var screenStayOn = false
    
    let fillRect = RoundedRectangle(cornerRadius: 20)
    
    func switchCameraPosition() {
        model.cameraManager.cameraPosition = model.cameraManager.cameraPosition == .back ? .front : .back
        withAnimation {
            model.animationAmount += 180
        }
        states.description = "Camera: \(model.cameraManager.cameraPosition == .back ? "Back" : "Front")"
        showDescription.toggle()
    }
    
    func turnOnTorch() {
        model.cameraManager.torchMode.toggle()
        states.description = "Torch mode: \(model.cameraManager.torchMode ? "On" : "Off")"
        showDescription.toggle()
    }
    
    func turnOnScreenStay() {
        UIApplication.shared.isIdleTimerDisabled.toggle()
        states.description = "Screen On: \(UIApplication.shared.isIdleTimerDisabled ? "Always" : "Off")"
        showDescription.toggle()
    }
    
    func switchAlgo() {
        model.colorAlgorithm = model.colorAlgorithm == .defaultAlgo ? .linearAlgo : .defaultAlgo
        states.description = "Color Algorithm: \(model.colorAlgorithm.rawValue)"
        showDescription.toggle()
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
                                FrameSourceView(frameSource: $model.frameSource)
                                PressableButtonView(imageName: "flashlight.on.fill", action: turnOnTorch)
                                PressableButtonView(imageName: "light.max", action: turnOnScreenStay)
                                ImageSwitchButtonView(initialImageName: "d.square", switchImageName: "l.square", action: switchAlgo)
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
                    .overlay {
                        VStack {
                            if showDescription {
                                Text(states.description)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.black)
                                            .opacity(0.8)
                                            .shadow(radius: 3)
                                    )
                                    .offset(CGSize(width: 0, height: -toolbarSize.height - 50))
                            }
                        }
                        .onChange(of: model.frameSource) { source in
                            states.description = "\(source == .thumbImage ? "Area Detection" : "Full Image Detection")"
                            showDescription.toggle()
                        }
                        .onChange(of: showDescription) { value in
                            if value == true {
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                    withAnimation(.easeInOut) {
                                        showDescription.toggle()
                                    }
                                }
                            }
                        }
                        .animation(.easeIn, value: showDescription)
                    }
            }
    }
}
