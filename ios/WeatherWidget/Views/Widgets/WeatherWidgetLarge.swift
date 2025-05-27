//
//  WeatherWidgetLarge.swift
//  Runner
//
//  Created by 김두원 on 5/26/25.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetLarge: View {
    
    let weather: Weather
    let locationAddress: LocationAddress
    
    var weeklyHighTemp: Int {
        return weather.daily.map { $0.maxTemperature }.max() ?? 0
    }
    
    var weeklyLowTemp: Int {
        return weather.daily.map { $0.minTemperature }.min() ?? 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(locationAddress.area1) \(locationAddress.area3)")
                        .font(.system(size: 20))
                    
                    Text("\(weather.current.temperature)º")
                        .font(.system(size: 40))
                }
                
                Spacer()
                
                
                VStack(alignment: .trailing) {
                    Image(weather.current.weatherCondition.imageAsset())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text(weather.current.weatherCondition.label)
                        .font(Font.system(size: 14, weight: .semibold))
                    Text("최고:\(weather.daily.first!.maxTemperature)º 최저:\(weather.daily.first!.minTemperature)º")
                        .font(Font.system(size: 14, weight: .semibold))
                }
            }
            
            VStack {
                Divider()
                
                HStack {
                    ForEach(weather.hourly.prefix(6), id: \.uuid) { weather in
                        HourlyWeatherItem(weather: weather)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Divider()
            }
            
            ForEach(weather.daily.prefix(5), id: \.uuid) { weather in
                DailyWeatherItem(
                    weather: weather,
                    weeklyHighTemp: weeklyHighTemp,
                    weeklyLowTemp: weeklyLowTemp
                )
                .frame(maxWidth: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview(as: .systemLarge) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy, locationAddress: LocationAddress.dummy)
}
