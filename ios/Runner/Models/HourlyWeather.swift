//
//  HourlyWeather.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

struct HourlyWeather {
    var epochTime: Date
    var isNight: Bool
    var dateTimeString: String
    var temperature: Int
    var weatherCondition: WeatherCondition
    var pop: Int
    
    static func fromEntity(entity: HourlyWeatherEntity, isNight: Bool) -> HourlyWeather {
        let timeInterval = TimeInterval(entity.dt)
        let epochTime = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h시"
        let dateTimeString = dateFormatter.string(from: epochTime)
        
        let temperature = Int(entity.temp.rounded())
        
        let weatherCode = entity.weather.first?.id ?? 0
        let weatherCondition = WeatherCondition.fromWeatherCode(code: weatherCode)
        
        let pop = Int(entity.pop * 100)

        return HourlyWeather(
            epochTime: epochTime,
            isNight: isNight,
            dateTimeString: dateTimeString,
            temperature: temperature,
            weatherCondition: weatherCondition,
            pop: pop
        )
    }
    
    static let dummy = HourlyWeather.fromEntity(entity: HourlyWeatherEntity.dummy, isNight: true)
}

struct HourlyWeatherEntity: Codable {
    let dt: Int
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
    let windGust: Double
    let weather: [WeatherInfoEntity]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds
        case visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather
        case pop
    }
    
    static let dummy = HourlyWeatherEntity(
        dt: 1747994400,
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
            WeatherInfoEntity(
                id: 804,
                main: "Clouds",
                description: "온흐림",
                icon: "04d"
            )
        ],
        pop: 0
    )
}
