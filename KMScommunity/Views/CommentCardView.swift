//
//  CommentCardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/05.
//

import SwiftUI

struct CommentModity : Codable {
    var commentId: String
    var contents: String
}


func postCommentLike(commentId: String) async -> Void {
    guard let urlComponents = URLComponents(string: urlString + "/comment/like") else {
        print("Error: cannot create URL")
        //throw UserError.internalError
        return
        // 이 메소드를 사용하는 곳에서 try, catch 로 에러를 처리한다. 캬
    }
    let dicData = [
        "commentId": commentId,
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
    requestURL.setValue(curUser.jwtToken, forHTTPHeaderField: "token")
    requestURL.setValue(curUser.memberId, forHTTPHeaderField: "memberId")
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL)
    // 사실 디버그 할때만 필요하긴 해 아래는.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))

    
}

struct CommentCardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editButtonDisable = true
    @State private var isEditButtonClicked = false
    
    @Binding var isEdited : Int
    
    @State var comment : Comment
    
    var body: some View {
        VStack {
            HStack {
                TextEditor(text: $comment.contents)
                    .disabled(!isEditButtonClicked)

                VStack {
                    Text(comment.nickname)
                    Button {
                        isEditButtonClicked.toggle()
                        // comment edit
                        if isEditButtonClicked == false {
                            //update
                            let curCommentModify = CommentModity(commentId: comment.commentId, contents: comment.contents)
                            Task {
                                await postCommentModify(commentModify:curCommentModify)
                                // how to update whole view
                                //BoardDetailView.updateDetailView()
                                isEdited += 1
                                
                            }
                        }
                    } label: {
                        if isEditButtonClicked {
                            Text("Done")
                        } else {
                            Text("Edit")
                        }
                    }
                    .disabled(editButtonDisable)
                    
                    Button {
                        Task {
                            await postCommentDelete(commentId:comment.commentId)
                            // how to update view
                            isEdited += 1
                        }
                    } label: {
                        Text("Delete")
                    }
                    .disabled(editButtonDisable)
                    
                    HStack {
                        Button {
                            comment.like.toggle()
                            if comment.like {
                                // 임시 처리 ㅇㅇ
                                comment.likeCount += 1
                            } else {
                                comment.likeCount -= 1
                            }
                            Task {
                                await postCommentLike(commentId:comment.commentId)
                            }
                            
                        } label: {
                            if comment.like {
                                Image(systemName: "heart.fill")
                            } else {
                                Image(systemName: "heart")
                            }
                        }
                        Text("\(comment.likeCount)")
                    }
                    
                }
            }

        }
        .padding()
        .task {
            if curUser.memberId == comment.memberId {
                editButtonDisable = false
            }
        }
    }
}

struct CommentCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommentCardView(isEdited: .constant(0), comment: Comment.sampledata)
            .previewLayout(.fixed(width: 450, height: 120))
    }
}
