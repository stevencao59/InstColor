//
//  ColorTypeView.swift
//  InstColor
//
//  Created by Lei Cao on 11/13/22.
//

import SwiftUI

struct ColorTypeGridItemView: View {
    let gridItemColor: UIColor
    @State var colorName: String?
    
    @Binding var referenceColor: UIColor
    
    func getColorName(color: UIColor) {
        DispatchQueue.main.async {
            colorName = color.calculateClosestColor().Color
        }
    }
    
    func setColor() {
        referenceColor = gridItemColor
    }
    
    var body: some View {
        Button(action: setColor) {
            VStack {
                BorderedRectView(color: Color(gridItemColor), cornerRadius: 15, lineWidth: 2, height: 50)

                Text(colorName ?? "Loading...")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .padding([.vertical])
        .onChange(of: gridItemColor) { color in
            getColorName(color: color)
        }
        .onAppear() {
            getColorName(color: gridItemColor)
        }
        .animation(.default, value: colorName)
    }
}

struct ColorTypeGridView: View {
    var colors: [UIColor]?
    var title: String

    @Binding var referenceColor: UIColor
        
    var body: some View {
        VStack {
            Grid {
                if let colors {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .bold(true)
                            .foregroundColor(.white)
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.white)
                    }
                    
                    ForEach(colors.chunked(into: 4), id: \.self) { colorRow in
                        GridRow {
                            ForEach(colorRow, id: \.self) { row in
                                ColorTypeGridItemView(gridItemColor: row, referenceColor: $referenceColor)
                            }
                        }
                    }
                }
            }

            Divider()
                .padding([.horizontal])
        }
        .padding()
    }
}

struct ColorTypeView: View {
    var complementaryColor: [UIColor]?
    var triadicColor: [UIColor]?
    var splitComplementaryColor: [UIColor]?
    var analogousColor: [UIColor]?
    var tetradicColor: [UIColor]?
    var monochromaticColor: [UIColor]?
    
    @Binding var referenceColor: UIColor
    
    init(complementaryColor: [UIColor]?, triadicColor: [UIColor]?, splitComplementaryColor: [UIColor]?, analogousColor: [UIColor]?, tetradicColor: [UIColor]?, monochromaticColor: [UIColor]?, referenceColor: Binding<UIColor>) {
        self.complementaryColor = complementaryColor
        self.triadicColor = triadicColor
        self.splitComplementaryColor = splitComplementaryColor
        self.analogousColor = analogousColor
        self.tetradicColor = tetradicColor
        self.monochromaticColor = monochromaticColor
        self._referenceColor = referenceColor
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ColorTypeGridView(colors: complementaryColor, title: "Complementary Color", referenceColor: $referenceColor)
                ColorTypeGridView(colors: triadicColor, title: "Triadic Colors", referenceColor: $referenceColor)
                ColorTypeGridView(colors: splitComplementaryColor, title: "Split Complementary Colors", referenceColor: $referenceColor)
                ColorTypeGridView(colors: analogousColor, title: "Analogous Colors", referenceColor: $referenceColor)
                ColorTypeGridView(colors: tetradicColor, title: "Tetradic Colors", referenceColor: $referenceColor)
                ColorTypeGridView(colors: monochromaticColor, title: "Monochromatic Colors", referenceColor: $referenceColor)
            }
        }
    }
}



struct ColorTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            
            ColorTypeView(
                complementaryColor: [UIColor.orange],
                triadicColor: [UIColor(.red), UIColor(.green), UIColor(.blue)],
                splitComplementaryColor: [UIColor(.red), UIColor(.green), UIColor(.blue)],
                analogousColor: [UIColor(.red), UIColor(.green), UIColor(.blue)],
                tetradicColor: [UIColor(.red), UIColor(.green), UIColor(.blue), UIColor(.gray)],
                monochromaticColor: [UIColor(.red), UIColor(.green), UIColor(.blue)],
                referenceColor: .constant(UIColor(.red))
            )
        }
    }
}
