//
//  APIServices.swift
//  Post
//
//  Created by Bhanu on 28/05/24.
//

import Foundation



class PostsViewModel {
    private let apiService: APIService
    private(set) var posts: [Post] = []
    var didUpdatePosts: (() -> Void)?
    private var currentPage = 1
    private var isLoading = false
    
    //MARK: Flag to track if there's more data to fetch
    private var hasMoreData = true
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func fetchPosts() {
        //MARK: Check if not already loading and there's more data
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        
        apiService.fetchData(url: API.post, page: currentPage) { [weak self] (result: Result<[Post], Error>) in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let posts):
                self.posts.append(contentsOf: posts)
                self.currentPage += 1
                //MARK: Update hasMoreData flag based on whether new data was received
                self.hasMoreData = !posts.isEmpty
                self.didUpdatePosts?()
            case .failure(let error):
                print("Failed to fetch posts: \(error)")
            }
        }
    }
    
    //MARK: Add a method to check if there are more elements to fetch
     func hasMorePosts() -> Bool {
         return hasMoreData
     }
     
}


