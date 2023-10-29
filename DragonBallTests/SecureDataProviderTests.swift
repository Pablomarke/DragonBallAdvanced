//
//  SecureDataProviderTests.swift
//  DragonBallTests
//
//  Created by Pablo Márquez Marín on 29/10/23.
//

import XCTest
@testable import DragonBall

final class SecureDataProvideTests: XCTestCase {
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    func test_givenSecureDataProvide_whenLoadToken_thenGetStoredToken() throws {
        let token = "miTokenAlAzar"
        sut.save(token: token)
        let tokenLoaded = sut.get()
        XCTAssertEqual(token, tokenLoaded)
    }
    
    func test_givenSecureDataProvide_whenTokenIsCleared_thenNoTokenIsStored() throws {
        sut.delete()
        let tokenLoaded = sut.get()
        XCTAssertEqual(nil, tokenLoaded)
        XCTAssertNil(tokenLoaded)
    }
    
}
