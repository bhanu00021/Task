//
//  Post.swift
//  Post
//
//  Created by Bhanu on 28/05/24.
//

import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
