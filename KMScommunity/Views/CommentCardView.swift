//
//  CommentCardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/05.
//

import SwiftUI

struct CommentModity : Codable {
    var commentId: Int64
    var contents: String
}

struct CommentCardView: View {
    @State private var editButtonDisable = true
    @State private var isEditButtonClicked = false
    
    @State var comment : Comment
    
    var body: some View {
        HStack {
            TextEditor(text: $comment.contents)
                .disabled(!isEditButtonClicked)
            Spacer()
            TextEditor(text: $comment.nickname)
                .disabled(true)
            VStack {
                Button {
                    isEditButtonClicked.toggle()
                    // comment edit
                    if isEditButtonClicked == false {
                        //update
                        let curCommentModify = CommentModity(commentId: comment.commentId, contents: comment.contents)
                        Task {
                            await postCommentModify(commentModify:curCommentModify)
                            // how to update whole view
                            
                            
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
                    }
                } label: {
                    Text("Delete")
                }
                .disabled(editButtonDisable)


            }
            
        }
        .padding()
        .border(.black)
        .cornerRadius(5)
        .task {
            if myMemberId == comment.memberId {
                editButtonDisable = false
            }
        }
    }
}

struct CommentCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommentCardView(comment: Comment.sampledata)
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
