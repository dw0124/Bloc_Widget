//
//  WeatherCondition.swift
//  Runner
//
//  Created by 김두원 on 5/23/25.
//

import Foundation

enum WeatherCondition {
    case clear
    case clouds
    case rain
    case snow
    case thunderstorm
    case drizzle
    case atmosphere
    case unknown
}

extension WeatherCondition {
    static func fromWeatherCode(code: Int) -> WeatherCondition {
        switch code {
        case 200..<300: return .thunderstorm
        case 300..<400: return .drizzle
        case 500..<600: return .rain
        case 600..<700: return .snow
        case 700..<800: return .atmosphere
        case 800: return .clear
        case 801..<900: return .clouds
        default: return .unknown
        }
    }
    
    func toWeatherCode() -> Int {
        switch self {
        case .thunderstorm:
            return 200
        case .drizzle:
            return 300
        case .rain:
            return 500
        case .snow:
            return 600
        case .atmosphere:
            return 701
        case .clear:
            return 800
        case .clouds:
            return 801
        case .unknown:
            return 0
        }
    }
    
    /// 날씨 이미지 경로
    func imageAsset(isNight: Bool = false) -> String {
        if self == .clear && isNight {
            return "assets/weather_icon/moon.fill"
        } else if self == .clear && !isNight {
            return "assets/weather_icon/clear"
        }
        
        switch self {
        case .clouds:
            return "clouds"
        case .rain, .drizzle:
            return "rain"
        case .snow:
            return "snow"
        case .thunderstorm:
            return "thunderstorm"
        case .atmosphere:
            return "atmosphere"
        default:
            return "unknown"
        }
    }
    
    /// 날씨 텍스트
    var label: String {
        switch self {
        case .clear:
            return "맑음"
        case .clouds:
            return "흐림"
        case .rain:
            return "비"
        case .snow:
            return "눈"
        case .thunderstorm:
            return "천둥"
        case .drizzle:
            return "이슬비"
        case .atmosphere:
            return "안개"
        default:
            return "알 수 없음"
        }
    }
}
