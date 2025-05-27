//
//  LocationAddress.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

struct LocationAddress {
    let area1: String     // 시
    let area2: String     // 구
    let area3: String     // 동
    let latitude: Double
    let longitude: Double
    
    static func fromEntity(entity: LocationAddressEntity, lat: Double, lng: Double) -> LocationAddress {
        let area1 = entity.results[0].region.area1.name
        let area2 = entity.results[0].region.area2.name
        let area3 = entity.results[0].region.area3.name
        let latitude = lat
        let longitude = lng
        
        return LocationAddress(
            area1: area1,
            area2: area2,
            area3: area3,
            latitude: latitude,
            longitude: longitude
        )
    }
}

struct LocationAddressEntity: Codable {
    let status: Status
    let results: [Result]

    struct Status: Codable {
        let code: Int
        let name: String
        let message: String
    }

    struct Result: Codable {
        let name: String
        let code: Code
        let region: Region
    }

    struct Code: Codable {
        let id: String
        let type: String
        let mappingId: String
    }

    struct Region: Codable {
        let area0: Area
        let area1: Area
        let area2: Area
        let area3: Area
        let area4: Area
    }

    struct Area: Codable {
        let name: String
        let coords: Coords
    }

    struct Coords: Codable {
        let center: Center
    }

    struct Center: Codable {
        let crs: String
        let x: Double
        let y: Double
    }
}
