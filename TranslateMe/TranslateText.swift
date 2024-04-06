//
//  TranslateText.swift
//  TranslateMe
//
//  Created by Fredy Camas on 4/5/24.
//

import Foundation

struct ResponseData: Decodable {
        let matches: [Match]?
    }

struct Match: Decodable {
        let translation: String
    }
