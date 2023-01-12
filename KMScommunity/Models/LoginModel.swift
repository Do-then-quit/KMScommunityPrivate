//
//  LoginModel.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/12.
//

import Foundation

public var myMemberId : String = ""  // -1 for initial
var curUser = LoginUser()   // 전역으로 써먹는 변수.

struct LoginUser {
    enum UserError : Error{
        case internalError
        case responseError
        case networkError
    }
    
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
    
    var memberId: String = ""
    var userId: String = ""
    var userPw: String = ""
    var nickname: String = ""
    
    func postUserLogin() async throws -> Void {
        guard let urlComponents = URLComponents(string: urlString + "/member/login") else {
            print("Error: cannot create URL")
            throw UserError.internalError
            // 이 메소드를 사용하는 곳에서 try, catch 로 에러를 처리한다. 캬
        }
        
        let dicData = [
            "loginId": userId,
            "loginPw": userPw,
        ] as Dictionary<String, String>
        let jsonData : Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
            let testjson = String(data: jsonData, encoding: .utf8) ?? ""
            print(testjson)
        } catch {
            throw UserError.internalError
        }
        
        var requestURL = URLRequest(url: urlComponents.url!)
        requestURL.httpMethod = "POST"
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: requestURL)

        //see response if error
        guard let httpresponse = response as? HTTPURLResponse, 200 == httpresponse.statusCode else {
            print("Error: HTTP request failed")
            print(response)
            throw UserError.responseError
        }
        
        guard let decodedData = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw UserError.internalError
        }
        
        if decodedData.code != 200 {
            throw UserError.responseError
        }
        print(decodedData)
        print(response)
        curUser.memberId = decodedData.data.memberId
        curUser.nickname = decodedData.data.nickname
        curUser.userId = userId
        curUser.userPw = userPw
    }
}

