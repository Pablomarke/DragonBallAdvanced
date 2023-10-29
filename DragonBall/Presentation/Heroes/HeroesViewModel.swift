//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import CoreData
import UIKit

class HeroesViewModel: HeroesViewControllerDelegate {

// MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProvider
    
// MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    private var heroes: [HeroDAO] = []
    private var heroesLocations: [LocationDAO] = []
    
// MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, 
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProvider
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
// MARK: - Public functions -
    func onViewappear() {
        viewState?(.loading(true))
        DispatchQueue.main.async {
            defer { self.viewState?(.loading(false)) }
            self.coreDataProvider.countHeroes() == 0 ? self.callHeroes() : self.callLocalHeroes()
        }
    }

    func heroDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?  {
        guard let selectedHero = heroBy(index: index) else { return nil }
    
        return HeroDetailViewModel(
            hero: selectedHero, 
            heroLocations: heroesLocations,
            coreDataProvider: coreDataProvider
        )
    }
    
    func loginViewModel() -> LoginViewControllerDelegate? {
        return LoginViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider,
            coreDataProvider: coreDataProvider
        )
    }
    
    func mapHeroesViewModel() -> MapHeroesControllerDelegate? {
        return MapHeroesViewModel(
            heroes: self.heroes,
            mapHeroLocations: self.heroesLocations,
            coreDataProvider: coreDataProvider
        )
    }
    
    func callLocalHeroes() {
        self.coreDataProvider.deleteBug()
        self.heroes = self.coreDataProvider.loadHeroes()
        self.viewState?(.updateData)
    }
    
    func whereIsTheHeroes() {
        self.coreDataProvider.countLocations() == 0 ? self.callAndFindTheHeroes() : self.findTheHeroes()
    }
    
    func callHeroes() {
        guard let token = self.secureDataProvider.get() else { return }

        self.apiProvider.getHeroes(by: nil,
                                   token: token) { heroes in
            self.coreDataProvider.createHeroes(heroes: heroes)
            self.coreDataProvider.deleteBug()
            self.heroes = self.coreDataProvider.loadHeroes()
            self.viewState?(.updateData)
        }
    }
    
    func callAndFindTheHeroes() {
        DispatchQueue.main.async {
            guard let token = self.secureDataProvider.get() else { return }
            
            let myIds = self.coreDataProvider.getAllIds()
            for id in myIds {
                self.apiProvider.getLocations(by: id,
                                              token: token) { heroLocations in
                    self.coreDataProvider.createLocations(locations: heroLocations)
                }
            }
            self.heroesLocations = self.coreDataProvider.loadLocations()
        }
    }
    
    func findTheHeroes(){
        self.heroesLocations = self.coreDataProvider.loadLocations()
    }
    
    func heroBy(index: Int)  -> HeroDAO? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        } else {
            nil
        }
    }
    
    func logout() {
        secureDataProvider.delete()
    }
    
    func destroyData() {
        coreDataProvider.deleteHeroes()
        coreDataProvider.deleteLocations()
    }
    
    func searchHero(text: String) {
        let searchHero = self.coreDataProvider.getHerowithName(name: text) ?? []
        self.heroes = []
        self.heroes.append(contentsOf: searchHero)
    }
}
