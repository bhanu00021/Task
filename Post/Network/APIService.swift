//
//  NetworkService.swift
//  Post
//
//  Created by Bhanu on 28/05/24.
//

import Foundation

class APIService {
    func fetchData<T: Decodable>(url: String, page: Int, completion: @escaping (Result<[T], Error>) -> Void) {
        let fullURL = URL(string: "\(url)?_page=\(page)&_limit=10")!
      
        URLSession.shared.dataTask(with: fullURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "dataTaskError", code: -1001, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let items = try JSONDecoder().decode([T].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
