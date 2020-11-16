//
//  Token.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/15/20.
//

import Foundation

struct Token: Codable {
    let accessToken, refreshToken, tokenType: String
    let expiresIn: Int
    let scope: String
    let refreshTokenExpiresIn: Int
    let date = Date()

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case refreshTokenExpiresIn = "refresh_token_expires_in"
    }
}

extension Token {
    var isValidAccessToken:Bool {
        return Date(timeInterval: TimeInterval(expiresIn), since: date) < Date()
    }
    var isTimeToRefreshToken:Bool {
        return Date(timeInterval: TimeInterval(refreshTokenExpiresIn + 604800), since: date) > Date()
    }
}
