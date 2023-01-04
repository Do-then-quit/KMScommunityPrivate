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

        guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        print(String(decoding: data, as: UTF8.self))
        print(response)
    }.resume()
}

struct LoginResponse: Codable {
    var memberId: Int64
    var nickname: String
    var status: String
}

func postUserLogin(loginId : String, loginPw : String) async -> LoginResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/login") else {
        print("Error: cannot create URL")
        return LoginResponse(memberId: -1, nickname: "", status: "Fail")
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
    
    let session = URLSession(configuration: .default)
    
    let (data, response) = try! await URLSession.shared.data(for: requestURL) // error 어케하지. 
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("error")
        // 원래는 throw로 해야될듯.
        return LoginResponse(memberId: -1, nickname: "", status: "Fail")
    }
    
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(LoginResponse.self, from: data)
        return decodedData
    } catch {
        print(error)
        return LoginResponse(memberId: -1, nickname: "", status: "Fail")
    }
}
    
struct MainBoardResponse: Codable, Identifiable {
    var boardId : Int64
    var contents: String
    var likeCount: Int64
    var title: String
    var viewCount: Int64
    var writeTime: String
    var id: Int {Int(boardId)}
}
    
enum getBoardError: Error {
    case urlError
    
}
func getBoardList() async -> [MainBoardResponse] {
    guard let urlComponents = URLComponents(string: urlString + "/board/list") else {
        print("Error: cannot create URL")
        return []
    }
    
    let requestURL = URLRequest(url: urlComponents.url!)
    
    do {
        let (data, response) = try! await URLSession.shared.data(for: requestURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("response error?, not 200?")
            return []
        }
        print(httpResponse.statusCode)
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        let boardList = try JSONDecoder().decode([MainBoardResponse].self, from: data)
        print("tested")
        print(boardList[0])
        print("tested2")
        return boardList
    }
    catch {
        return []
    }
}
