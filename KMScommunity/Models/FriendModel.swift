//
//  FriendModel.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/11.
//

import Foundation

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
    var whichListOfFriend = "accepted"
    if isAccept == false {
        whichListOfFriend = "waiting"
    }
    
    guard let urlComponents = URLComponents(string: urlString + "/friend/list/" + whichListOfFriend) else {
        print("Error: cannot create URL")
        return friendListResponse()
    }
    
    let dicData = [
        "memberId": curUser.memberId
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
    requestURL.setValue(curUser.jwtToken, forHTTPHeaderField: "token")
    requestURL.setValue(curUser.memberId, forHTTPHeaderField: "memberId")
    
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

struct FriendRequestResponse : Codable{
    var status: String = ""
    var message: String = ""
    var code: Int = -1
    var data: String = ""
}

func sendFriendRequest(nickname: String) async -> Bool {
    guard let urlComponents = URLComponents(string: urlString + "/friend/register") else {
        print("Error: cannot create URL")
        return false
    }
    let dicData = [
        "memberId": curUser.memberId,
        "nickname": nickname
    ] as Dictionary<String, String>
    let jsonData : Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
        let testjson = String(data: jsonData, encoding: .utf8) ?? ""
        print(testjson)
    } catch {
        return false
    }
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    requestURL.setValue(curUser.jwtToken, forHTTPHeaderField: "token")
    requestURL.setValue(curUser.memberId, forHTTPHeaderField: "memberId")
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL)

    //see response if error
    guard let httpresponse = response as? HTTPURLResponse, 200 == httpresponse.statusCode else {
        print("Error: HTTP request failed")
        print(response)
        return false
    }
    
    guard let decodedData = try? JSONDecoder().decode(FriendRequestResponse.self, from: data) else {
        return false
    }
    
    if decodedData.code != 200 {
        return false
    }
    print(decodedData)
    print(response)
    return true
}

func acceptFriend(opMemberId: String) async -> Bool {
    print("여기부터 수락")
    guard let urlComponents = URLComponents(string: urlString + "/friend/accept") else {
        print("Error: cannot create URL")
        return false
    }
    let dicData = [
        "memberId": opMemberId,
        "opMemberId": curUser.memberId
    ] as Dictionary<String, String>
    let jsonData : Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
        let testjson = String(data: jsonData, encoding: .utf8) ?? ""
        print(testjson)
    } catch {
        return false
    }
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    requestURL.setValue(curUser.jwtToken, forHTTPHeaderField: "token")
    requestURL.setValue(curUser.memberId, forHTTPHeaderField: "memberId")
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL)

    //see response if error
    guard let httpresponse = response as? HTTPURLResponse, 200 == httpresponse.statusCode else {
        print("Error: HTTP request failed")
        print(response)
        return false
    }
    
    guard let decodedData = try? JSONDecoder().decode(FriendRequestResponse.self, from: data) else {
        return false
    }
    
    if decodedData.code != 200 {
        return false
    }
    print(decodedData)
    print(response)
    print("여기까지 수락")
    return true
}

