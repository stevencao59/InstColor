//
//  ReferenceView.swift
//  InstColor
//
//  Created by Lei Cao on 12/3/22.
//

import SwiftUI

struct ReferenceRowView: View {
    var mapItem: RGBColor
    var containerCotentWidth = 0.0

    var body: some View {
        VStack {
            BorderedRectView(color: Color(UIColor(red: mapItem.Red, green: mapItem.Green, blue: mapItem.Blue)), cornerRadius: 15, lineWidth: 2, height: 50)
            Text(mapItem.Color)
                .font(.footnote)
                .lineLimit(1, reservesSpace: false)
        }
    }
}

struct ReferenceSectionView: View {
    var item:  Dictionary<String, [RGBColor]>.Element
    var containerCotentWidth: CGFloat
    var title: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(item.value, id: \.self) { mapItem in
                    ZStack {
                        NavigationLink(destination: ColorDetailView(color: UIColor(red: mapItem.Red, green: mapItem.Green, blue: mapItem.Blue), containerCotentWidth: containerCotentWidth, showModalButtons: false, selectedDetent: .large)) {
                            ReferenceRowView(mapItem: mapItem)
                        }
                    }
                    .listRowBackground(Color.black)
                }
            }
            .navigationTitle(title)
            .scrollContentBackground(.hidden)
            .background(.black)
        }
    }
}

struct ReferencesView: View {
    @State var colorMaps: [RGBColor]?

    var containerCotentWidth = 0.0
    
    init(colorMaps: [RGBColor]? = nil, containerCotentWidth: Double = 0.0) {
        self.colorMaps = colorMaps
        self.containerCotentWidth = containerCotentWidth
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                if let colorMaps {
                    let groupedColors = Dictionary(grouping: colorMaps, by: { $0.BaseColor } )
                    List {
                        ForEach(Array(groupedColors), id: \.key) { item in
                            NavigationLink(destination: ReferenceSectionView(item: item, containerCotentWidth: containerCotentWidth, title: item.key)) {
                                HStack {
                                    if let sectionColor = UIColor(hex: item.value[0].BaseColorHex) {
                                        BorderedRectView(color: Color(sectionColor), cornerRadius: 10, lineWidth: 2, width: 10, height: 10)
                                    }
                                    Text(item.key)
                                }
                            }
                            .listRowBackground(Color.black)
                        }
                    }
                    .modifier(SimpleModalViewModifier())
                    .navigationTitle("References")
                    .navigationBarTitleDisplayMode(.inline)
                    .scrollContentBackground(.hidden)
                    .background(.black)
                }
            }
        }
        .onAppear() {
            colorMaps = Bundle.main.decode("color.json")
        }
    }
}

struct ReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        ReferencesView(containerCotentWidth: 100)
    }
}
