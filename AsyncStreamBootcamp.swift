//
//  AsyncStreamBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/5/24.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream(Int.self) { continuation in
            self.getData { value in
                continuation.yield(value)
            } onFinish: { error in
                if let error {
                    continuation.finish(throwing: error)
                } else {
                    continuation.finish()
                }
            }

        }
    }
    
    func getData(newValue: @escaping (_ value: Int) -> Void,
                 onFinish: @escaping (_ error: Error?) -> Void
    ) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item)) {
                newValue(item)
                print("New Data: \(item)")
                if item == items.last {
                    onFinish(nil)
                }
            }
        }
    }
    
}

@MainActor
final class AsyncStreamViewModel: ObservableObject {
    @Published private(set) var currentNumber = 0
    let manager = AsyncStreamDataManager()
    
    func onViewAppear() {
        let task = Task {
            do {
                for try await value in manager.getAsyncStream() {
                    self.currentNumber = value
                }
            } catch {
                print("Unable to fetch value: \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            task.cancel()
            print("Task cancelled!")
        })
    }
}

struct AsyncStreamBootcamp: View {
    @StateObject private var vm = AsyncStreamViewModel()
    var body: some View {
        VStack {
            Text("Number: \(vm.currentNumber)")
        }
        .onAppear(perform: {
            vm.onViewAppear()
        })
    }
}

#Preview {
    AsyncStreamBootcamp()
}
