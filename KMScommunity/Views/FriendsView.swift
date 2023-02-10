//
//  FriendsView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/10.
//

import SwiftUI

struct friendListResponse: Codable {
    var status: String = ""
    var message: String = ""
    var code: Int = -1
    var data: [friend] = []
    struct friend : Codable {
        var memberId: String = ""
        var nickname: String = ""
        init(memberId: String, nickname: String) {
            self.memberId = memberId
            self.nickname = nickname
        }
    }
}

func getFriendList(isAccept:Bool) async -> friendListResponse {
    guard let urlComponents = URLComponents(string: urlString + "/friend/list") else {
        print("Error: cannot create URL")
        return friendListResponse()
    }
    var whichListOfFriend = "ACCEPT"
    if isAccept == false {
        whichListOfFriend = "WAIT"
    }
    let dicData = [
        "memberId": curUser.memberId,
        "status": whichListOfFriend
    ] as Dictionary<String, String>
    let jsonData : Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
        let testjson = String(data: jsonData, encoding: .utf8) ?? ""
        print(testjson)
    } catch {
        return friendListResponse()
    }
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL)

    //see response if error
    guard let httpresponse = response as? HTTPURLResponse, 200 == httpresponse.statusCode else {
        print("Error: HTTP request failed")
        print(response)
        return friendListResponse()
    }
    
    guard let decodedData = try? JSONDecoder().decode(friendListResponse.self, from: data) else {
        return friendListResponse()
    }
    
    if decodedData.code != 200 {
        return friendListResponse()
    }
    print(decodedData)
    print(response)
    return decodedData
}

struct FriendsView: View {
    //@State var waitFriendsList = friendListResponse().data
    //@State var friendsList = friendListResponse().data
    var friendsList = [friendListResponse.friend(memberId: "1", nickname: "abc")]
    var waitFriendsList = [friendListResponse.friend(memberId: "2", nickname: "abcdd")]
    var body: some View {
        
        VStack {
            List {
                Section("들어온 친구신청") {
                    ForEach(waitFriendsList, id: \.memberId) { friend in
                        Text(friend.nickname) //친구 신청 수락 거절 카드가 될것.
                    }
                }
                
                Section("친구목록") {
                    ForEach(friendsList, id: \.memberId) { friend in
                        Text(friend.nickname) // 친구 카드.
                    }
                }
                
            }
        }
        .task {
            //waitFriendsList = await getFriendList(isAccept: false).data
            //friendsList = await getFriendList(isAccept: true).data
                        
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
