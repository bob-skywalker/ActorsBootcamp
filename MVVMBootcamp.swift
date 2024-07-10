//
//  MVVMBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/2/24.
//

import SwiftUI

final class MyManagerClass {
    func getData() async throws -> String {
        "Some Data!"
    }
}

final class MVVMBootcampViewModel: ObservableObject {
    let managerActor = MyManagerActor()
    let managerClass = MyManagerClass()
    
    private var tasks: [Task<(), Never>] = []
    @Published private(set) var myData: String = "Starting Data.."
    
    func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task1 = Task {
            do {
                myData = try await managerClass.getData()
            } catch {
                print(error.localizedDescription)
            }
        }
        tasks.append(task1)
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some Data!"
    }
}

struct MVVMBootcamp: View {
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        VStack{
            Button("Click me") {
                viewModel.onCallToActionButtonPressed()
            }
        }
    }
}

#Preview {
    MVVMBootcamp()
}
