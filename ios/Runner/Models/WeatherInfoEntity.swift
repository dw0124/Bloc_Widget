//
//  WeatherEntity.swift
//  Runner
//
//  Created by 김두원 on 5/25/25.
//

import Foundation

struct WeatherInfoEntity: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
