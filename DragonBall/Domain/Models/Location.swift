//
//  HeroLocation.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import Foundation
import CoreData
typealias Locations = [Location]

struct Location: Codable {
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

extension Location {
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> LocationDAO? {
        let entityName = LocationDAO.entityName
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        let object = LocationDAO.init(entity: entityDescription, insertInto: context)
        object.id = id
        object.latitude = latitude
        object.longitude = longitude
        object.date = date
        object.hero = hero?.toManagedObject(in: context)

        return object
    }
}
