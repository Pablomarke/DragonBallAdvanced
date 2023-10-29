//
//  MapHeroesViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 22/10/23.
//

import Foundation

class MapHeroesViewModel: MapHeroesControllerDelegate {
    
// MARK: - Dependencies -
    private let coreDataProvider: CoreDataProvider
    
// MARK: - Properties -
    var viewState: ((MapViewState) -> Void)?
    private var mapHeroLocations: [LocationDAO]
    private var heroes: [HeroDAO]
    private var mapAnnotations: [HeroAnnotation] = []
    
// MARK: - Init -
    init(heroes: [HeroDAO],
         mapHeroLocations: [LocationDAO] ,
         coreDataProvider: CoreDataProvider
    ) {
        self.coreDataProvider = coreDataProvider
        self.heroes = heroes
        self.mapHeroLocations = mapHeroLocations
    }
   
// MARK: - Public functions -
    func onViewappear() {
        viewState?(.loading(true))
        
        DispatchQueue.main.async {
            defer {self.viewState?(.loading(false))}
            self.mapHeroLocations = self.coreDataProvider.loadLocations()
            self.mapAnnotations = self.createAnnotations(locations: self.mapHeroLocations)
            self.viewState?(.updateMap(locations: self.mapAnnotations))
        }
    }
    
    func createAnnotations(locations: [LocationDAO]) -> [HeroAnnotation] {
        var allMapsAnnotations: [HeroAnnotation] =  []
        locations.forEach { allMapsAnnotations.append( HeroAnnotation(
            title: $0.hero?.name,
            info: $0.hero?.id,
            coordinate: .init(
                latitude: Double($0.latitude ?? "") ?? 0.0,
                longitude: Double($0.longitude ?? "") ?? 0.0)))
        }
        return allMapsAnnotations
    }
}
