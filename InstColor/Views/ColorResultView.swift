//
//  ColorResultView.swift
//  InstColor
//
//  Created by Lei Cao on 10/6/22.
//

import SwiftUI

struct ColorResultView: View {
    let color: UIColor
    var uiColor: Color {
        Color(uiColor: color)
    }
    
    var body: some View {
        HStack {
            Text("Average Color:")
                .font(.title2)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(uiColor)
                .frame(width: 20, height: 20)
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ColorResultView(color: UIColor(.red))
    }
}
