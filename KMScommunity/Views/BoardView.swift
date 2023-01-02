//
//  BoardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardView: View {
    @State private var searchText: String = ""
    
    enum SearchOptions: String, CaseIterable, Identifiable {
        case 제목, 내용, 글쓴이
        var id: Self {self}
    }
    @State private var selectionOption = SearchOptions.제목
    
    let nickname : String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(nickname)
                        .padding(.leading)
                    Spacer()
                    Picker("SearchOption", selection: $selectionOption) {
                        ForEach(SearchOptions.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    TextField("Search", text: $searchText)
                        .frame(width: 150)
                    Button {
                        
                    } label: {
                        Text("Search")
                    }
                    .padding(.trailing)
                    

                }
                List(0 ..< 10) { item in
                    // Replace Text to boardDetailview later
                    BoardCardView()
                }
                
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // Add posting button
                    } label: {
                        Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 77, height: 70)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                    }
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)

                }
            }
            
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BoardView(nickname: "testnick")
        }
    }
}
