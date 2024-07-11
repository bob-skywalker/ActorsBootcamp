//
//  LikeButtonView.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/10/24.
//

import SwiftUI

struct LikeButtonView: View {
    var body: some View {
        VStack{
            Text("Hello, Bro!")
        }
            .onAppear(perform: {
                print("You Tapped Me!")
            })
    }
}

#Preview {
    LikeButtonView()
}
