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

struct InformationTypeView: View {
    @ObservedObject var model: ColorDetailViewModel
    @State var selectedInformationType = "Types"
    @State var showTypesView = true
    
    var containerCotentWidth: Double
    var informationTypes = ["Types", "Shades"]
    var selectedDetent: PresentationDetent
    
    var body: some View {
        VStack {
            Divider()
                .padding([.horizontal])
            
            Picker("Information", selection: $selectedInformationType) {
                ForEach(informationTypes, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: containerCotentWidth / 2)
            
            if showTypesView {
                ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
            } else {
                ColorShadeView(referenceColor: $model.color)
            }
        }
        .padding([.horizontal])
        .animation(.easeIn, value: showTypesView)
        .onChange(of: selectedInformationType) { val in
            showTypesView = selectedInformationType == "Types"
        }
    }
}

struct ColorIconContainerView: View {
    let color: UIColor
    let colorName: String?
    let baseColorName: String?

    var keyboardFocusState: FocusState<FocusElement?>.Binding

    var body: some View {
        ZStack {
            ColorIconView(color: color, colorName: colorName, baseColorName: baseColorName)
        }
        .frame(maxWidth: .infinity)
        .defocusOnTap(keyboardFocusState)
    }
}

struct ColorDetailView: View {
    @StateObject var model = ColorDetailViewModel()
    @State var hexText: String = "Unknown Hex"
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)

    @FocusState var keyboardFocusState: FocusElement?
    
    var color: UIColor
    var showModalButtons: Bool
    var selectedDetent: PresentationDetent
    
    init(color: UIColor, showModalButtons: Bool, selectedDetent: PresentationDetent) {
        self.color = color
        self.showModalButtons = showModalButtons
        self.selectedDetent = selectedDetent
        self.hexText = color.toHexString() ?? "Unknown Hex"
    }
    
    var body: some View {
        VStack {
            ColorIconContainerView(color: model.color, colorName: model.colorName, baseColorName: model.baseColorName, keyboardFocusState: $keyboardFocusState)
            ScrollView {
                SliderGroupContainerView(model: model, keyboardFocusState: $keyboardFocusState, containerCotentWidth: viewSize.width)
                
                ColorHexTextView(displayColor: $model.color)
                
                InformationTypeView(model: model, containerCotentWidth: viewSize.width, selectedDetent: selectedDetent)
            }
        }
        .padding([.top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .modifier(SaveColorModifier(color: model.color, showModalButtons: showModalButtons))
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        viewSize = CGSize(width: geo.size.width, height: geo.size.height)
                    }
            }
        }
        .onAppear() {
            self.model.color = color
        }
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(color: .orange, showModalButtons: true, selectedDetent: .large)
    }
}
