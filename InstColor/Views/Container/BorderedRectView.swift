//
//  BorderedRectView.swift
//  InstColor
//
//  Created by Lei Cao on 11/20/22.
//

import SwiftUI

struct StrokeRectView : View {
    var cornerRadius = 0.0
    var lineWidth = 0.0

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(.white, lineWidth: lineWidth)
    }
}

struct RectView : View {
    var cornerRadius = 0.0
    var color: Color = Color(.black)

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
    }
}

struct BorderedRectView: View {
    var color: Color = Color(.white)
    var cornerRadius = 0.0
    var lineWidth = 0.0
    var width: Double?
    var height: Double?
    
    var body: some View {
        ZStack {
            if let width {
                if let height {
                    StrokeRectView(cornerRadius: cornerRadius, lineWidth: lineWidth)
                        .frame(width: width, height: height)
                    RectView(cornerRadius: cornerRadius, color: color)
                        .frame(width: width, height: height)
                }
                else {
                    StrokeRectView(cornerRadius: cornerRadius, lineWidth: lineWidth)
                        .frame(width: width)
                    RectView(cornerRadius: cornerRadius, color: color)
                        .frame(width: width)
                }
            } else {
                if let height {
                    StrokeRectView(cornerRadius: cornerRadius, lineWidth: lineWidth)
                        .frame(height: height)
                    RectView(cornerRadius: cornerRadius, color: color)
                        .frame(height: height)
                }
            }
        }
    }
}

struct BorderedRectView_Previews: PreviewProvider {
    static var previews: some View {
        BorderedRectView()
    }
}
