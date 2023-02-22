//
//  ColorDetailView.swift
//  InstColor
//
//  Created by Lei Cao on 11/5/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct SaveColorModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    
    var color: UIColor
    var showModalButtons = false

    @State private var showAlertWindow = false
    
    func toggleSheet() {
        dismiss()
    }
    
    func saveColor() {
        saveFavoriteColor(color: color)
        showAlertWindow = true
    }
    
    func body(content: Content) -> some View {
        if showModalButtons {
            content
                .opacity(0.8)
                .clearModalBackground()
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

struct ColorSpaceView: View {
    @Binding var colorInfos: [ColorInfo]
    
    @State private var selectedInfo: String = ""
    @State private var showCopyMessage = false
    @State private var copiedMessage = ""
    @State private var showTooltipsSheet = false
    
    var body: some View {
        VStack {
            VStack {
                ForEach(colorInfos) { info in
                    VStack {
                        HStack {
                            HStack {
                                Text(info.InfoName)
                                    .bold()
                                Button(action: {
                                    selectedInfo = info.InfoName
                                    showTooltipsSheet.toggle()
                                }) {
                                    Image(systemName: "questionmark.circle")
                                }
                            }
                            Spacer()
                            Text(info.Value)
                        }
                        Divider()
                            .overlay(.gray)
                    }
                    .padding([.bottom, .horizontal])
                    .onLongPressGesture() {
                        copiedMessage = "\(info.InfoName) (\(info.Value))"
                        UIPasteboard.general.setValue(copiedMessage,
                                                      forPasteboardType: UTType.plainText.identifier)
                        showCopyMessage.toggle()
                    }
                }
            }
            Text("Press and hold to copy color space values")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .foregroundColor(.white)
        .alert("Color space info is copied!\n\(copiedMessage)", isPresented: $showCopyMessage) {
            Button("Ok", role: .cancel) { }
        }
        .sheet(isPresented: $showTooltipsSheet) {
            TooltipView(title: selectedInfo, tooltipsText: tooltipsDict[selectedInfo])
                .background(.black)
                .foregroundColor(.white)
                .presentationDetents([.medium])
        }
    }
}

struct InformationTypeView: View {
    @ObservedObject var model: ColorDetailViewModel
    @State private var informationTypeIndex = 0
    
    var containerCotentWidth: Double
    var informationTypes = ["Types", "Blends", "Color Spaces"]
    var selectedDetent: PresentationDetent
    
    var body: some View {
        VStack {
            Divider()
                .padding([.horizontal])
            
            SegmentedPickerView(preselectedIndex: $informationTypeIndex, options: informationTypes)
                .padding()
            
            if informationTypes[informationTypeIndex] == "Types" {
                ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
            } else if informationTypes[informationTypeIndex] == "Blends" {
                ColorShadeView(referenceColor: $model.color)
            } else if informationTypes[informationTypeIndex] == "Color Spaces" {
                ColorSpaceView(colorInfos: $model.colorInfos)
            }
        }
        .padding([.horizontal])
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

struct ColorGroupVew: View {
    var colors: [DetectedColor]
    @Binding var selectColor: UIColor
    
    let viewSize = screenRatio * 35
    
    var body: some View {
        if colors.count > 1 {
            VStack {
                Text("Dominant Colors")
                    .font(.body)
                HStack {
                    ForEach(colors, id: \.self) { c in
                        Button(action: { selectColor = c.color }) {
                            VStack {
                                BorderedRectView(color: Color(c.color), cornerRadius: 10, lineWidth: 2, width: viewSize, height: viewSize)
                                Text((String(format: "%.0f%%", c.frequency * 100)))
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding([.horizontal, .bottom])
        }
    }
}

struct ColorDetailView: View {
    @EnvironmentObject var states: States

    @StateObject var model = ColorDetailViewModel()
    @State var hexText: String = "Unknown Hex"
    @State var viewSize: CGSize = CGSize(width: 0, height: 0)

    @FocusState var keyboardFocusState: FocusElement?
    
    var colors: [DetectedColor]
    var selectedColor: UIColor
    var showModalButtons: Bool
    var selectedDetent: PresentationDetent
    var saveHistory: Bool = false
    
    init(colors: [DetectedColor], showModalButtons: Bool, selectedDetent: PresentationDetent, saveHistory: Bool = false) {
        self.colors = colors
        self.selectedColor = colors[0].color
        self.showModalButtons = showModalButtons
        self.selectedDetent = selectedDetent
        self.hexText = self.selectedColor.toHexString() ?? "Unknown Hex"
        self.saveHistory = saveHistory
    }
    
    var body: some View {
        VStack {
            ColorIconContainerView(color: model.color, colorName: model.colorName, baseColorName: model.baseColorName, keyboardFocusState: $keyboardFocusState)
            ScrollView {
                ColorGroupVew(colors: colors, selectColor: $model.color)
                SliderGroupContainerView(model: model, keyboardFocusState: $keyboardFocusState, containerCotentWidth: viewSize.width)
                
                ColorHexTextView(displayColor: $model.color, keyboardFocusState: $keyboardFocusState)
                
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
            self.model.color = selectedColor
            if saveHistory {
                states.viewedColors.appendLimit(item: ViewedColor(red: selectedColor.components.red, green: selectedColor.components.green, blue: selectedColor.components.blue, viewedTime: Date()), limit: maxViewedColors)
            }
        }
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(colors: [DetectedColor(color: .orange)], showModalButtons: true, selectedDetent: .large)
    }
}
