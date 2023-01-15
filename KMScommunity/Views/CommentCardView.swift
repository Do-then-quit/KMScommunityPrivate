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

struct CommentCardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editButtonDisable = true
    @State private var isEditButtonClicked = false
    
    @Binding var isEdited : Int
    
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


            }
            
        }
        .padding()
        .border(.black)
        .cornerRadius(5)
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
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
