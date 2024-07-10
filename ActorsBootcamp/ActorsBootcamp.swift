//  ActorsBootcamp.swift
//
//  ActorsBootcamp
//
//  Created by Bo Zhong on 6/30/24.
//

import SwiftUI

class MyDataManager {
    
    static let shared = MyDataManager()
    private init() {}
    
    var data: [String] = []
    let queue = DispatchQueue(label: "com.ActorsBottcamp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping(_ title: String?) -> Void ) {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
    
}


actor MyActorDataManager {
    
    static let shared = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getDummyData() -> String {
        return "Dummy Data"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.shared
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            }
            let dummy = manager.getDummyData()
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
    }
}

struct BrowseView: View {
    let manager = MyActorDataManager.shared
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.05, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home View", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
