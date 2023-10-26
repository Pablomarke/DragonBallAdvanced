//
//  MapHeroesViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 22/10/23.
//

import Foundation

class MapHeroesViewModel: MapHeroesControllerDelegate {
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProvider
    
    var viewState: ((MapViewState) -> Void)?
    private var mapHeroLocations: HeroLocations = []
    
    init(coreDataProvider: CoreDataProvider,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
    func onViewappear() {
        viewState?(.loading(true))
        
        //estaba en global()
        DispatchQueue.main.async {
            defer {self.viewState?(.loading(false))}
            
            // TODO: volcar las localizaciones de heroe
            guard let token = self.secureDataProvider.get() else { return }
            let myIds = self.coreDataProvider.getAllIds()
            for id in myIds {
                self.apiProvider.getLocations(by: id, 
                                              token: token) { heroLocations in
                    self.coreDataProvider.createLocations(locations: heroLocations)
                }
            }
            self.mapHeroLocations = self.coreDataProvider.loadLocations()
            print(self.mapHeroLocations.count)
            self.viewState?(.updateMap(locations: self.mapHeroLocations))
        }
    }
}
