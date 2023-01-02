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

func postUserLogin(loginId : String, loginPw : String) -> Bool {
    guard let urlComponents = URLComponents(string: urlString + "/member/login") else {
        print("Error: cannot create URL")
        return false
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
    
    var isSessionSuccess = false
    session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
        guard error == nil else {
            print("Error occur: error calling POST - \(String(describing: error))")
            return
        }

        guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        print(data)
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LoginResponse.self, from: data)
            print(decodedData)
        } catch {
            print(error)
        }
        
        print(response)
        isSessionSuccess = true
        
    }.resume()
    
    return isSessionSuccess
}
