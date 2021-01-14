//
//  License.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import Foundation

struct License: Decodable {
    let key: String
    let name: String
    let spdxId: String
    let url: String
    let nodeId: String
}
