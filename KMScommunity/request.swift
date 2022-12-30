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



let urlString = "http://35.89.32.201:8081"

func requestGetWithQuery(url: String,inputID: String, completionHandler: @escaping (Bool, Any) -> Void) {
    guard var urlComponents = URLComponents(string: urlString + url) else {
        print("Error: cannot create URL")
        return
    }
    
    let queryItem = URLQueryItem(name: "userId", value: inputID)
    urlComponents.queryItems = [queryItem]
    guard let requestURL = urlComponents.url else {return}
    print(requestURL)
    let session = URLSession(configuration: .default)
    session.dataTask(with: requestURL) { (data: Data?, response: URLResponse?, error: Error?) in
        guard error == nil else {
            print("Error occur")
            return
        }
        
        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return
        }
        
        print(String(decoding: data, as: UTF8.self))
        print(response)
    }.resume()
}

func postUserRegister(userId: String, userPw: String, email: String, name: String, phone: String, nickname: String) {
    guard var urlComponents = URLComponents(string: urlString + "/user/register") else {
        print("Error: cannot create URL")
        return
    }
    
    let dicData = [
        "userId": userId,
        "userPw": userPw,
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
//{
//  "email": "string",
//  "name": "string",
//  "nickname": "string",
//  "phone": "string",
//  "userId": "string",
//  "userPw": "string"
//}
