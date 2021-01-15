//
//  Item.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 15/01/2021.
//

import Foundation

struct Item: Codable {
    var name: String
    var stargazersCount: Int
    var owner: Owner
}
