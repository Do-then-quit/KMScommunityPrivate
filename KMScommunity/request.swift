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

