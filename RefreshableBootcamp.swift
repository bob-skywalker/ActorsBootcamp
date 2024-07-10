//
//  RefreshableBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/2/24.
//

import SwiftUI

final class RefreshableDataService {
    func getData() async throws -> [String]  {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}

@MainActor
final class RefreshableBootcampViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print(error)
        }
    }
}

struct RefreshableBootcamp: View {
    @StateObject private var vm = RefreshableBootcampViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.items, id:\.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Refreshable")
        }
        .onAppear(perform: {
            Task {
                await vm.loadData()
            }
        })
        .refreshable {
            await vm.loadData()
            
        }
    }
}

#Preview {
    RefreshableBootcamp()
}
