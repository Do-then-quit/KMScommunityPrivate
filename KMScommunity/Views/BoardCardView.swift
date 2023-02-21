//
//  BoardCardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct board {
    var response : MainBoardResponse
    
}

struct BoardCardView: View {
    let board : MainBoardResponse.MainBoard
    
    var body: some View {

        HStack {
            Text(board.category)
                .font(.caption2)
            Divider()
            VStack {
                Text(board.title)
                Text(board.writeTime.formatted(.dateTime
                    .year()
                    .month()
                    .day()
                    .hour()
                    .minute()
                    .second()
                    .locale(Locale(identifier: "ko"))
                    )
                )
                .font(.caption)
                
            }
            Spacer()
            Divider()
            VStack {
                Label("\(0)", systemImage: "text.bubble")
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
