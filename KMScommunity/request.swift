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

// 필요한 전역변수 라고 치자. 
let urlString = "http://35.89.32.201:8080"



struct LoginResponse: Codable {
    var status: String
    var message: String
    var code : Int
    var data: UserData
    struct UserData: Codable {
        var memberId: String
        var nickname: String
    }
    
}

func postUserLogin(loginId : String, loginPw : String) async -> LoginResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/login") else {
        print("Error: cannot create URL")
        return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.UserData(memberId: "", nickname: "error"))
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
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(LoginResponse.self, from: data)
        print(decodedData)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("error")
            print(response)
            // 원래는 throw로 해야될듯.
            return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.UserData(memberId: "", nickname: "error"))
        }
        return decodedData
    } catch {
        print(error)
        return LoginResponse(status: "error", message: "error", code: -1, data: LoginResponse.UserData(memberId: "", nickname: "error"))
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
    static var sampleData : MainBoardResponse = MainBoardResponse(data: [MainBoard()], status: "status", message: "message", code: -1)
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
    var like : Bool = false
    var likeCount : Int = -1
    
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
        var like: Bool = false
    }
    var status: String
    var message: String
    var code : Int
    var data : data = data()
    
    //var category: String = "Initial"
}

func getBoardDetail(boardId: String) async -> BoardDetail {
    // 수정해야할것,
    // post  보낼때 {"boardId" : "", "memberId", ""}
    // response origin + like: boolean
    print("BoardDetail Start")
    guard var urlComponents = URLComponents(string: urlString + "/board") else {
        print("Error: cannot create URL")
        return BoardDetail(status: "error", message: "error", code: -1)   // fix this line to error messsage or throw or ..
    }
    
    let dicData = ["boardId": boardId, "memberId": curUser.memberId] as Dictionary<String, String>
    let jsonData = try! JSONSerialization.data(withJSONObject: dicData)
    
    
    
    var requestURL = URLRequest(url: urlComponents.url!) //! is okay?
    requestURL.httpMethod = "POST"
    requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
    requestURL.httpBody = jsonData
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            print(String(bytes: data, encoding: String.Encoding.utf8))
            print(response)
            return BoardDetail(status: "error", message: "error", code: -1)
        }
        print(httpResponse.statusCode)
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        let boardDetail = try JSONDecoder().decode(BoardDetail.self, from: data)
        print(boardDetail)
        print("BoardDetail Done")
        return boardDetail
    }
    catch {
        print("BoardDetail Done with Error")
        return BoardDetail(status: "error", message: "error", code: -1)
    }
}

struct BoardCreate : Codable {
    var title : String
    var contents : String
    var category: String = "Initial"
    var memberId: String
}

func postBoardCreate(boardCreate: BoardCreate) async -> Void {
    print("Now Board Create Func")
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
    // Optional("{\"status\":\"OK\",\"message\":\"success\",\"code\":200,\"data\":\"fail\"}")
    // seems like there is error in board create. 아마 보낼때 json양식이 문제가 있는게 아닐까.
    print("Board Create Func Done")
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
