//
//  CurrentWeather.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

struct CurrentWeather {
    var epochTime: Date
    var isNight: Bool
    var temperature: Int
    var weatherCondition: WeatherCondition
    
    static func fromEntity(entity: CurrentWeatherEntity) -> CurrentWeather {
        let timeInterval = TimeInterval(entity.dt)
        let epochTime = Date(timeIntervalSince1970: timeInterval)
        
        let sunrise = Date(timeIntervalSince1970: TimeInterval(entity.sunrise))
        let sunset = Date(timeIntervalSince1970: TimeInterval(entity.sunset))
        let isNight = (epochTime < sunrise || epochTime > sunset)
        
        let temperature = Int(entity.temp.rounded())
        
        let weatherCode = entity.weather.first?.id ?? 0
        let weatherCondition = WeatherCondition.fromWeatherCode(code: weatherCode)

        return CurrentWeather(
            epochTime: epochTime,
            isNight: isNight,
            temperature: temperature,
            weatherCondition: weatherCondition
        )
    }
    
    static let dummy = CurrentWeather.fromEntitiy(entity: CurrentWeatherEntity.dummy)
}

struct CurrentWeatherEntity: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [WeatherEntity]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather
    }
    
    static let dummy = CurrentWeatherEntity(
        dt: 1747996052,
        sunrise: 1747945192,
        sunset: 1747996674,
        temp: 20.13,
        feelsLike: 19.92,
        pressure: 1010,
        humidity: 66,
        dewPoint: 13.58,
        uvi: 0.07,
        clouds: 99,
        visibility: 10000,
        windSpeed: 1.51,
        windDeg: 280,
        windGust: 1.56,
        weather: [
            WeatherEntity(
                id: 804,
                main: "Clouds",
                description: "온흐림",
                icon: "04d"
            )
        ]
    )

}

struct WeatherEntity: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
