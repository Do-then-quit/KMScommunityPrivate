//
//  SwiftUIView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/12.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
