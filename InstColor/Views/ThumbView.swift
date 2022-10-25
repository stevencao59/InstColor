//
//  ThumbnailView.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import SwiftUI

struct ThumbView: View {
    var frame: CGImage?
    var frameSource: FrameSource
    @State private var viewXOffset = 100.0
    
    var body: some View {
        VStack {
            HStack {
                if let frame = frame {
                    Image(frame, scale: 1, label: Text("Thumbview Feed"))
                            .scaledToFit()
                            .border(.yellow)
                }
            }
            .offset(x: viewXOffset, y: 0)
            .animation(.spring(dampingFraction: 1.0), value: viewXOffset)
        }
        .padding()
        .onChange(of: frame) { value in
            viewXOffset = frameSource == .thumbImage ? 0 : 100.0
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(frame: UIImage(systemName: "heart.fill")?.cgImage, frameSource: .thumbImage)
    }
}
