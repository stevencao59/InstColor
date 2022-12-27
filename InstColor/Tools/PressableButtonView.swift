//
//  PressableView.swift
//  InstColor
//
//  Created by Lei Cao on 12/9/22.
//

import SwiftUI

struct PressableButtonView: View {
    var imageName: String
    var action: () -> Void

    @State var frameSize: CGFloat
    @State var imageSize: CGFloat
    
    @State var pressed: Bool = false
    
    func pressedAction() {
        action()
        pressed.toggle()
    }
    
    init(imageName: String, action: @escaping () -> Void, frameSize: CGFloat = 20, imageSize: CGFloat = 10) {
        self.imageName = imageName
        self.action = action
        self.frameSize = frameSize
        self.imageSize = imageSize
    }
    
    var body: some View {
        Button(action: pressedAction) {
            ImageButtonView(imageName: imageName, color: pressed ? .yellow : .white, frameSize: frameSize, imageSize: imageSize)
        }
        .animation(.easeIn, value: pressed)
    }
}

struct PressableView_Previews: PreviewProvider {
    static var previews: some View {
        PressableButtonView(imageName: "preview", action: { })
    }
}
