//
//  BoardView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/02.
//

import SwiftUI

struct BoardView: View {
    
    @State private var searchText: String = ""
    
    enum SearchOptions: String, CaseIterable, Identifiable {
        case 제목, 내용, 글쓴이
        var id: Self {self}
    }
    @State private var selectionOption = SearchOptions.제목
    @State var boardList = MainBoardResponse()
    
    @State var isLoading = false
    
    @State var curPage = 0
    @State var isAddButtonSelect :Int? = nil
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(curUser.nickname)
                        .padding(.leading)
                    Spacer()
                    Picker("SearchOption", selection: $selectionOption) {
                        ForEach(SearchOptions.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    TextField("Search", text: $searchText)
                        .frame(width: 150)
                    Button {
                        
                    } label: {
                        Text("Search")
                    }
                    .padding(.trailing)
                }
                // navigation to createboard
                NavigationLink(destination: BoardCreateView(), tag: 1, selection: $isAddButtonSelect) {
                    //Empty view
                }
                List{
                    HStack {
                        Text("현재 페이지 : \(curPage)")
                        Spacer()
                        
                        Button("새글작성") {
                            isAddButtonSelect = 1
                            
                        }
                        .buttonStyle(.borderedProminent)
                    }
                     
                    ForEach(boardList.data) { board in
                        NavigationLink(destination: BoardDetailView(boardId: board.boardId)) {
                            BoardCardView(board: board)
                        }
                    }
                    
                    
                    
                    HStack {
                        if curPage > 0 {
                            Button("이전") {
                                curPage -= 1
                                Task {
                                    isLoading = true
                                    print("boardview appeared?")
                                    await boardList = getBoardList(page: curPage)
                                    isLoading = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                        // 마지막 페이지인지는 아직 모르니까 그냥 냅두자.
                        Button("다음") {
                            curPage+=1
                            Task {
                                isLoading = true
                                print("boardview appeared?")
                                await boardList = getBoardList(page: curPage)
                                isLoading = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    HStack {
                        Text("현재 페이지 : \(curPage)")
                        Spacer()
                            
                    }
                }
                
                
                // page 컨트롤
                
                
            }
            // 아래는 그 플로팅 +
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    NavigationLink(destination: BoardCreateView()) {
//                        Text("+")
//                            .font(.system(.largeTitle))
//                            .frame(width: 77, height: 70)
//                            .foregroundColor(Color.white)
//                            .padding(.bottom, 7)
//                    }
//                    .background(Color.blue)
//                    .cornerRadius(38.5)
//                    .padding()
//                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
//                }
//            }
            if isLoading {
                ProgressView()
            }
            
            
        }
        .task {
            isLoading = true
            print("boardview appeared?")
            await boardList = getBoardList(page: curPage)
            isLoading = false
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BoardView()
        }
    }
}
