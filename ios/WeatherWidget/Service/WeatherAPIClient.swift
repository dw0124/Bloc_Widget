//
//  WeatherAPIClient.swift
//  Runner
//
//  Created by 김두원 on 5/27/25.
//

import Foundation

enum WeatherAPIError: Error {
    case missingAPIKey
}

class WeatherAPIClient {
    func fetchWeatherData(lat: Double, lng: Double) async throws -> Data {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String else {
            NSLog("Runner - API 키를 불러오지 못했습니다.")
            throw WeatherAPIError.missingAPIKey
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/3.0/onecall"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lng)"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "kr"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components.url else {
            NSLog("Runner - URL failed")
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
