//
//  LocationDAO.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 23/10/23.
//

import Foundation
import CoreData

@objc(LocationDAO)
class LocationDAO: NSManagedObject {
    static let entityName = "LocationDAO"
    
    @NSManaged var id: String?
    @NSManaged var date: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var hero: HeroDAO?
}


