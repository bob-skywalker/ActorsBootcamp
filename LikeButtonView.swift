//
//  LikeButtonView.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/10/24.
//

import SwiftUI

struct LikeButtonView: View {
    var body: some View {
        Text("Change Heart Icon!")
            .onAppear(perform: {
                print("You Tapped Me!")
                print("Second Message!")
            })
    }
}

#Preview {
    LikeButtonView()
}
