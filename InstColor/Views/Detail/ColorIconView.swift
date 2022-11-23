//
//  ColorIconView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import Foundation
import SwiftUI

struct ColorIconView: View {
    var color: UIColor
    var colorName: String?
    
    var body: some View {
        VStack {
            BorderedRectView(color: Color(color), cornerRadius: 15, lineWidth: 5, width: 100, height: 100)
            
            Text(colorName ?? "Loading...")
                .font(.headline)
                .foregroundColor(.white)
            
        }
        .padding()
    }
}

struct ColorIconView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorIconView(color: UIColor(.blue), colorName: "Blue")
        }
        .ignoresSafeArea()
    }
}
