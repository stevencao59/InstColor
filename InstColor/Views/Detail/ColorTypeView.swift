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
    
    let colorMap: [RGBColor]

    func getColorName(color: UIColor) {
        DispatchQueue.main.async {
            colorName = color.calculateClosestColor(colorMap: colorMap).Color
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
                    .lineLimit(1, reservesSpace: false)
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
    var showColorRow: Bool {
        return colors != nil
    }
    
    @Binding var referenceColor: UIColor
    @State var showTooltipsSheet = false
    
    let colorMap: [RGBColor]
    
    var body: some View {
        VStack {
            Grid {
                if showColorRow {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .bold(true)
                            .foregroundColor(.white)
                        Button(action: { showTooltipsSheet.toggle() }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.white)
                        }
                    }
                    
                    ForEach(colors!.chunked(into: 4), id: \.self) { colorRow in
                        GridRow {
                            ForEach(colorRow, id: \.self) { row in
                                ColorTypeGridItemView(gridItemColor: row, referenceColor: $referenceColor, colorMap: colorMap)
                            }
                        }
                    }
                }
            }
            .animation(.easeIn, value: showColorRow)

            Divider()
                .padding([.horizontal])
        }
        .padding()
        .sheet(isPresented: $showTooltipsSheet) {
            TooltipView(title: title, tooltipsText: tooltipsDict[title])
                .background(.black)
                .foregroundColor(.white)
                .presentationDetents([.medium])
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
    
    let colorMap: [RGBColor]
    
    @Binding var referenceColor: UIColor
    
    init(complementaryColor: [UIColor]?, triadicColor: [UIColor]?, splitComplementaryColor: [UIColor]?, analogousColor: [UIColor]?, tetradicColor: [UIColor]?, monochromaticColor: [UIColor]?, referenceColor: Binding<UIColor>, colorMap: [RGBColor]) {
        self.complementaryColor = complementaryColor
        self.triadicColor = triadicColor
        self.splitComplementaryColor = splitComplementaryColor
        self.analogousColor = analogousColor
        self.tetradicColor = tetradicColor
        self.monochromaticColor = monochromaticColor
        self._referenceColor = referenceColor
        self.colorMap = colorMap
    }
    
    var body: some View {
        VStack {
            ColorTypeGridView(colors: complementaryColor, title: "Complementary Color", referenceColor: $referenceColor, colorMap: colorMap)
            ColorTypeGridView(colors: triadicColor, title: "Triadic Colors", referenceColor: $referenceColor, colorMap: colorMap)
            ColorTypeGridView(colors: splitComplementaryColor, title: "Split Complementary Colors", referenceColor: $referenceColor, colorMap: colorMap)
            ColorTypeGridView(colors: analogousColor, title: "Analogous Colors", referenceColor: $referenceColor, colorMap: colorMap)
            ColorTypeGridView(colors: tetradicColor, title: "Tetradic Colors", referenceColor: $referenceColor, colorMap: colorMap)
            ColorTypeGridView(colors: monochromaticColor, title: "Monochromatic Colors", referenceColor: $referenceColor, colorMap: colorMap)
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
                referenceColor: .constant(UIColor(.red)),
                colorMap: []
            )
        }
    }
}
