//
//  SendableBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/1/24.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    let name: String
}


final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    //creating a serial queue
    let queue = DispatchQueue(label: "com.MyApp.ActorsBootcamp")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    let manager: CurrentUserManager
    
    init(manager: CurrentUserManager) {
        self.manager = manager
    }
    
    func updateCurrentUserInfo() async {
        let info = MyClassUserInfo(name: "User Info")
        
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    @StateObject private var viewModel = SendableBootcampViewModel(manager: CurrentUserManager())
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SendableBootcamp()
}
