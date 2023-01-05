//
//  BoardCardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardCardView: View {
    let board : MainBoardResponse.MainBoard
    
    var body: some View {
        HStack {
            Text("카테")
            Divider()
            VStack {
                Text(board.title)
                Text(board.writeTime)
            }
            Spacer()
            Divider()
            VStack {
                Label("댓글", systemImage: "text.bubble")
                Label("\(board.likeCount)", systemImage: "heart")
                Label("\(board.viewCount)", systemImage: "cursorarrow")
            }
            
        }
    }
}

struct BoardCardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardCardView(board: MainBoardResponse.sampleData.data[0])
            .previewLayout(.fixed(width: 400, height: 55))
    }
}
