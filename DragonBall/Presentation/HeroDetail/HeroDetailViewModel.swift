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
    
    var viewState: ((HeroDetailViewState) -> Void)?
    private var hero: Hero
    private var heroLocations: HeroLocations = []
    
    init(hero: Hero,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
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
            ) { [weak self] heroLocations in
                self?.heroLocations = heroLocations
                self?.viewState?(.update(hero: self?.hero,
                                         locations: heroLocations))
            }
        }
    }
}
