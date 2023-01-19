//
//  ToggleStyles.swift
//  KMScommunity
//
//  Created by 이민교 on 2023/01/19.
//

import Foundation
import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn
                        ? "checkmark.square.fill"
                        : "square")
                configuration.label
                    
            }
        }
        .tint(.primary)
        .buttonStyle(.borderless)
    }
}
