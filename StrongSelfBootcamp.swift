//
//  StrongSelfBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/2/24.
//

import SwiftUI

final class StrongSelfService {
    func getData() async -> String {
        "Updated Data"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
    @Published var data: String = "Some Title!"
    let manager = StrongSelfService()
    
    private var someTask: Task<(), Never>? = nil
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
    }
    
    // This implies a strong reference
    func updateData() {
        Task {
            self.data = await manager.getData()
        }
    }
    
    // This implies a strong reference
    func updateData2() {
        Task {
            self.data = await manager.getData()
        }
    }
    
    // This implies a strong reference
    func updateData3() {
        Task { [self] in
            self.data = await manager.getData()
        }
    }
    
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.manager.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong
    func updateData5() {
        someTask = Task {
            self.data = await manager.getData()
        }
    }
}

struct StrongSelfBootcamp: View {
    @StateObject private var vm = StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(vm.data)
            .onAppear(perform: {
                vm.updateData5()
            })
            .onDisappear(perform: {
                vm.cancelTasks()
            })
    }
}

#Preview {
    StrongSelfBootcamp()
}
