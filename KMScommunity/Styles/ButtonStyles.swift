//
//  ButtonStyles.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/02/12.
//

import Foundation
import SwiftUI

struct PageButton: ButtonStyle {
    var isSelected : Bool
    func makeBody(configuration: Configuration) -> some View {
        if isSelected {
            // blue button
            configuration.label
                .padding()
                //.background(Color(red: 0, green: 0, blue: 0.5))
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Rectangle())
                .cornerRadius(5)
        } else {
            // white button
            configuration.label
                .padding()
                .background(Color.white)
                .foregroundColor(.blue)
                .clipShape(Rectangle())
                .border(.black)
                .cornerRadius(5)
        }
        
    }
}


