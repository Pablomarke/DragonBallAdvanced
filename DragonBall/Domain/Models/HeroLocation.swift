//
//  HeroLocation.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import Foundation
import CoreData

typealias HeroLocations = [HeroLocation]

struct HeroLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case hero
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
    }
    
    let id, latitude, longitude, date: String?
    let hero: Hero?
}

