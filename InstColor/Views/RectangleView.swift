//
//  RectangleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/16/22.
//

import SwiftUI

struct RectangleView: View {
    var rect: CGRect?
    var offset: CGSize? {
        if let rect = rect {
            return CGSize(width: rect.origin.x, height: rect.origin.y)
        }
        return nil
    }
    

    var body: some View {
        if let rect = rect {
            if let offset = offset {
                Rectangle()
                    .fill(.clear)
                    .border(.yellow)
                    .contentShape(Rectangle())
                    .frame(width: rect.width, height: rect.height)
                    .offset(offset)
                    .animation(.default, value: offset)
            }
        }
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
}
