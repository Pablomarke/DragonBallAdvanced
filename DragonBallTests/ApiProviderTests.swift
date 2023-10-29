//
//  ApiProviderTests.swift
//  DragonBallTests
//
//  Created by Pablo Márquez Marín on 29/10/23.
//

import XCTest
@testable import DragonBall

final class ApiProviderTests: XCTestCase {
    private var sut: ApiProviderProtocol!
    private var token: String = "miTokenAlAzar"

    override func setUp() {
        sut = MockApiService(secureDataProvider: SecureDataProvider())
    }

    func test_givenApiProvider_whenLoginWithUserAndPassword_thenGetValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")

            return true
        }

        let expectation = self.expectation(
            forNotification: NotificationCenter.apiLoginNotification,
            object: nil,
            handler: handler
        )

        sut.login(for: "pmarke@gmail.com", with: "keepcooding23")
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetAllHeroes_ThenHeroesExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        self.sut.getHeroes(by: nil, token: token) { heroes in
            XCTAssertNotEqual(heroes.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroExists() throws {
        let expectation = self.expectation(description: "Goku")
        
        let name = "Goku"
        self.sut.getHeroes(by: name, token: token) { heroes in
            XCTAssertEqual(heroes.count, 1)
            XCTAssertEqual(heroes.first?.name ?? "Goku", name)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroNotExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        let name = "Mi_tio"
        self.sut.getHeroes(by: name, token: token) { heroes in
            XCTAssertEqual(heroes.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenLocationsExists() throws {
        let expectation = self.expectation(description: "Fetch heroLocations data")
        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
        
        self.sut.getLocations(by: heroId, token: token) { heroLocations in
            XCTAssertEqual(heroLocations.count, 2)
            XCTAssertEqual(heroLocations.first?.latitude, "35.71867899343361")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenLocationsNotExists() throws {
        let expectation = self.expectation(description: "Fetch heroLocations data no exist")
        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE945689984"
        
        self.sut.getLocations(by: heroId, token: token) { heroLocations in
            
            XCTAssertEqual(heroLocations.count, 0)
            XCTAssertEqual(heroLocations.first?.latitude, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
