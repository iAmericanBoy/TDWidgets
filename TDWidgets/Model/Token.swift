//
//  Token.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//

import Foundation

typealias AccessToken = String
struct Token: Codable {
    var accessToken: AccessToken
    var refreshToken: String
    var tokenType: String
    var expiresIn: Int
    var scope: String
    var refreshTokenExpiresIn: Int
    var date: Date = Date()
}

extension Token {
    func isValidAccessToken(currentDate: Date = Date()) -> Bool {
        return Date(timeInterval: TimeInterval(expiresIn), since: date) < currentDate
    }
    func isTimeToRefreshToken(currentDate: Date = Date()) -> Bool {
        let experationDate = Date(timeInterval: TimeInterval(refreshTokenExpiresIn - 604800), since: date)
        return experationDate < currentDate
    }
}
