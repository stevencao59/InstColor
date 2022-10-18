//
//  ThumbnailView.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import SwiftUI

struct ThumbView: View {
    var frame: CGImage?
    var location: CGPoint?
    
    var body: some View {
        VStack {
            if let image = frame {
                Image(image, scale: 1, label: Text("Thumbview Feed"))
                    .scaledToFit()
                    .border(.yellow)
            }
            if let location = location {
                Text("x: \(Int(location.x)) y: \(Int(location.y))")
            }
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(frame: UIImage(systemName: "heart.fill")?.cgImage, location: CGPoint(x: 100, y: 50))
    }
}
