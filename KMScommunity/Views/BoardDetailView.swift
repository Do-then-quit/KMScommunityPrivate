//
//  BoardDetailView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardDetailView: View {
    @Environment(\.editMode) private var editMode
    @State private var disabledTextField = true
    
    @State private var BoardContent = "asdf"
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                    Spacer()
                    Text("글쓴이")
                        .padding(.trailing)
                }
                TextEditor(text: $BoardContent)
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
            }
            .padding(.all)
        }
    }
}

struct BoardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BoardDetailView()
    }
}
