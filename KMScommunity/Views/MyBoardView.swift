//
//  MyBoardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/08.
//

import SwiftUI

func getMyBoardList() async -> MainBoardResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/myboards") else {
        print("Error: cannot create URL")
        return MainBoardResponse()
    }
    
    let dicData = ["memberId" : curUser.memberId] as Dictionary<String, String>
    let jsonData = try! JSONSerialization.data(withJSONObject: dicData, options: [])
        
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            return MainBoardResponse()
        }
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        // custom formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let boardList = try decoder.decode(MainBoardResponse.self, from: data)
        //print(boardList[0])
        //print(boardList)
        return boardList
    }
    catch {
        print("Error in Get Board")
        return MainBoardResponse()
    }
}
struct MyBoardView: View {
    @State var boardList = MainBoardResponse()
    @State var isLoading = true

    var body: some View {
        ZStack {
            List{
                ForEach(boardList.data) { board in
                    NavigationLink(destination: BoardDetailView(boardId: board.boardId)) {
                        BoardCardView(board: board)
                            
                    }
                }
            }
            if isLoading {
                LoadingView()
            }
        }
        .task {
            isLoading = true
            boardList = await getMyBoardList()
            isLoading = false
        }
    }
        
}

struct MyBoardView_Previews: PreviewProvider {
    static var previews: some View {
        MyBoardView()
    }
}
