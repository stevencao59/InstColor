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
        FrameSourceView(frameSource: .constant(.wholeImage), imageName: .constant("viewfinder"))
    }
}
