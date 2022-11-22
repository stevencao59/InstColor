//
//  FavoritesView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct FavoritesView: View {
    @State var favoriteColors: [FavoriteColor]?
    @State var selectedColor = UIColor(.white)
    @State var showDetailColor = false

    var containerCotentWidth = 0.0

    @Environment(\.dismiss) private var dismiss
    
    func dismissView() {
        dismiss()
    }
    
    func deleteFavorites(at offsets: IndexSet) {
        if var favoriteColors {
            favoriteColors.remove(atOffsets: offsets)
            self.favoriteColors = favoriteColors
        }
    }
    
    var body: some View {
        VStack {
            if let favoriteColors {
                NavigationStack {
                    List {
                        ForEach(favoriteColors) { color in
                            let uiColor = UIColor(red: color.red, green: color.green, blue: color.blue)
                            let title = uiColor.calculateClosestColor()?.English ?? "Unknown Color"
                            NavigationLink(destination: ColorDetailView(color: uiColor, containerCotentWidth: containerCotentWidth)) {
                                HStack {
                                    BorderedRectView(color: Color(uiColor), cornerRadius: 15, lineWidth: 5, width: 100, height: 50)
                                    Spacer()
                                    VStack {
                                        Text(title)
                                            .font(.subheadline)
                                            .padding([.bottom])
                                        Text("R: \(color.red) G: \(color.green) B: \(color.blue)")
                                            .font(.footnote)
                                    }
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: dismissView) {
                                Text("Close")
                            }
                        }
                        ToolbarItem {
                            Button(action: { }) {
                                Text("Clear")
                            }
                        }
                    }
                    .sheet(isPresented: $showDetailColor) {
                        ColorDetailView(color: selectedColor, containerCotentWidth: containerCotentWidth)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.black)
                }

            } else {
                Text("No Favorite Color is saved!")
            }
        }
        .background(.black)
        .foregroundColor(.white)
        .onAppear() {
            favoriteColors = UserDefaults.standard.readColor(forKey: "FavoriteColors")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
