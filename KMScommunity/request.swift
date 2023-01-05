//
//  request.swift
//  KMScommunity
//
//  Created by 이민교 on 2022/12/30.
//

import Foundation

struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}

let urlString = "http://35.89.32.201:8080"
public var myMemberId : String = ""  // -1 for initial

func requestGetWithQuery(url: String,inputID: String, completionHandler: @escaping (Bool, Data) -> Void) {
    guard var urlComponents = URLComponents(string: urlString + url) else {
        print("Error: cannot create URL")
        return
    }
    
    let queryItem = URLQueryItem(name: "loginId", value: inputID)
    urlComponents.queryItems = [queryItem]
    guard let requestURL = urlComponents.url else {return}
    print(requestURL)
    let session = URLSession(configuration: .default)
    session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
        guard error == nil else {
            print("Error occur")
            return
        }
        
        guard let data = data else {
            return
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Not Success")
            completionHandler(false, data)
            return
        }
        
        completionHandler(true, data)

    }.resume()
}

struct RegisterResponse : Codable{
    var status : String
    var message : String
    var code : Int
    var data : String
}

// RegisterResponse(status: "OK", message: "success", code: 200, data: 9)
func postUserRegister(userId: String, userPw: String, email: String, name: String, phone: String, nickname: String) {
    guard let urlComponents = URLComponents(string: urlString + "/member/register") else {
        print("Error: cannot create URL")
        return
    }
    
    let dicData = [
        "loginId": userId,
        "loginPw": userPw,
        "email": email,
        "name": name,
        "phone": phone,
        "nickname": nickname
    ] as Dictionary<String, String>?
    
    let jsonData = try! JSONSerialization.data(withJSONObject: dicData!, options: [])
    let testjson = String(data: jsonData, encoding: .utf8) ?? ""
    print(testjson)
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
        guard error == nil else {
            print("Error occur: error calling POST - \(String(describing: error))")
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse, 200 == response.statusCode else {
            print("Error: HTTP request failed")
            print(response)
            return
        }
        let decodedData = try! JSONDecoder().decode(RegisterResponse.self, from: data)
        print(decodedData)

        //print(String(decoding: data, as: UTF8.self))
        print(response)
    }.resume()
}

struct LoginResponse: Codable {
    var status: String
    var message: String
    var code : Int
    var data: data
    struct data: Codable {
        var memberId: String
        var nickname: String
    }
    
}

func postUserLogin(loginId : String, loginPw : String) async -> LoginResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/login") else {
        print("Error: cannot create URL")
        return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.data(memberId: "", nickname: "error"))
    }
    
    let dicData = [
        "loginId": loginId,
        "loginPw": loginPw,
    ] as Dictionary<String, String>?
    
    let jsonData = try! JSONSerialization.data(withJSONObject: dicData!, options: [])
    let testjson = String(data: jsonData, encoding: .utf8) ?? ""
    print(testjson)
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
        
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지. 
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("error")
        print(response)
        // 원래는 throw로 해야될듯.
        return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.data(memberId: "", nickname: "error"))
    }
    
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(LoginResponse.self, from: data)
        return decodedData
    } catch {
        print(error)
        return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.data(memberId: "", nickname: "error"))
    }
}
    
struct MainBoardResponse: Codable {
    struct MainBoard : Codable, Identifiable {
        var boardId : String = ""
        var contents: String = "cont"
        var likeCount: Int64 = -1
        var title: String = "asdf"
        var viewCount: Int64 = -1
        var writeTime: String = "writeitme"
        var id: String {boardId}
    }
    var data: [MainBoard] = []
    var status: String = "asdf"
    var message: String = "message"
    var code : Int = -1
    
}
extension MainBoardResponse {
    static var sampleData : MainBoardResponse = MainBoardResponse(data: [], status: "status", message: "message", code: -1)
}
    
enum getBoardError: Error {
    case urlError
}

