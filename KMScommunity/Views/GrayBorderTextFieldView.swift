//
//  GrayBorderTextFieldView.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/17.
//

import SwiftUI

struct GrayBorderTextFieldView: View {
    @Binding var string : String
    
    var header : String
    var placeholder : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .foregroundColor(Color.gray)
                .font(.caption2)
                .padding([.top, .leading], 8.0)
            TextField(placeholder, text: $string)
                .padding([.leading, .bottom], 8.0)
                .font(.title2)
                
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hue: 1.0, saturation: 0.031, brightness: 0.896), lineWidth: 3)
        )
    }
}

struct GrayBorderTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        GrayBorderTextFieldView(string: .constant("test"), header: "UserID", placeholder: "Type Id Here")
    }
}
