//
//  ColorIconView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import Foundation
import SwiftUI

struct ColorIconView: View {
    var color: UIColor?
    var colorName: String?
    
    var body: some View {
        VStack {
            if let color {
                if let colorName {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white, lineWidth: 5)
                            .frame(width: 100, height: 100)
     
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(color))
                            .frame(width: 100, height: 100)
                    }

                    Text(colorName)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
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
