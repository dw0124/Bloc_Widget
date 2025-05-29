//
//  WeatherWidgetRectangular.swift
//  WeatherWidgetExtension
//
//  Created by 김두원 on 5/29/25.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetRectangular: View {
    
    let entry: WeatherEntry

    let weather: Weather
    let locationAddress: LocationAddress
    
    init(entry: WeatherEntry) {
        self.entry = entry
        self.weather = entry.weather
        self.locationAddress = entry.locationAddress
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(weather.current.weatherCondition.imageAsset())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                Text("\(weather.current.temperature)º")
                    .fontWeight(.semibold)
            }
            .frame(height: 18)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -4, trailing: 0))
            
            Text(weather.current.weatherCondition.label)
                .fontWeight(.semibold)
            
            Spacer(minLength: 1)
            
            Text("최고:\(weather.daily.first!.maxTemperature)º 최저:\(weather.daily.first!.minTemperature)º")
                .fontWeight(.regular)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview(as: .accessoryRectangular) {
    WeatherWidget()
} timeline: {
    WeatherEntry.dummy
}
