//
//  ProfileView.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/15/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("Bo Zhong's Profile!")
            .onAppear {
                print("Connecting to Analytics.")
            }
    }
}

#Preview {
    ProfileView()
}
