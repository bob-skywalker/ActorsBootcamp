//
//  FetchAPI.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/10/24.
//

struct Beer: Codable, Identifiable {
    let title: String
    let description: String
    let ingredients: [String]
    let image: String
    let id: Int
}

import Foundation

func fetchBeer() {
    guard let url = URL(string: "https://api.sampleapis.com/coffee/hot") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode([Beer].self, from: data)
            print(decodedData)
        } catch {
            fatalError()
        }
    }
    
    task.resume()
}



