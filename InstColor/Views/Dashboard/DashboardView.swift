//
//  DashboardView.swift
//  InstColor
//
//  Created by Lei Cao on 10/10/22.
//

import SwiftUI

struct ResultTextContainerView: View {
    let color: UIColor
    let baseColorName: String
    let baseColorHex: String
    
    @State var showBaseColor = false
    
    func toggleShowBaseColor() {
        showBaseColor.toggle()
    }
    
    var body: some View {
        Button(action: toggleShowBaseColor) {
            VStack {
                if showBaseColor {
                    if let baseColor = UIColor(hex: baseColorHex) {
                        VStack {
                            Text("Family Color:")
                                .bold()
                            HStack {
                                BorderedRectView(color: Color(baseColor), cornerRadius: 40, lineWidth: 1, width: 15, height: 15)
                                Text("\(baseColorName)")
                                    .foregroundColor(.white)
                            }
                        }
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding([.trailing])
                    }
                } else {
                    ColorTextGroupView(components: color.components)
                }
            }
            .animation(.easeIn, value: showBaseColor)
        }
    }
}

struct DominantColorsView: View {
    @Binding var selectedDentent: PresentationDetent
    @Binding var showColorDetail: Bool

    let colors: [DetectedColor]
    
    let viewSize = screenRatio * 20
    
    var body: some View {
        VStack {
            if let colors {
                Text("Dominant colors / Frequency")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Button(action: { showColorDetail.toggle() }) {
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            VStack {
                                BorderedRectView(color: Color(color.color), cornerRadius: 1, lineWidth: 1, width: viewSize, height: viewSize)
                                Text((String(format: "%.0f%%", color.frequency * 100)))
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .animation(.easeIn, value: colors)
        .sheet(isPresented: $showColorDetail) {
            ColorDetailView(colors: colors, showModalButtons: true, selectedDetent: selectedDentent, saveHistory: true)
                .presentationDetents([.medium, .large], selection: $selectedDentent)
        }
    }
}

struct DashboardView: View {
    @ObservedObject var model: ContentViewModel
    @StateObject var resultModel: ColorResultViewModel
    
    init(model: ContentViewModel) {
        self.model = model
        self._resultModel = StateObject(wrappedValue: ColorResultViewModel(camera: model.cameraManager))
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                if model.frameSource == .wholeImage {
                    DominantColorsView(selectedDentent: $resultModel.selectedDentent, showColorDetail: $resultModel.showColorDetail, colors: resultModel.detectedColors)
                } else {
                    ColorResultView(model: resultModel)
                    Spacer()
                    if let color = resultModel.color {
                        ResultTextContainerView(color: color, baseColorName: resultModel.baseColorName, baseColorHex: resultModel.baseColorHex)
                    }
                }
            }
            .padding()
            .background(.black)
            .onChange(of: model.averageColor) { color in
                resultModel.color = color
            }
            .onChange(of: model.dominantColors) { colors in
                resultModel.detectedColors = colors
            }
            .modifier(FloatToolbarViewModifier(model: model))
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            model.dashboardHeight = geo.size.height
                        }
                }
            )
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(model: ContentViewModel())
    }
}
