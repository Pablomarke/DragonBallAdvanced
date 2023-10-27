//
//  HeroDetailViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import Foundation

class HeroDetailViewModel: HeroesDetailViewControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProvider
    var viewState: ((HeroDetailViewState) -> Void)?
    private var hero: HeroDAO
    private var heroLocations: [LocationDAO] = []
    
    init(hero: HeroDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProvider
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider 
        self.hero = hero
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer {self.viewState?(.loading(false))}
            guard let token = self.secureDataProvider.get() else {
                return
            }
            
            self.apiProvider.getLocations(
                by: self.hero.id,
                token: token
            ) { [weak self] locations in
                 self?.coreDataProvider.createLocations(locations: locations)
                 self?.heroLocations = self?.coreDataProvider.loadLocations() ?? []
                
                self?.viewState?(.update(hero: self?.hero,
                                         locations: self?.heroLocations ?? []))
            }
        }
    }
}
