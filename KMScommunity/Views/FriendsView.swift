//
//  FriendsView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/10.
//

import SwiftUI

struct FriendsView: View {
    @State var waitFriendsList = friendListResponse().data
    @State var friendsList = friendListResponse().data
    @State var nicknameTextfield : String = ""
    @State var isRequestSended: Bool? = nil
    
    var body: some View {
        // 모든 버튼은 누를 때마다 데이터를 새로 고쳐야 합니다 ㅎㅎ;;
        VStack {
            List {
                
                Section(content: {
                    HStack {
                        TextField("친구 추가", text: $nicknameTextfield)
                        Button("요청") {
                            // 해야함.
                            Task {
                                if await sendFriendRequest(nickname: nicknameTextfield) {
                                    // request success
                                    isRequestSended = true
                                } else {
                                    // error
                                    isRequestSended = false
                                }
                                waitFriendsList = await getFriendList(isAccept: false).data
                                friendsList = await getFriendList(isAccept: true).data
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(nicknameTextfield == "")
                        
                    }
                }, header: {
                    Text("친구 추가")
                }, footer: {
                    if isRequestSended == nil {
                        Text("친구 추가 상태")
                    } else if isRequestSended == true {
                        Text("전송 완료")
                    } else {
                        Text("전송 실패")
                    }
                })
                
                
                        
                
                Section("들어온 친구신청") {
                    ForEach(waitFriendsList, id: \.memberId) { friend in
                        HStack {
                            Text(friend.nickname)
                            Spacer()
                            Button("수락") {
                                //해야할.
                                Task {
                                    if await acceptFriend(opMemberId: friend.memberId) {
                                        //수락 성공
                                    } else {
                                        //수락 실패
                                    }
                                    waitFriendsList = await getFriendList(isAccept: false).data
                                    friendsList = await getFriendList(isAccept: true).data
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            Button("거절") {
                                //나중에
                            }
                            .buttonStyle(.borderedProminent)
                            
                        }
                        // 친구 요청 받은건지 보낸건지 구분이 되야할듯. 내 선에서 할게 없다.
                    }
                }
                
                
                Section("친구목록") {
                    ForEach(friendsList, id: \.memberId) { friend in
                        HStack {
                            Text(friend.nickname)
                            Spacer()
                            Menu {
                                Button("삭제") {
                                    // 친구 삭제. 나중에
                                }
                            } label: {
                                Label("더보기", systemImage: "ellipsis.circle")
                                    .labelStyle(.iconOnly)
                            }

                        } // 친구 카드.
                            
                    }
                }
                
            }
        }
        .task {
            waitFriendsList = await getFriendList(isAccept: false).data
            friendsList = await getFriendList(isAccept: true).data
                        
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
