//
//  GlobalActorBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 6/30/24.
//

import SwiftUI

@globalActor 
final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four"]
    }
}

class GlobalActorBootcampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager: MyNewDataManager
    
    init(manager: MyNewDataManager) {
        self.manager = manager
    }
    
    @MyFirstGlobalActor 
    func getData() {
        Task {
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
            
        }
    }
}

struct GlobalActorBootcamp: View {
    @StateObject private var viewModel = GlobalActorBootcampViewModel(manager: MyFirstGlobalActor.shared)
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) { datum in
                    Text(datum)
                        .font(.headline)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getData()
            }
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
