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
    
    init(hero: HeroDAO,
         heroLocations: [LocationDAO],
         coreDataProvider: CoreDataProvider
    ) {
        self.coreDataProvider = coreDataProvider 
        self.hero = hero
        self.heroLocations = heroLocations
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.global().async {
            defer {self.viewState?(.loading(false))}
            self.loadLocations()

        }
    }
    
    func loadLocations() {
        self.heroLocations = self.coreDataProvider.loadLocations() 
        self.viewState?(.update(hero: self.hero,
                                locations: self.heroLocations ))
    }
}
