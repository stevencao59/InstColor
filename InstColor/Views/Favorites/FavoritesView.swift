//
//  FavoritesView.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import SwiftUI

struct FavoriteColorRow: View {
    var title: String
    var uiColor: UIColor
    
    var body: some View {
        HStack {
            VStack {
                BorderedRectView(color: Color(uiColor), cornerRadius: 50, lineWidth: 2, width: 100, height: 50)
                Text(title)
                    .bold()
            }
            Spacer()
            Text("R:  ")
                .bold() +
            Text("\(Int(uiColor.components.red * 255))")
                .font(.footnote) +
            Text("  G:  ")
                .bold() +
            Text("\(Int(uiColor.components.green * 255))")
                .font(.footnote) +
            Text("  B:  ")
                .bold() +
            Text("\(Int(uiColor.components.blue * 255))")
                .font(.footnote)
        }
        .padding()
    }
}

struct CloseButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    func dismissView() {
        dismiss()
    }
    
    var body: some View {
        Button(action: dismissView) {
            Text("Close")
        }
    }
}

struct FavoritesView: View {
    @State var favoriteColors: [FavoriteColor]?
    @State var selectedColor = UIColor(.white)

    var containerCotentWidth = 0.0

    func deleteFavorites(at offsets: IndexSet) {
        if var favoriteColors {
            favoriteColors.remove(atOffsets: offsets)
            UserDefaults.standard.setColor(favoriteColors, forKey: favoritColorKey)
            self.favoriteColors = favoriteColors
        }
    }
    
    func clearFavorites() {
        UserDefaults.standard.removeObject(forKey: favoritColorKey)
        self.favoriteColors = nil
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                if let favoriteColors {
                    List {
                        ForEach(favoriteColors) { color in
                            let uiColor = UIColor(red: color.red, green: color.green, blue: color.blue)
                            let title = uiColor.calculateClosestColor()?.English ?? "Unknown Color"
                            NavigationLink(destination: ColorDetailView(color: uiColor, containerCotentWidth: containerCotentWidth, showModalButtons: false)) {
                                FavoriteColorRow(title: title, uiColor: uiColor)
                            }
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteFavorites)
                        .listRowSeparator(.automatic)
                        .listRowSeparatorTint(.white)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CloseButtonView()
                        }
                        ToolbarItem {
                            Button(action: clearFavorites) {
                                Text("Clear")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(.black)
                }
                else {
                    ZStack {
                        Rectangle()
                            .fill(.black)
                        Text("No Favorite Color is saved!")
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CloseButtonView()
                        }
                    }
                    .background(.black)
                }
            }
        }
        .foregroundColor(.white)
        .onAppear() {
            favoriteColors = UserDefaults.standard.readColor(forKey: favoritColorKey)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteColorRow(title: "Pure Red", uiColor: UIColor(.red))
    }
}
