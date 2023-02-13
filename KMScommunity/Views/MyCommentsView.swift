//
//  MyCommentsView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/08.
//

import SwiftUI

struct MyCommentsResponse:Codable {
    var status: String = ""
    var message: String = ""
    var code : Int = -1
    struct Comment :Codable{
        var contents: String = ""
        var boardId: String = ""
        var writeTime: Date = Date()
        //var id: UUID? = UUID()
    }
    var data: [Comment] = []
}

func getMyCommentList() async -> MyCommentsResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/mycomments") else {
        print("Error: cannot create URL")
        return MyCommentsResponse()
    }
    
    let dicData = ["memberId" : curUser.memberId] as Dictionary<String, String>
    let jsonData = try! JSONSerialization.data(withJSONObject: dicData, options: [])
        
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    requestURL.setValue(curUser.jwtToken, forHTTPHeaderField: "token")
    requestURL.setValue(curUser.memberId, forHTTPHeaderField: "memberId")
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            return MyCommentsResponse()
        }
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        // custom formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let commentList = try decoder.decode(MyCommentsResponse.self, from: data)
        //print(boardList[0])
        //print(boardList)
        return commentList
    }
    catch {
        print("Error in Get Board")
        return MyCommentsResponse()
    }
}
struct MyCommentsView: View {
    @State var commentList = MyCommentsResponse()
    @State var isLoading = true
    
    var body: some View {
        ZStack {
            List{
                // writeTime이 다 같으면 어카지. 구분이 흠...
                ForEach(commentList.data, id: \.writeTime) { comment in
                    NavigationLink(destination: BoardDetailView(boardId: comment.boardId)) {
                        VStack {
                            Text(comment.contents)
                            Text(comment.writeTime.formatted(.dateTime
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
                    }
                }
            }
            if isLoading {
                LoadingView()
            }
        }
        .task {
            isLoading = true
            commentList = await getMyCommentList()
            isLoading = false
        }
    }
}

struct MyCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        MyCommentsView()
    }
}
