//
//  ColorDetailView.swift
//  InstColor
//
//  Created by Lei Cao on 11/5/22.
//

import SwiftUI

struct ColorDetailModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    var color: UIColor
    var containerCotentWidth: Double = 0
    
    func toggleSheet() {
        dismiss()
    }
    
    func saveColor() {
        var savedColors = UserDefaults.standard.readColor(forKey: "FavoriteColors") ?? []
        savedColors.append(FavoriteColor(id: UUID().uuidString, red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255), createdDate: Date()))
        UserDefaults.standard.setColor(savedColors, forKey: "FavoriteColors")
    }
    
    var body: some View {
        ColorDetailView(color: color, containerCotentWidth: containerCotentWidth)
            .overlay(alignment: .topLeading) {
                Button(action: saveColor) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding([.top, .leading])
            }
            .overlay(alignment: .topTrailing) {
                Button(action: toggleSheet){
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.white)
                }
                .padding([.top, .trailing])
            }
    }
}

struct ColorDetailView: View {
    @StateObject var model = ColorDetailViewModel()
    @State var hexText: String = "Unknown Hex"
    
    var color: UIColor
    var containerCotentWidth: Double = 0
    
    init(color: UIColor, containerCotentWidth: Double) {
        self.color = color
        self.hexText = color.toHexString() ?? "Unknown Hex"
        self.containerCotentWidth = containerCotentWidth
    }
    
    var body: some View {
        VStack {
            ColorIconView(color: model.color, colorName: model.colorName)
            
            SliderGroupContainerView(model: model, containerCotentWidth: containerCotentWidth)
            
            ColorHexTextView(displayColor: $model.color)

            ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear() {
            self.model.color = color
        }
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(color: .orange, containerCotentWidth: 393)
    }
}
