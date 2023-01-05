//
//  BoardDetailView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct CommentCreate : Codable {
    var contents : String
    var boardId : String
    var memberId: String
}

struct BoardModify: Codable {
    var boardId : String
    var title : String
    var contents : String
    var category : String = "취업"
}

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var disabledTextField = true
    @State private var editButtonDisable = true

    
    @State private var BoardContent = "asdf"
    
    @State private var commentContent = ""
    
    var boardId : String
    @State var boardDetail : BoardDetail = BoardDetail(status: "asdf", message: "asdf", code: -1)
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextEditor(text: $boardDetail.data.title)
                        .disabled(disabledTextField)
                        .padding(.leading)
                    Spacer()
                    Text(boardDetail.data.nickname)
                        .padding(.trailing)
                }
                TextEditor(text: $boardDetail.data.contents)
                    .disabled(disabledTextField)
                    .border(.gray)
                    .frame(width: 300, height: 300)
                    
                HStack {
                    Button {
                        disabledTextField.toggle()
                        if disabledTextField == true {
                            // 보내주기.
                            let curBoardModify = BoardModify(boardId: boardId, title: boardDetail.data.title, contents: boardDetail.data.contents)
                            Task {
                                await postBoardModify(boardModify:curBoardModify)
                                boardDetail = await getBoardDetail(boardId: boardId)
                            }
                        }
                        // edit 결과물 보내주기.
                    } label: {
                        if disabledTextField {
                            Text("Edit")
                        }
                        else {
                            Text("Done")
                        }
                    }
                    .disabled(editButtonDisable)
                    Button {
                        Task {
                            await postBoardDeletew(boardId:boardId)
                            // navigation pop
                            dismiss()
                        }
                    } label: {
                        Text("Delete")
                    }
                    .disabled(editButtonDisable)


                }
                Divider()
                ForEach(boardDetail.data.comments) { comment in
                    CommentCardView(comment: comment)
                        
                        
                    
                }
                Divider()
                HStack {
                    TextEditor(text: $commentContent)
                        .border(.blue)
                    Button {
                        // Task
                        let curCommentCreate = CommentCreate(contents: commentContent, boardId: boardId, memberId: myMemberId)
                        Task {
                            await postCommentCreate(commentCreate:curCommentCreate)
                            boardDetail = await getBoardDetail(boardId: boardId)
                            commentContent = ""
                        }
                    } label: {
                        Text("댓글 작성")
                    }

                }
                
            }
            .padding(.all)
        }
        .task {
            boardDetail = await getBoardDetail(boardId: boardId)
            if boardDetail.data.memberId == myMemberId {
                editButtonDisable = false
            }
        }
    }
    
    func updateDetailView() async -> Void {
        boardDetail = await getBoardDetail(boardId: boardId)
    }
        
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(boardId: "") //3 is first board
    }
}
