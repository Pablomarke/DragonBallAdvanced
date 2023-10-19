//
//  HeroesViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 16/10/23.
//

import Foundation
import CoreData

class HeroesViewModel: HeroesViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroesCount: Int {
        heroes.count
    }
    private var heroes: Heroes = []
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol, 
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Public functions -
    func onViewappear() {
        viewState?(.loading(true))

        DispatchQueue.global().async {
            defer { self.viewState?(.loading(false)) }
            guard let token = self.secureDataProvider.get() else { return }

            self.apiProvider.getHeroes(by: nil,
                                       token: token) { heroes in
                self.heroes = heroes
               
                //TODO : coredata heroes
                let moc = CoreDataStack.shared.persistentContainer.viewContext
                let entityHero = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
                //var heroDAO = HeroDAO(entity: entityHero, insertInto: moc)
                
               // moc.save()
                self.viewState?(.updateData)
            }
        }
    }
    
    func heroBy(index: Int)  -> Hero? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        } else {
            nil
        }
    }
}
