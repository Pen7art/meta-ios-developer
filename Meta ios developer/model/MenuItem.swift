//
//  MenuItem.swift
//  Meta ios developer
//
//  Created by Cristian Duciuc on 28/03/23.
//

import Foundation

struct JSONMenu: Codable {
    let menu: [MenuItem]
}


struct MenuItem: Codable {
    let name: String
    let price: Float
    let description: String
    let image: String
}
