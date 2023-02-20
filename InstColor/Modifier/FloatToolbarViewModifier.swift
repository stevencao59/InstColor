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
                        .onChange(of: geo.size.width) {width in
                            size = CGSize(width: width, height: geo.size.height)
                        }
                        .onAppear {
                            size = CGSize(width: geo.size.width, height: geo.size.height)
                        }
                }
            }
    }
}

struct DescriptionView: View {
    @EnvironmentObject var states: States
    @ObservedObject var model: ContentViewModel
    @Binding var showDescription: Bool
    
    let toolbarSize: CGSize

    var body: some View {
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
            states.description = "\(source == .thumbImage ? "Single Color Detection" : "Dominant Colors Detection")"
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

struct ToolbarInfoView: View {
    let infoData: String
    let frameSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 20
    let fontSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 10
    
    var body: some View {
        Rectangle()
            .strokeBorder(.clear)
            .frame(width: frameSize)
            .background(.clear)
            .overlay {
                VStack {
                    Group {
                        Text(infoData)
                            .bold()
                    }
                    .font(.system(size: fontSize))
                    .background(.clear)
                    .foregroundColor(.white)
                }
            }
    }
}

struct ThumbViewToolbarView : View {
    @EnvironmentObject var states: States
    @StateObject var model: ContentViewModel
    @Binding var showThumbConfigs: Bool
    @Binding var showDescription: Bool
    
    var increaseScaleAmount: () -> Void
    var decreaseScaleAmount: () -> Void
    var increaseFrameDelta: () -> Void
    var decreaseFrameDelta: () -> Void
    
    var body: some View {
        Button(action: { showThumbConfigs.toggle() }) {
            ImageButtonView(imageName: "arrowshape.backward")
        }
        Divider()
            .overlay(.gray)
        Button(action: increaseFrameDelta) {
            ImageButtonView(imageName: "plus.square")
        }
        ToolbarInfoView(infoData: "+" + String(format: "%.0f", model.thumbViewSizeDelta))
        Button(action: decreaseFrameDelta) {
            ImageButtonView(imageName: "minus.square")
        }
        Divider()
            .overlay(.gray)
        Button(action: increaseScaleAmount) {
            ImageButtonView(imageName: "plus.magnifyingglass")
        }
        ToolbarInfoView(infoData: "x" + String(format: "%.0f", model.scaleAmount))
        Button(action: decreaseScaleAmount) {
            ImageButtonView(imageName: "minus.magnifyingglass")
        }
    }
}

struct GenericToolbarView: View {
    @ObservedObject var model: ContentViewModel
    var switchCameraPosition: () -> Void
    var showThumbConfig: () -> Void
    var turnOnTorch: () -> Void
    var turnOnScreenStay: () -> Void
    var switchAlgo: () -> Void
    
    var body: some View {
        Button(action: switchCameraPosition) {
            ImageButtonView(imageName: "arrow.triangle.2.circlepath")
        }
        FrameSourceView(frameSource: $model.frameSource)
        if model.frameSource == .thumbImage {
            Button(action: showThumbConfig) {
                ImageButtonView(imageName: "square.and.pencil.circle.fill")
            }
        }
        PressableButtonView(imageName: "flashlight.on.fill", action: turnOnTorch)
        PressableButtonView(imageName: "light.max", action: turnOnScreenStay)
        ImageSwitchButtonView(initialImageName: "d.square", switchImageName: "l.square", action: switchAlgo)
    }
}

struct FloatToolbarViewModifier: ViewModifier {
    @EnvironmentObject var states: States
    @ObservedObject var model: ContentViewModel
    
    @State var showDescription = false
    @State var toolbarSize: CGSize = CGSize(width: 0, height: 0)
    @State var screenStayOn = false
    
    @State var showThumbConfigs = false
    
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
    
    func showThumbConfig() {
        showThumbConfigs.toggle()
    }
    
    func increaseScaleAmount() {
        model.scaleAmount = model.scaleAmount == 5 ? 5 : model.scaleAmount + 1
    }
    
    func decreaseScaleAmount() {
        model.scaleAmount = model.scaleAmount == 1 ? 1 : model.scaleAmount - 1
    }
    
    func increaseFrameDelta() {
        model.thumbViewSizeDelta = model.thumbViewSizeDelta == 10 ? 10 : model.thumbViewSizeDelta + 1
    }
    
    func decreaseFrameDelta() {
        model.thumbViewSizeDelta = model.thumbViewSizeDelta == -10 ? -10 : model.thumbViewSizeDelta - 1
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
                                if showThumbConfigs {
                                    ThumbViewToolbarView(model: model, showThumbConfigs: $showThumbConfigs,showDescription: $showDescription, increaseScaleAmount: increaseScaleAmount, decreaseScaleAmount: decreaseScaleAmount, increaseFrameDelta: increaseFrameDelta, decreaseFrameDelta: decreaseFrameDelta)
                                }
                                else {
                                    GenericToolbarView(model: model, switchCameraPosition: switchCameraPosition, showThumbConfig: showThumbConfig, turnOnTorch: turnOnTorch, turnOnScreenStay: turnOnScreenStay, switchAlgo: switchAlgo)
                                }
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
                        DescriptionView(model: model, showDescription: $showDescription, toolbarSize: toolbarSize)
                    }
                    .animation(.default, value: showThumbConfigs)
            }
    }
}
