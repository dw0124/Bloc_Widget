//
//  WeatherService.swift
//  Runner
//
//  Created by 김두원 on 5/27/25.
//

import Foundation

class WeatherService {
    let reverseGeocodingAPIClient: ReverseGeocodingAPIClient
    let weatherAPIClient: WeatherAPIClient
    
    init(reverseGeocodingAPIClient: ReverseGeocodingAPIClient?, weatherAPIClient: WeatherAPIClient?) {
        self.reverseGeocodingAPIClient = reverseGeocodingAPIClient ?? ReverseGeocodingAPIClient()
        self.weatherAPIClient = weatherAPIClient ?? WeatherAPIClient()
    }
    
    func fetchWeather(lat: Double, lng: Double) async throws -> (Weather, LocationAddress) {
        var weather: Weather
        var locationAddress: LocationAddress
        
        let locationAddressData = try await reverseGeocodingAPIClient.fetchLocationAddressData(lat: lat, lng: lng)
        let locationAddressEntity = try JSONDecoder().decode(LocationAddressEntity.self, from: locationAddressData)
        locationAddress = LocationAddress.fromEntity(entity: locationAddressEntity, lat: lat, lng: lng)
        
        let weatherData = try await weatherAPIClient.fetchWeatherData(lat: lat, lng: lng)
        let weatherEntity = try JSONDecoder().decode(WeatherEntity.self, from: weatherData)
        weather = Weather.fromEntity(entity: weatherEntity)
        
        return (weather, locationAddress)
    }
}
