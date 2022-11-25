//
//  ColorDetailView.swift
//  InstColor
//
//  Created by Lei Cao on 11/5/22.
//

import SwiftUI

struct SaveColorModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    var color: UIColor
    var showModalButtons = false

    @State private var showAlertWindow = false
    
    func toggleSheet() {
        dismiss()
    }
    
    func saveColor() {
        var savedColors = UserDefaults.standard.readColor(forKey: favoritColorKey) ?? []
        savedColors.append(FavoriteColor(id: UUID().uuidString, red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255), createdDate: Date()))
        UserDefaults.standard.setColor(savedColors, forKey: favoritColorKey)
        showAlertWindow = true
    }
    
    func body(content: Content) -> some View {
        if showModalButtons {
            content
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
                .alert("Favorite color is saved!", isPresented: $showAlertWindow) {
                    Button("Ok", role: .cancel) { }
                }
        }
        else {
            content
        }
    }
}

struct ColorDetailView: View {
    @StateObject var model = ColorDetailViewModel()
    @State var hexText: String = "Unknown Hex"
    
    var color: UIColor
    var containerCotentWidth: Double = 0
    var showModalButtons: Bool
    
    init(color: UIColor, containerCotentWidth: Double, showModalButtons: Bool) {
        self.color = color
        self.hexText = color.toHexString() ?? "Unknown Hex"
        self.containerCotentWidth = containerCotentWidth
        self.showModalButtons = showModalButtons
    }
    
    var body: some View {
        VStack {
            ColorIconView(color: model.color, colorName: model.colorName)
            
            SliderGroupContainerView(model: model, containerCotentWidth: containerCotentWidth)
            
            ColorHexTextView(displayColor: $model.color)

            ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
        }
        .padding([.top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .modifier(SaveColorModifier(color: model.color, showModalButtons: showModalButtons))
        .onAppear() {
            self.model.color = color
        }
        
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(color: .orange, containerCotentWidth: 393, showModalButtons: true)
    }
}
