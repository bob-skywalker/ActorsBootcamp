//
//  SwiftUIButtonsView.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/11/24.
//

import SwiftUI

struct SwiftUIButtonsView: View {
    var body: some View {
        Button("Tap Me!") {
            print("I am tapped!")
        }
        .padding()
        .foregroundStyle(.white)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SwiftUIButtonsView()
}
