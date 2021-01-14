//
//  Repositories.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import Foundation

struct Repositories: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: ItemInfo
}
