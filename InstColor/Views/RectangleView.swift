//
//  RectangleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/16/22.
//

import SwiftUI

struct RectangleView: View {
    var rect: CGRect?
    
    @State private var rectScale = 2
    
    var body: some View {
        if let rect = rect {
            Rectangle()
                .fill(.clear)
                .border(.yellow)
                .contentShape(Rectangle())
                .frame(width: rect.width, height: rect.height)
                .offset(CGSize(width: rect.origin.x, height: rect.origin.y))
                .animation(.easeInOut(duration: 0.5), value: rect.origin)
        }
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
}
