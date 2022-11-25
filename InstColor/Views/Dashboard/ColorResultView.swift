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
    
    let color: UIColor
    
    var containerCotentWidth: Double
    
    var colorDisplayName: String {
        return model.colorName ?? "Unknown Color"
    }
    
    func clickToShowSheet() {
        showColorDetail.toggle()
    }
    
    var body: some View {
        Button(action: clickToShowSheet) {
            HStack {
                BorderedRectView(color: Color(color), cornerRadius: 40, lineWidth: 1, width: 40, height: 40)
                    .onChange(of: color) { newValue in
                        model.color = newValue
                    }
                Text(colorDisplayName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showColorDetail) {
            ColorDetailView(color: color, containerCotentWidth: containerCotentWidth, showModalButtons: true)
                .opacity(0.8)
                .clearModalBackground()
                .presentationDetents([.medium, .large])
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorResultView(color: UIColor(.red), containerCotentWidth: 100)
        }
        .ignoresSafeArea()
    }
}
