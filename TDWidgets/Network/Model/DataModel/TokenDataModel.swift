//
//  TokenDataModel.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/28/20.
//

import Foundation

struct TokenDataModel: Codable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let refreshTokenExpiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case refreshTokenExpiresIn = "refresh_token_expires_in"
    }
}
