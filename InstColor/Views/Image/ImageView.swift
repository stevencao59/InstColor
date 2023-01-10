//
//  ImageView.swift
//  InstColor
//
//  Created by Lei Cao on 1/7/23.
//

import SwiftUI
import AVFoundation

struct ImageViewRepresentable: UIViewRepresentable {

    private let view = UIView()
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    var layer: CALayer? {
        view.layer
    }

    func makeUIView(context: Context) -> UIView {
        view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct ImageView: View {
    var body: some View {
        ImageViewRepresentable()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
