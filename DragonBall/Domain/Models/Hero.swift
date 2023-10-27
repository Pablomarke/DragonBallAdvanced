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

extension Hero {
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> HeroDAO? {
        let entityName = HeroDAO.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        let object = HeroDAO.init(entity: entityDescription, 
                                  insertInto: context)
        object.id = id
        object.name = name
        object.heroDescription = description
        object.photo = photo
        object.favorite = isFavorite ?? false
        object.locations = []
        return object
    }
}
