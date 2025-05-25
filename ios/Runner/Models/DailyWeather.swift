//
//  DailyWeather.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

struct DailyWeather {
    var epochTime: Date
    var formattedTime: String
    var weekdayString: String
    var sunrise: Date
    var sunset: Date
    var maxTemperature: Int
    var minTemperature: Int
    var weatherCondition: WeatherCondition
    var pop: Double
    
    static func fromEntity(entity: DailyWeatherEntity) -> DailyWeather {
        let timeInterval = TimeInterval(entity.dt)
        let epochTime = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ko_KR")
        dateFormatter1.dateFormat = "M/d"

        let dateFormatter2 = DateFormatter()
        dateFormatter2.locale = Locale(identifier: "ko_KR")
        dateFormatter2.dateFormat = "E"  // 요일(월, 화, 수..)

        let formattedTime = dateFormatter1.string(from: epochTime)
        let weekdayString = dateFormatter2.string(from: epochTime)
        
        let sunrise = Date(timeIntervalSince1970: TimeInterval(entity.sunrise))
        let sunset = Date(timeIntervalSince1970: TimeInterval(entity.sunset))
        
        let minTemperature = Int(entity.temp.min.rounded())
        let maxTemperature = Int(entity.temp.max.rounded())
        
        let weatherCode = entity.weather.first?.id ?? 0
        let weatherCondition = WeatherCondition.fromWeatherCode(code: weatherCode)
        
        let pop = entity.pop

        return DailyWeather(
            epochTime: epochTime,
            formattedTime: formattedTime,
            weekdayString: weekdayString,
            sunrise: sunrise,
            sunset: sunset,
            maxTemperature: maxTemperature,
            minTemperature: minTemperature,
            weatherCondition: weatherCondition,
            pop: pop
        )
    }
    
    static let dummy = DailyWeather.fromEntity(entity: DailyWeatherEntity.dummy)
}

struct DailyWeatherEntity: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let summary: String
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [WeatherInfoEntity]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }

    struct Temperature: Codable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    struct FeelsLike: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    static let dummy = DailyWeatherEntity(
        dt: 1747969200,
        sunrise: 1747945192,
        sunset: 1747996674,
        moonrise: 1747934940,
        moonset: 1747980480,
        moonPhase: 0.84,
        summary: "Expect a day of partly cloudy with rain",
        temp: DailyWeatherEntity.Temperature(
            day: 18.9,
            min: 16.81,
            max: 21.58,
            night: 17.2,
            eve: 20.34,
            morn: 16.86
        ),
        feelsLike: DailyWeatherEntity.FeelsLike(
            day: 18.26,
            night: 16.7,
            eve: 20.07,
            morn: 16.66
        ),
        pressure: 1011,
        humidity: 54,
        dewPoint: 10.42,
        windSpeed: 4.85,
        windDeg: 100,
        windGust: 7.69,
        weather: [
            WeatherInfoEntity(
                id: 500,
                main: "Rain",
                description: "실 비",
                icon: "10d"
            )
        ],
        clouds: 100,
        pop: 0.94,
        rain: 1.4,
        uvi: 6.86
    )
}
