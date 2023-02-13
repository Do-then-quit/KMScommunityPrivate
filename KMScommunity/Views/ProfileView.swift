//
//  ProfileView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/15.
//

import SwiftUI

struct ProfileResponse : Codable{
    struct Profile :Codable{
        var nickname : String = "Initial"
        var boardCount = 0
        var commentCount = 0
        var boardLikeCount = 0
        var recentLoginTime = ""
    }
    var status: String = ""
    var message: String = ""
    var code : Int = -1
    var data: Profile = Profile()
    
}

func getProfile() async -> ProfileResponse {
    guard let urlComponents = URLComponents(string: urlString + "/member/profile") else {
        print("Error: cannot create URL")
        return ProfileResponse()
    }
    
    let dicData = [
        "memberId": curUser.memberId,
    ] as Dictionary<String, String>
    let jsonData : Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
        let testjson = String(data: jsonData, encoding: .utf8) ?? ""
        print(testjson)
    } catch {
        return ProfileResponse()
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
        return ProfileResponse()
    }
    
    guard let decodedData = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
        return ProfileResponse()
    }
    
    if decodedData.code != 200 {
        return ProfileResponse()
    }
    print(decodedData)
    print(response)
    return decodedData
}

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var myProfile = ProfileResponse()
    @State var isLoading = true
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(myProfile.data.nickname)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button("LogOut") {
                        UserDefaults.standard.set(false, forKey: "isAutoLogin")
                        UserDefaults.standard.set("", forKey: "userId")
                        UserDefaults.standard.set("", forKey: "userPw")
                        dismiss()
                    }
                        
                }
                .padding()
                Divider()
                NavigationLink(destination: MyBoardView()) {
                    Text("내가 쓴 글 수 : \(myProfile.data.boardCount)")
                }
                .padding()
                NavigationLink(destination: MyCommentsView()) {
                    Text("내가 쓴 댓글 수 : \(myProfile.data.commentCount)")
                }
                .padding()
                Text("내가 누른 하트 수 : \(myProfile.data.boardLikeCount)")
                Spacer()
                
            }
            if isLoading {
                LoadingView()
            }
            
        }
        .task {
            isLoading = true
            myProfile = await getProfile()
            isLoading = false
        }
        
        
    }
    
        
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
