//
//  Commit.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 21/01/2021.
//

import Foundation

struct Commit: Codable {
    var message: String
    var author: Author
}
