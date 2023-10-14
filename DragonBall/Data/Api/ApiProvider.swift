//
//  ApiProvider.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 14/10/23.
//

import Foundation

extension NotificationCenter {
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = Notification.Name("KEY_TOKEN")
}

protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
}

class ApiProvider: ApiProviderProtocol {
    
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    private enum Endpoint {
        static let login = "/auth/login"
    }
    
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            return
        }
        guard let loginData = String(format: "%@:%@",
                                     user, password).data(using: .utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error  == nil else {
                //TODO: Enviar notification indicando el error
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: enviar notificación indicando respose error
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
                // TODO: Enviar notificación indicando response vacío
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey : responseData]
            )
        }.resume()
    }
}
