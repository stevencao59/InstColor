//
//  ColorTypeView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI

struct ColorTypeGridView: View {
    var colorRow: [UIColor]
    
    var body: some View {
        GridRow {
            ForEach(colorRow, id: \.self) { row in
                Rectangle()
                    .fill(Color(row))
                    .cornerRadius(10)
            }
        }
    }
}

struct ColorTypeView: View {
    var complementaryColor: [UIColor]?
    var triadicColor: [UIColor]?
    var splitComplementaryColor: [UIColor]?
    var analogousColor: [UIColor]?
    var tetradicColor: [UIColor]?
    var monochromaticColor: [UIColor]?
    
    var body: some View {
        Grid {
            if let monochromaticColor {
                ForEach(monochromaticColor.chunked(into: 4), id: \.self) { item in
                    ColorTypeGridView(colorRow: item)
                }
            }
        }
    }
}



struct ColorTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTypeView(monochromaticColor: [UIColor(.red), UIColor(.green), UIColor(.blue)])
    }
}
