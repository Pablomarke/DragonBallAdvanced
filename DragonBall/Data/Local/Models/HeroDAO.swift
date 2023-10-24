//
//  HeroDAO.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 17/10/23.
//

import Foundation
import CoreData

@objc(HeroDAO)
class HeroDAO: NSManagedObject {
    static let entityName = "HeroDAO"
    
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
}

extension HeroDAO: HeroAndLocationConvertible {
    func toModel() -> Hero? {
        return Hero(
            id: id,
            name: name,
            description: heroDescription,
            photo: photo,
            isFavorite: favorite
        )
    }
    
    typealias Model = Hero
    
    
    
}
