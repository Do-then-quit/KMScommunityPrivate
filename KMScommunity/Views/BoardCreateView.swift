//
//  BoardCreateView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/05.
//

import SwiftUI

struct BoardCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var BoardContent = ""
    @State private var BoardTitle = ""
    @State private var categoryOption = "잡담"
    
    var body: some View {
        ScrollView {
            VStack {
                Picker("카테고리", selection: $categoryOption) {
                    ForEach(curUser.categorys, id: \.self) { category in
                        Text(category)
                    }
                }
                HStack {
                    TextEditor(text: $BoardTitle)
                        .border(.gray)
                        .frame(width: 300, height: 40)
    
                }
                TextEditor(text: $BoardContent)
                    .border(.gray)
                    .frame(width: 300, height: 300)
                    
                HStack {
                    Button {
                        // send create request, pop
                        let newBoardCreate = BoardCreate(title: BoardTitle, contents: BoardContent, category: categoryOption, memberId: curUser.memberId)
                        Task {
                            await postBoardCreate(boardCreate:newBoardCreate)
                            dismiss()
                        }
                    } label: {
                        Text("Done")
                    }
                }
                Divider()
                
            }
            .padding(.all)
        }
        .task {
            
        }
    }
}

struct BoardCreateView_Previews: PreviewProvider {
    static var previews: some View {
        BoardCreateView()
    }
}
