//
//  FrameSourceView.swift
//  InstColor
//
//  Created by Lei Cao on 10/18/22.
//

import SwiftUI

struct FrameSourceView: View {
    @Binding var frameSource: FrameSource
    
    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack() {
            if frameSource == .thumbImage {
                Button(action: changeFrameSource) {
                    Image(systemName: "viewfinder")
                        .foregroundColor(.yellow)
                }
            }
        }
        .background(.black)
        .opacity(0.8)
    }
}

struct FrameSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSourceView(frameSource: .constant(.wholeImage))
    }
}
