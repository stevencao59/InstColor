//
//  ColorResultView.swift
//  InstColor
//
//  Created by Lei Cao on 10/6/22.
//

import SwiftUI

struct ColorResultView: View {
    @StateObject private var model = ColorResultViewModel()
    @State var showColorDetail = false
    @State var selectedDetent: PresentationDetent = .medium

    let color: UIColor
    
    let colorName: String
    let baseColorName: String
    
    let resultSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 40
    
    func clickToShowSheet() {
        showColorDetail.toggle()
    }
    
    var body: some View {
        Button(action: clickToShowSheet) {
            HStack {
                BorderedRectView(color: Color(color), cornerRadius: resultSize, lineWidth: 1, width: resultSize, height: resultSize)
                    .onChange(of: color) { newValue in
                        model.color = newValue
                    }
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(colorName)")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }

            }
        }
        .sheet(isPresented: $showColorDetail) {
            ColorDetailView(color: color, showModalButtons: true, selectedDetent: selectedDetent)
                .presentationDetents([.medium, .large], selection: $selectedDetent)
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorResultView(color: UIColor(.red), colorName: "Red", baseColorName: "Red")
        }
        .ignoresSafeArea()
    }
}
