//
//  Hero.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 17/10/23.
//

import Foundation
import CoreData

typealias Heroes = [Hero]

struct Hero: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case isFavorite = "favorite"
    }
    
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    let isFavorite: Bool?
}
