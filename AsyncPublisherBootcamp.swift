//
//  AsyncPublisherBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/1/24.
//

import SwiftUI
import Combine

actor AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Pineapple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
        
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    var cancellables: Set<AnyCancellable> = []
    let manager = AsyncPublisherDataManager()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            
            await manager.$myData
                .receive(on: DispatchQueue.main, options: nil)
                .sink { [weak self] receivedItems in
                    self?.dataArray = receivedItems
                }
                .store(in: &cancellables)
        }
        //        manager.$myData
        //            .receive(on: DispatchQueue.main, options: nil)
        //            .sink { [weak self] receivedItems in
        //                self?.dataArray = receivedItems
        //            }
        //            .store(in: &cancellables)
        //        Task {
        //            for await val in manager.$myData.values {
        //                await MainActor.run {
        //                    self.dataArray = val
        //                }
        //            }
        //        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id:\.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
