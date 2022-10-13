//
//  ColorResultView.swift
//  InstColor
//
//  Created by Lei Cao on 10/6/22.
//

import SwiftUI

struct ColorResultView: View {
    @StateObject private var model = ColorResultViewModel()
    let color: UIColor
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color(uiColor: color))
                .frame(width: 40, height: 40)
                .onChange(of: color) { newValue in
                    model.color = newValue
                }

            Text(model.colorName ?? "Unknown Color")
                .font(.title2)
                .foregroundColor(.white)
                .animation(.easeIn)
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ColorResultView(color: UIColor(.red))
    }
}
