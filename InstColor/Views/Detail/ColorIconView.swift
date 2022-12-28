//
//  ColorIconView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import Foundation
import SwiftUI

struct ColorIconView: View {
    let color: UIColor
    let colorName: String?
    let baseColorName: String?
    
    var body: some View {
        VStack {
            BorderedRectView(color: Color(color), cornerRadius: 15, lineWidth: 5, width: 100, height: 100)
            
            Text(colorName ?? "Loading...")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
            
            Group {
                if baseColorName != nil {
                    Text("\(baseColorName!) Family")
                } else {
                    Text("Loading...")
                }
            }
            .font(.footnote)
            .foregroundColor(.gray)

        }
        .padding()
    }
}

struct ColorIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorIconView(color: UIColor(.blue), colorName: "Blue", baseColorName: "Blue")
        }
        .ignoresSafeArea()
    }
}
