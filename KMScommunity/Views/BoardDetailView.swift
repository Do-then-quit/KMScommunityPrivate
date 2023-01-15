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

func postBoardLike(boardId: String) async -> Void {
    guard let urlComponents = URLComponents(string: urlString + "/board/like") else {
        print("Error: cannot create URL")
        //throw UserError.internalError
        return
        // 이 메소드를 사용하는 곳에서 try, catch 로 에러를 처리한다. 캬
    }
    let dicData = [
        "boardId": boardId,
        "memberId": curUser.memberId
    ] as Dictionary<String, String>
    
    let jsonData : Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
        let testjson = String(data: jsonData, encoding: .utf8) ?? ""
        print(testjson)
    } catch {
        return
    }
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL)
    // 사실 디버그 할때만 필요하긴 해 아래는.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))

    
}

struct BoardDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var disabledTextField = true
    @State private var editButtonDisable = true
    
    @State private var isCommentEdited = 0

    
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
                    
                    Spacer()
                    Button {
                        // board like
                        boardDetail.data.like.toggle()
                        Task {
                            await postBoardLike(boardId: boardId)
                        }
                        
                    } label: {
                        if boardDetail.data.like {
                            Image(systemName: "heart.fill")
                        } else {
                            Image(systemName: "heart")
                        }
                        
                    }



                }
                Divider()
                ForEach(boardDetail.data.comments) { comment in
                    CommentCardView(isEdited: $isCommentEdited, comment: comment)
                }
                Divider()
                HStack {
                    TextEditor(text: $commentContent)
                        .border(.blue)
                    Button {
                        // Task
                        let curCommentCreate = CommentCreate(contents: commentContent, boardId: boardId, memberId: curUser.memberId)
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
            if boardDetail.data.memberId == curUser.memberId {
                editButtonDisable = false
            }
        }
        .task(id: isCommentEdited) {
            boardDetail = await getBoardDetail(boardId: boardId)
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
