//
//  WeatherWidgetSmall.swift
//  Runner
//
//  Created by 김두원 on 5/26/25.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetSmall: View {
    
    let weather: Weather
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("서울특별시")
                    .font(.system(size: 20))
                
                Text("\(weather.current.temperature)º")
                    .font(.system(size: 40))
            }
            
            Spacer()
            
            
            VStack(alignment: .leading) {
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
        .padding(EdgeInsets(top: 0, leading: -24, bottom: 0, trailing: 0))
    }
}

#Preview(as: .systemSmall) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy)
}
