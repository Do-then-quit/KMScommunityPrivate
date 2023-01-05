//
//  BoardDetailView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct CommentCreate : Codable {
    var contents : String
    var boardId : Int64
    var memberId: Int64
}

struct BoardModify: Codable {
    var boardId : Int64
    var title : String
    var contents : String
    var category : String = "취업"
}

struct BoardDetailView: View {
    @State private var disabledTextField = true
    @State private var editButtonDisable = true
    
    @State private var BoardContent = "asdf"
    
    @State private var commentContent = ""
    
    var boardId : Int64
    @State var boardDetail : BoardDetail = BoardDetail()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextEditor(text: $boardDetail.title)
                        .disabled(disabledTextField)
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
                        if disabledTextField == true {
                            // 보내주기.
                            let curBoardModify = BoardModify(boardId: boardId, title: boardDetail.title, contents: boardDetail.contents)
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
                        }
                    } label: {
                        Text("Delete")
                    }
                    .disabled(editButtonDisable)


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
            if boardDetail.memberId == myMemberId {
                editButtonDisable = false
            }
        }
    }
        
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView(boardId: 14) //3 is first board
    }
}
