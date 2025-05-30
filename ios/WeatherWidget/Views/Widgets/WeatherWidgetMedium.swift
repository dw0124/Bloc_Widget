//
//  WeatherWidgetMedium.swift
//  Runner
//
//  Created by 김두원 on 5/26/25.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetMedium: View {
    
    let weather: Weather
    let locationAddress: LocationAddress
    
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
                    Image(
                        weather.current.weatherCondition.imageAsset(
                            isNight: weather.current.isNight
                        )
                    )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text(weather.current.weatherCondition.label)
                        .font(Font.system(size: 14, weight: .semibold))
                    Text("최고:\(weather.daily.first!.maxTemperature)º 최저:\(weather.daily.first!.minTemperature)º")
                        .font(Font.system(size: 14, weight: .semibold))
                }
            }
            
            HStack {
                ForEach(weather.hourly.prefix(6), id: \.uuid) { weather in
                    HourlyWeatherItem(weather: weather)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy, locationAddress: LocationAddress.dummy)
}
