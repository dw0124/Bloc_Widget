//
//  Weather.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

struct Weather {
    var current: CurrentWeather
    var hourly: [HourlyWeather]
    var daily: [DailyWeather]
    
    static func fromEntity(entity: WeatherEntity) -> Weather {
        
        let current = CurrentWeather.fromEntity(entity: entity.current)

        let dailyEntity = entity.daily
        let daily = entity.daily.map { entity in
            DailyWeather.fromEntity(entity: entity)
        }

        let hourlyEntity = entity.hourly
        let hourly = entity.hourly
            .prefix(24)
            .map { entity in
                let timeInterval = TimeInterval(entity.dt)
                let hourlyDt = Date(timeIntervalSince1970: timeInterval)

                let sunrise = daily[0].sunrise;
                let sunset = daily[0].sunset;
                let sunriseNext = daily[1].sunrise;
                let sunsetNext = daily[1].sunset;

                var isNight: Bool = false;

                if hourlyDt < sunrise {
                    isNight = true
                } else if hourlyDt >= sunrise && hourlyDt < sunset {
                    isNight = false
                } else if hourlyDt >= sunset && hourlyDt < sunriseNext {
                    isNight = true
                } else if hourlyDt >= sunriseNext && hourlyDt < sunsetNext {
                    isNight = false
                } else {
                    isNight = true
                }
                
                return HourlyWeather.fromEntity(entity: entity, isNight: isNight)
            }

        return Weather(
            current: current,
            hourly: hourly,
            daily: daily
        )
    }
}

struct WeatherEntity: Codable {
    var current: CurrentWeatherEntity
    var hourly: [HourlyWeatherEntity]
    var daily: [DailyWeatherEntity]
    
    enum CodingKeys: String, CodingKey {
        case current
        case hourly
        case daily
    }
    
    static let dummy = WeatherEntity(
        current: .dummy,
        hourly: Array(repeating: HourlyWeatherEntity.dummy, count: 12),
        daily: Array(repeating: DailyWeatherEntity.dummy, count: 7)
    )
}