func getBoardList() async -> MainBoardResponse {
    guard let urlComponents = URLComponents(string: urlString + "/board/list") else {
        print("Error: cannot create URL")
        return MainBoardResponse()
    }
    
    let requestURL = URLRequest(url: urlComponents.url!)
    
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            return MainBoardResponse()
        }
        print(httpResponse.statusCode)
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        let boardList = try JSONDecoder().decode(MainBoardResponse.self, from: data)
        //print(boardList[0])
        return boardList
    }
    catch {
        return MainBoardResponse()
    }
}

//comment struct need
struct Comment : Codable, Identifiable {
    var commentId :String
    var id : String {commentId}
    var contents: String
    var nickname: String
    var writeTime: String
    var memberId: String
    
    static let sampledata :Comment = Comment(commentId: "", contents: "댓글데스", nickname: "닉네임", writeTime: "써진 시간", memberId: "")
}
//boardDetail struct need
struct BoardDetail: Codable {
    struct data: Codable, Identifiable {
        var boardId: String = ""
        var id: String {boardId}
        var title: String = "Initial"
        var contents: String = "Initial"
        var nickname: String = "Initial"
        var writeTime: String = "Initial"
        var likeCount: Int64 = -1
        var memberId: String = ""
        var fail: Bool? = nil
        var comments: [Comment] = []
    }
    var status: String
    var message: String
    var code : Int
    var data : data = data()
    
    //var category: String = "Initial"
}

func getBoardDetail(boardId: String) async -> BoardDetail {
    guard var urlComponents = URLComponents(string: urlString + "/board") else {
        print("Error: cannot create URL")
        return BoardDetail(status: "error", message: "error", code: -1)   // fix this line to error messsage or throw or ..
    }
    
    let queryBoard = URLQueryItem(name: "boardId", value: String(boardId))
    urlComponents.queryItems = [queryBoard]
    
    let requestURL = URLRequest(url: urlComponents.url!) //! is okay?
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            return BoardDetail(status: "error", message: "error", code: -1)
        }
        print(httpResponse.statusCode)
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        let boardDetail = try JSONDecoder().decode(BoardDetail.self, from: data)
        print(boardDetail)
        return boardDetail
    }
    catch {
        return BoardDetail(status: "error", message: "error", code: -1)
    }
}

struct BoardCreate : Codable {
    var title : String
    var contents : String
    var category: String = "취업"
    var memberId: String
}

func postBoardCreate(boardCreate: BoardCreate) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/board/register") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let jsonBoardCreate = try! JSONEncoder().encode(boardCreate)
    
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonBoardCreate
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
//    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//        print("error")
//        // 원래는 throw로 해야될듯.
//        return
//    }
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))
}

func postCommentCreate(commentCreate: CommentCreate) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/comment/register") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let jsonCommentCreate = try! JSONEncoder().encode(commentCreate)
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonCommentCreate
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))
    
}

func postBoardModify(boardModify: BoardModify) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/board/modify") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let jsonBoardModify = try! JSONEncoder().encode(boardModify)
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonBoardModify
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))
}

func postBoardDeletew(boardId: String) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/board/delete") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let formDataString = "boardId=\(boardId)"
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.httpBody = formDataString.data(using: .utf8)
    requestURL.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))
}

func postCommentDelete(commentId: String) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/comment/delete") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let formDataString = "commentId=\(commentId)"
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.httpBody = formDataString.data(using: .utf8)
    requestURL.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))
}

func postCommentModify(commentModify: CommentModity) async -> Void {
    guard var urlComponents = URLComponents(string: urlString + "/comment/modify") else {
        print("Error: cannot create URL")
        return    // fix this line to error messsage or throw or ..
    }
    let jsonCommentModify = try! JSONEncoder().encode(commentModify)
    var requestURL = URLRequest(url: urlComponents.url!)
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonCommentModify
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지.
    print(response)
    print(String(bytes: data, encoding: String.Encoding.utf8))

}
