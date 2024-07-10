//
//  SearchableBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/2/24.
//

import SwiftUI
import Combine


struct Resturant: Identifiable, Hashable {
    let id: String
    let title: String
    let cuisine: CuisineOption
}


enum CuisineOption: String {
    case american
    case italian
    case japanese
    case chinese
}

final class ResturantManager {
     
    func getAllResturants() async throws -> [Resturant] {
        [
            Resturant(id: "1", title: "Shake Shack", cuisine: .american),
            Resturant(id: "2", title: "Spaghetti Factory", cuisine: .italian),
            Resturant(id: "3", title: "Sushi Tomo", cuisine: .japanese),
            Resturant(id: "4", title: "Sichuan Hotpot", cuisine: .chinese),

        ]
    }
}

@MainActor
class SearchableViewModel: ObservableObject {
    @Published private(set) var allResutrants: [Resturant] = []
    @Published private(set) var filteredResturants: [Resturant] = []
    @Published var searchScope: SearchScopeOption = .all
    @Published var allSearchScopes: [SearchScopeOption] = []

    
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    let manager = ResturantManager()
    
    var isSeaching: Bool {
        !searchText.isEmpty
    }
    
    var showSearchSuggestions: Bool {
        searchText.count < 5
    }
    
    enum SearchScopeOption: Hashable {
        case all
        case cuisine(option: CuisineOption)
        
        var titile: String {
            switch self {
            case .all:
                return "All"
            case .cuisine(option: let option):
                return option.rawValue.lowercased()
            }
        }
    }
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest($searchScope)
            .debounce(for: 0.15, scheduler: DispatchQueue.main
                      , options: nil)
            .sink { [weak self] (searchText, searchScope) in
                self?.filterResturants(searchText: searchText, searchScope: searchScope)
            }
            .store(in: &cancellables)
    }
    
    private func filterResturants(searchText: String, searchScope: SearchScopeOption) {
        guard !searchText.isEmpty else {
            filteredResturants = []
            self.searchScope = .all
            return
        }
        
        //Filter on search scope
        var resturantsInScope = allResutrants
        
        switch searchScope {
        case .all:
            break
        case .cuisine(option: let option):
            resturantsInScope = resturantsInScope.filter { $0.cuisine == option }
        }

        
        let search = searchText.lowercased()
        filteredResturants = resturantsInScope.filter { resturant in
            let titleContainsSearch = resturant.title.lowercased().contains(search)
            let cuisineContainsSearch = resturant.cuisine.rawValue.lowercased().contains(search)
            return titleContainsSearch || cuisineContainsSearch
        }
    }
    
    func loadResturant() async {
        do {
            let results = try await manager.getAllResturants()
            self.allResutrants = results
            let uniqueCuisineOptions = Set(allResutrants.map { $0.cuisine })
            allSearchScopes = [.all] + uniqueCuisineOptions.map { option in
                SearchScopeOption.cuisine(option: option)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSearchSuggestions() -> [String] {
        guard showSearchSuggestions else { return [] }
        
        var suggestions: [String] = []
        
        let search = searchText.lowercased()
        
        if search.contains("sp") {
            suggestions.append("Spagehetti")
        }
        
        if search.contains("su") {
            suggestions.append("Sushi")
        }
        
        if search.contains("bu") {
            suggestions.append("Burger")
        }
        
        if search.contains("sp") {
            suggestions.append("Sichuan")
        }
        
        suggestions.append(CuisineOption.italian.rawValue.capitalized)
        suggestions.append(CuisineOption.american.rawValue.capitalized)
        suggestions.append(CuisineOption.japanese.rawValue.capitalized)
        suggestions.append(CuisineOption.chinese.rawValue.capitalized)
        
        return suggestions
        
    }
    
    func getResturantSuggestions() -> [Resturant] {
        guard showSearchSuggestions else { return [] }
        
        var suggestions: [Resturant] = []
        
        let search = searchText.lowercased()
        
        if search.contains("it") {
            suggestions.append(contentsOf: allResutrants.filter { $0.cuisine == .italian})
        }
        
        if search.contains("ch") {
            suggestions.append(contentsOf: allResutrants.filter { $0.cuisine == .chinese})
        }
        
        if search.contains("am") {
            suggestions.append(contentsOf: allResutrants.filter { $0.cuisine == .american})
        }
        
        if search.contains("jap") {
            suggestions.append(contentsOf: allResutrants.filter { $0.cuisine == .japanese})
        }
        
        
        return suggestions
        
    }
}

struct SearchableBootcamp: View {
    @StateObject private var vm = SearchableViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                VStack(spacing: 20){
                    ForEach(vm.isSeaching ? vm.filteredResturants : vm.allResutrants) {
                        resturant in
                        NavigationLink(value: resturant) {
                            resturantRow(resturant: resturant)
                        }
                    }
                }
                .padding()
                
                //            SearchChildView()
            })
            .searchable(text: $vm.searchText, placement: .automatic, prompt: "Search resturants...")
            .searchSuggestions({
                ForEach(vm.getSearchSuggestions(), id: \.self) { suggestion in
                    Text(suggestion)
                        .searchCompletion(suggestion)
                }
                ForEach(vm.getResturantSuggestions(), id: \.self) { suggestion in
                    resturantRow(resturant: suggestion)
                }
            })
            .navigationTitle("Resturant")
            .searchScopes($vm.searchScope, scopes: {
                ForEach(vm.allSearchScopes, id:\.self) { scope in
                    Text(scope.titile)
                        .tag(scope)
                }
            })
    
            
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await vm.loadResturant()
            }
            .navigationDestination(for: Resturant.self) { resturant in
                Text(resturant.title)
            }
        }
    }
    
    private func resturantRow(resturant: Resturant) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(resturant.title)
                .font(.headline)
                .foregroundStyle(.black)
            Text(resturant.cuisine.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.black.opacity(0.8))
        })
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.06))
    }
}

struct SearchChildView: View {
    @Environment(\.isSearching) var isSearching
    
    var body: some View {
        Text("Child View is searching: \(isSearching)")
    }
}

#Preview {
    NavigationStack {
        SearchableBootcamp()
    }
}
