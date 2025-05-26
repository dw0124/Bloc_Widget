//
//  DailyWeatherItem.swift
//  Runner
//
//  Created by 김두원 on 5/26/25.
//

import SwiftUI

struct DailyWeatherItem: View {
    let weather: DailyWeather
    let weeklyHighTemp: Int
    let weeklyLowTemp: Int
    
    let tempBarWidth: CGFloat = 150
    
    var offsetX: CGFloat {
        let tempRatio = Double(weather.minTemperature - weeklyLowTemp) / Double(weather.maxTemperature - weeklyLowTemp)
        
        let maxOffset: CGFloat = tempBarWidth
        return tempRatio * maxOffset
    }
    
    var tempWidth: CGFloat {
        let sub: Double = Double(weather.maxTemperature - weather.minTemperature)
        return (sub / Double((weeklyHighTemp - weeklyLowTemp))) * tempBarWidth
    }
    
    var body: some View {
        HStack {
            Text(weather.weekdayString)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
            
            Spacer(minLength: 16)
            
            // 날씨 아이콘
            Image(weather.weatherCondition.imageAsset())
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Spacer(minLength: 16)
            
            Text("\(weather.minTemperature)º")
                .font(.system(size: 14))
                .foregroundStyle(.black)
            
            Spacer()
            
            ZStack(alignment: .leading) {
                Capsule()
                    .opacity(0.1)
                
                let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
                Capsule()
                    .fill(Color(color))
                    .frame(width: tempWidth, height: 5)
                    .offset(x: offsetX)
            }
            .frame(width: tempBarWidth, height: 5)
            
            Spacer()
            
            Text("\(weather.maxTemperature)º")
                .font(.system(size: 14))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    DailyWeatherItem(
        weather: DailyWeather.dummy,
        weeklyHighTemp: 30,
        weeklyLowTemp: 10
    )
}
