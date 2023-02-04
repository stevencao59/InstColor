//
//  FrameSourceView.swift
//  InstColor
//
//  Created by Lei Cao on 10/18/22.
//

import SwiftUI

struct ImageSwitchButtonView: View {
    @State var imageName: String
    
    var initialImageName: String
    var switchImageName: String

    var action: () -> Void
    
    func buttonAction() {
        imageName = imageName == initialImageName ? switchImageName : initialImageName
        action()
    }
    
    init(initialImageName: String, switchImageName: String, action: @escaping () -> Void) {
        self.imageName = initialImageName
        self.initialImageName = initialImageName
        self.switchImageName = switchImageName
        self.action = action
    }
    
    var body: some View {
        Button(action: buttonAction) {
            ImageButtonView(imageName: imageName)
        }
        .animation(.easeIn, value: imageName)    }
}

struct FrameSourceView: View {
    @Binding var frameSource: FrameSource
    @State var imageName: String = "viewfinder"

    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        Button(action: changeFrameSource) {
            ImageButtonView(imageName: imageName)
        }
        .animation(.easeIn, value: imageName)
        .onChange(of: frameSource) { newSurce in
            imageName = newSurce == .thumbImage ? "viewfinder.circle" : "viewfinder"
        }
    }
}

struct FrameSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSourceView(frameSource: .constant(.wholeImage))
    }
}
