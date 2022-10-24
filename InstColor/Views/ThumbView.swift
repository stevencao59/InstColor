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
    
    var body: some View {
        VStack {
            if frameSource == .thumbImage {
                if let image = frame {
                    Image(image, scale: 1, label: Text("Thumbview Feed"))
                        .scaledToFit()
                        .border(.yellow)
                }
            }
        }
        .padding()
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(frame: UIImage(systemName: "heart.fill")?.cgImage, frameSource: .thumbImage)
    }
}
