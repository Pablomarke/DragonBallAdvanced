//
//  LoginViewModel.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 11/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider
        )
    }
    
    // MARK: - Init -
    init(
        apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProviderProtocol
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        
        //Esto se hace así para usarlo de ejemplo de observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public functions -
    func onloginPressed(email: String?, password: String?) {
        viewState?(.loading(true))
        
        DispatchQueue.global().async { 
            guard self.isValid(email: email) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorEmail("Indique un email valido"))
                return
            }
            
            guard self.isValid(password: password) else {
                self.viewState?(.loading(false))
                self.viewState?(.showErrorPassword("Indique un password valido"))
                return
            }
            
            self.doLoginWith(
                email: email ?? "",
                password: password ?? ""
            )
        }
    }
    
    @objc func onLoginResponse (_ notification: Notification) {
        defer { viewState?(.loading(false)) }
        
        //parsear resultado que vendrá en notification.userInfo
        guard let token = notification.userInfo?[NotificationCenter.tokenKey] as? String,
        !token.isEmpty else {
            return
        }
        
        secureDataProvider.save(token: token)
        viewState?(.navigateToNext)
    }
    
    private func isValid(email: String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }
    
    private func isValid(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
    private func doLoginWith(email: String, password: String) {
        apiProvider.login(for: email,
                          with: password)
    }
}
