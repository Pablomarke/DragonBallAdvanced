//
//  HeroDetailViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import Foundation
import MapKit

class HeroDetailViewModel: HeroesDetailViewControllerDelegate {
    private let coreDataProvider: CoreDataProvider
    var viewState: ((HeroDetailViewState) -> Void)?
    private var hero: HeroDAO
    private var heroLocations: [LocationDAO]
    private var heroAnnotation: [HeroAnnotation] = []

// MARK: - Initializers -
    init(hero: HeroDAO,
         heroLocations: [LocationDAO],
         coreDataProvider: CoreDataProvider
    ) {
        self.coreDataProvider = coreDataProvider 
        self.hero = hero
        self.heroLocations = heroLocations
    }
 
// MARK: - Public functions -
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.global().async {
            defer {self.viewState?(.loading(false))}
            self.loadLocations()
        }
    }
    
    func loadLocations() {
        self.heroLocations = self.coreDataProvider.loadLocations() 
        self.heroAnnotation = self.createAnnotations(locations: self.heroLocations)
        self.viewState?(.update(hero: self.hero,
                                locations: self.heroAnnotation ))
    }
    
    func createAnnotations(locations: [LocationDAO]) -> [HeroAnnotation] {
        var thisHeroAnnotations: [HeroAnnotation] =  []
        for location in locations {
            if location.hero?.id == hero.id {
                thisHeroAnnotations.append( HeroAnnotation(
                    title: hero.name,
                    info: hero.id,
                    coordinate: .init(
                        latitude: Double(location.latitude ?? "") ?? 0.0,
                        longitude: Double(location.longitude ?? "") ?? 0.0)))
            }
        }
        return thisHeroAnnotations
    }
}
