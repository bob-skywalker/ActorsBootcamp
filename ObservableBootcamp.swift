//
//  ObservableBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/5/24.
//

import SwiftUI


actor TitleDataBase {
    func getNewTitle() -> String {
        "Some New Title"
    }
}

@Observable
final class ObservableBootcampViewModel: ObservableObject {
    var title: String =  ""
    @ObservationIgnored let database = TitleDataBase()
    
    func updateTitle() async {
        DispatchQueue.main.async {
            Task {
                self.title = await self.database.getNewTitle()
                print(Thread.current)
            }
        }
    }
}

struct ObservableBootcamp: View {
    @State private var vm = ObservableBootcampViewModel()
    
    var body: some View {
        Text(vm.title)
            .task {
                await vm.updateTitle()
            }
    }
}

#Preview {
    ObservableBootcamp()
}
