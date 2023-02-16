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
        case 제목 = "title"
        case 내용 = "content"
        case 닉네임 = "nickname"
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
                
                // navigation to createboard
                NavigationLink(destination: BoardCreateView(), tag: 1, selection: $isAddButtonSelect) {
                    //Empty view
                }
                List{
                    Text(curUser.nickname)
                        .padding(.leading)
                    HStack {
                        
                        Picker("", selection: $selectionOption) {
                            ForEach(SearchOptions.allCases) {
                                Text($0.rawValue)
                            }
                        }
                        TextField("", text: $searchText)
                            .frame(width: 200)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            Task {
                                isLoading = true
                                // 이제 getBoardList 에는 searchOption, searchText들어가자.
                                await boardList = getBoardList(page: curPage, searchOption: selectionOption, searchText: searchText)
                                isLoading = false
                            }
                        } label: {
                            Text("검색")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    HStack {
                        Text("현재 페이지 : \(curPage + 1)")
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
                            Button("<") {
                                curPage -= 1
                                Task {
                                    isLoading = true
                                    print("boardview appeared?")
                                    // todo : 이제 getBoardList 에는 searchOption, searchText들어가자.
                                    await boardList = getBoardList(page: curPage)
                                    isLoading = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        Spacer()
                        
                        // 나중에 페이지 수가 많으면 어캄.
                        ForEach(0..<(boardList.totalPages ?? 0), id:\.self) { page in
                            Button("\(page+1)") {
                                curPage = page
                                Task {
                                    isLoading = true
                                    print("boardview appeared?")
                                    // todo : 검색 기능 추가
                                    await boardList = getBoardList(page: curPage)
                                    isLoading = false
                                }
                            }
                            .buttonStyle(PageButton(isSelected: curPage == page))
                            
                        }
                        Spacer()
                        if curPage < (boardList.totalPages ?? 0) - 1 {
                            Button(">") {
                                curPage+=1
                                Task {
                                    isLoading = true
                                    print("boardview appeared?")
                                    //todo : 검색 기능 추가.
                                    await boardList = getBoardList(page: curPage)
                                    isLoading = false
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                    }
                    
                    HStack {
                        Text("현재 페이지 : \(curPage + 1)")
                        Spacer()
                            
                    }
                }
                .refreshable {
                    Task {
                        //isLoading = true
                        print("boardview appeared?")
                        // 리프레시는 그냥 하지 말까 너무 안이쁘다
                        await boardList = getBoardList(page: curPage)
                        //isLoading = false
                    }
                }
            }   // VStack
            if isLoading {
                LoadingView()
            }
            
            
        } // ZStack
        .task {
            isLoading = true
            print("boardview appeared?")
            //todo : 추후에는 이전에 검색했던 곳 기록남아있는걸로 재검색 하게 하자.
            searchText = ""
            selectionOption = .제목
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
