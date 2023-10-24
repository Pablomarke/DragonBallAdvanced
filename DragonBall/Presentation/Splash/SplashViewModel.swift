//
//  SplashViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 19/10/23.
//

import Foundation

class SplashViewModel: SplashViewControllerDelegate {
    private let secureDataProvider: SecureDataProviderProtocol
    private let apiProvider: ApiProviderProtocol
    private let coreDataProvider: CoreDataProvider
    
    var viewState: ((SplashViewState) -> Void)?
    
    lazy var loginViewModel: LoginViewControllerDelegate = {
            LoginViewModel(
                apiProvider: apiProvider,
                secureDataProvider: secureDataProvider,
                coreDataProvider: coreDataProvider
            )
        }()

        lazy var heroesViewModel: HeroesViewControllerDelegate = {
            HeroesViewModel(
                apiProvider: apiProvider,
                secureDataProvider: secureDataProvider,
                coreDataProvider: coreDataProvider
            )
        }()
    
    private var isLogged: Bool {
        secureDataProvider.get()?.isEmpty == false
    }
    
    init(secureDataProvider: SecureDataProviderProtocol, apiProvider: ApiProviderProtocol, coreDataProvider: CoreDataProvider) {
        self.secureDataProvider = secureDataProvider
        self.apiProvider = apiProvider
        self.coreDataProvider = coreDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)){
            self.isLogged ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
        }
    }
}


