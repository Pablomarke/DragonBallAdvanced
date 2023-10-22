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
    private var moc: NSManagedObjectContext? {
        (
            CoreDataStack.shared.persistentContainer.viewContext
        )
    }
    
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
                self.viewState?(.updateData)
                
               // self.createHero()
              //  self.countHeroes()
                
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
    
    func createHero() {
        guard let moc,
                let entityHero = NSEntityDescription.entity(
                    forEntityName: HeroDAO.entityName,
                    in: moc
                ) else { return }
        for hero in heroes {
            let heroDAO = HeroDAO(entity: entityHero, insertInto: moc)
            heroDAO.setValue(hero.name, forKey:  "name")
            heroDAO.setValue(hero.description, forKey: "heroDescription")
            heroDAO.setValue(hero.photo, forKey: "photo" )
            try? moc.save()
        }
    }
    
    func countHeroes() {
        let fetchHero = NSFetchRequest<HeroDAO>(entityName: "HeroDAO")
        guard let moc,
        let myHeroes = try? moc.fetch(fetchHero)
        else {
            return
        }
        print("Heroes en base de datos: \(myHeroes.count )")
    }
    
    func heroDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?  {
        guard let selectedHero = heroBy(index: index) else { return nil }
    
        return HeroDetailViewModel(
            hero: selectedHero,
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }
    
    func logout() {
        secureDataProvider.delete()
    }
}
