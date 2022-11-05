//
//  FrameSourceView.swift
//  InstColor
//
//  Created by Lei Cao on 10/18/22.
//

import SwiftUI

struct FrameSourceView: View {
    @Binding var frameSource: FrameSource
    @Binding var imageName: String

    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack {
            Button(action: changeFrameSource) {
                ImageButtonView(imageName: imageName)
            }
        }
        .foregroundColor(.yellow)
        .opacity(0.8)
        .animation(.easeIn, value: imageName)
        .onChange(of: frameSource) { newSurce in
            imageName = newSurce == .thumbImage ? "viewfinder.circle" : "viewfinder"
        }
    }
}

struct FrameSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSourceView(frameSource: .constant(.wholeImage), imageName: .constant("viewfinder"))
    }
}
