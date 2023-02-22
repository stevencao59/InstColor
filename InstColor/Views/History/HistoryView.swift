//
//  HistoryView.swift
//  InstColor
//
//  Created by Lei Cao on 2/9/23.
//

import SwiftUI

struct HistoryColrGridItemView: View {
    var color: UIColor
    var viewedTime: Date
    var closestColor: (Color: String, BaseColor: String, BaseColorHex: String, Red: Int, Green: Int, Blue: Int)
    
    @State private var showAlertWindow = false
    
    init(color: Color, viewedTime: Date) {
        self.color = UIColor(color)
        self.closestColor = self.color.calculateClosestColor(colorMap: Settings.shared.colorMap)
        self.viewedTime = viewedTime
    }
    
    func saveColor() {
        saveFavoriteColor(color: color)
        showAlertWindow = true
    }
    
    var body: some View {
        VStack {
            BorderedRectView(color: Color(color), cornerRadius: 5, lineWidth: 2, height: 50)
            HStack {
                Spacer()
                VStack {
                    Group {
                        Text("\(closestColor.Color)")
                            .bold()
                        Text("R: \(Int(round(color.components.red * 255))) G: \(Int(round(color.components.green * 255))) B: \(Int(round(color.components.blue * 255)))")
                    }
                    .lineLimit(1, reservesSpace: false)
                }
                Spacer()
                Button(action: saveColor) {
                    ImageButtonView(imageName: "square.and.arrow.down")
                }
            }
            .font(.footnote)
        }
        .alert("Favorite color is saved!", isPresented: $showAlertWindow) {
            Button("Ok", role: .cancel) { }
        }
    }
}


struct HistoryView: View {
    @EnvironmentObject var states: States
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                if !states.viewedColors.isEmpty {
                        
                            List {
                                ForEach(states.viewedColors.reversed(), id: \.self) { viewColor in
                                    let color = Color(red: viewColor.red, green: viewColor.green, blue: viewColor.blue)
                                    NavigationLink(destination: ColorDetailView(colors: [DetectedColor(color: UIColor(color))], showModalButtons: false, selectedDetent: .large)) {
                                        HistoryColrGridItemView(color: color, viewedTime: viewColor.viewedTime)
                                            .listRowBackground(Color.black)
                                    }
                                }
                                .listRowBackground(Color.black)
                            }
                            Text("Here are colors you have previously detected. We keep \(maxViewedColors) colors maximum.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                    .toolbar() {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CloseButtonView()
                        }
                    }
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
                    .scrollContentBackground(.hidden)
                    .background(.black)
                    .foregroundColor(.white)
                } else {
                    PlaceholderView(placeholderImageName: "fossil.shell", placeholderText: "Viewed colors will be availble once you select any colors")
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static let states = States()
    
    
    
    static var previews: some View {
        HistoryView()
            .background(.black)
            .foregroundColor(.white)
            .onAppear() {
                states.viewedColors = [
                    ViewedColor(red: 0, green: 0, blue: 0.3, viewedTime: Date()),
                    ViewedColor(red: 0.7, green: 0, blue: 0.1, viewedTime: Date())
                ]
            }
            .environmentObject(states)
    }
}
