//
//  BoardDetailView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardDetailView: View {
    @State private var disabledTextField = true
    
    @State private var BoardContent = "asdf"
    
    var boardId : Int64
    @State var boardDetail : BoardDetail = BoardDetail()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(boardDetail.title)
                        .padding(.leading)
                    Spacer()
                    Text(boardDetail.nickname)
                        .padding(.trailing)
                }
                TextEditor(text: $boardDetail.contents)
                    .disabled(disabledTextField)
                    .border(.gray)
                    .frame(width: 300, height: 300)
                    
                HStack {
                    Button {
                        disabledTextField.toggle()
                    } label: {
                        if disabledTextField {
                            Text("Edit")
                        }
                        else {
                            Text("Done")
                        }
                    }
                }
                Divider()
                ForEach(boardDetail.comments) { comment in
                    HStack {
                        Text(comment.contents)
                        Spacer()
                        Text(comment.nickname)
                        
                    }
                    .padding()
                    .border(.black)
                    .cornerRadius(5)
                }
            }
            .padding(.all)
        }
        .task {
            boardDetail = await getBoardDetail(boardId: boardId)
        }
    }
        
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(boardId: 14) //3 is first board
    }
}
