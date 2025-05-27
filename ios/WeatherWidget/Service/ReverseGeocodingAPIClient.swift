//
//  ReverseGeocodingAPIClient.swift
//  Runner
//
//  Created by 김두원 on 5/27/25.
//

import Foundation

enum ReverseGeocodingAPIError: Error {
    case missingAPIKey
}

class ReverseGeocodingAPIClient {
    func fetchLocationAddressData(lat: Double, lng: Double) async throws -> Data {
        
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String,
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String else {
            NSLog("Runner - API 키를 불러오지 못했습니다.")
            throw ReverseGeocodingAPIError.missingAPIKey
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "maps.apigw.ntruss.com"
        components.path = "/map-reversegeocode/v2/gc"
        components.queryItems = [
            URLQueryItem(name: "request", value: "coordsToaddr"),
            URLQueryItem(name: "coords", value: "\(lng),\(lat)"),
            URLQueryItem(name: "orders", value: "admcode"),
            URLQueryItem(name: "output", value: "json")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(clientID, forHTTPHeaderField: "x-ncp-apigw-api-key-id")
        request.setValue(clientSecret, forHTTPHeaderField: "x-ncp-apigw-api-key")
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
