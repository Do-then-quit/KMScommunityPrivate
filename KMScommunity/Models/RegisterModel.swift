//
//  RegisterModel.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/10.
//

import Foundation

// id 중복 또는 회원가입 체크 가능하겠다리.
struct RegistUser : Codable{
    enum UserError : Error{
        case internalError
        case responseError
        case networkError
    }
    
    struct RegisterResponse : Codable{
        var status : String
        var message : String
        var code : Int
        // data could be myeongsub's response data. later ask and change.
        var data : String
    }
    
    var userId: String = ""
    var userPw: String = ""
    var email: String = ""
    var name: String = ""
    var nickname: String = ""
    var phone: String = ""
}

extension RegistUser {
    func postUserRegist() async throws -> Void {
        guard let urlComponents = URLComponents(string: urlString + "/member/register") else {
            print("Error: cannot create URL")
            throw UserError.internalError
            // 이 메소드를 사용하는 곳에서 try, catch 로 에러를 처리한다. 캬
        }
        
        let dicData = [
            "loginId": userId,
            "loginPw": userPw,
            "email": email,
            "name": name,
            "phone": phone,
            "nickname": nickname
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
        
        let (data, response) : (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: requestURL)
        } catch {
            throw UserError.networkError
        }
        
        //see response if error
        guard let httpresponse = response as? HTTPURLResponse, 200 == httpresponse.statusCode else {
            print("Error: HTTP request failed")
            print(response)
            throw UserError.responseError
        }
        
        // see data what comes
        do {
            let decodedData = try JSONDecoder().decode(RegisterResponse.self, from: data)
            print(decodedData)
            if decodedData.code != 200 {
                throw UserError.responseError
            }
        } catch {
            throw UserError.internalError
        }
    }
}
