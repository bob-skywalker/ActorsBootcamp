//
//  ProfileView.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/15/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var isPremium: Bool = true
    
    var body: some View {
        Text("Bo Zhong's Profile!")
            .onAppear {
                print("Found Bug, fixed it!")
            }
    }
}

#Preview {
    ProfileView()
}
