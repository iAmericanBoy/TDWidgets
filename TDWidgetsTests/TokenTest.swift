//
//  TokenTest.swift
//  TDWidgetsTests
//
//  Created by Dominic Lanzillotta on 11/16/20.
//

@testable import TDWidgets
import XCTest

class TokenTest: XCTestCase {
    func test_Valid_Access_Token() throws {
        let token = Token(accessToken: "1234567", refreshToken: "wertyui", tokenType: "refresh", expiresIn: 1000, scope: "all", refreshTokenExpiresIn: 1000000)
        
        XCTAssertTrue(token.isValidAccessToken(currentDate: Date(timeIntervalSinceNow: 500)))
    }
    
    func test_In_Valid_Valid_Access_Token() throws {
        let token = Token(accessToken: "1234567", refreshToken: "wertyui", tokenType: "refresh", expiresIn: 1000, scope: "all", refreshTokenExpiresIn: 1000000)
        
        XCTAssertFalse(token.isValidAccessToken(currentDate: Date(timeIntervalSinceNow: 5000)))
    }
    
    func test_is_Refresh_Token_Time_To_Refresh() {
        let token = Token(accessToken: "Hello", refreshToken: "World", tokenType: "refresh", expiresIn: 1000, scope: "all", refreshTokenExpiresIn: 60000)
        
        XCTAssertTrue(token.isTimeToRefreshToken(currentDate: Date(timeIntervalSinceNow: 5000)))
    }
    
    func test_is_Refresh_Token_not_Time_To_Refresh() {
        let token = Token(accessToken: "Hello", refreshToken: "World", tokenType: "refresh", expiresIn: 1000, scope: "all", refreshTokenExpiresIn: 100000000)
        
        XCTAssertFalse(token.isTimeToRefreshToken(currentDate: Date(timeIntervalSinceNow: 604800)))
    }
}
