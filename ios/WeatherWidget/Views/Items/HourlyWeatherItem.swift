//
//  HourlyWeatherItem.swift
//  Runner
//
//  Created by 김두원 on 5/26/25.
//

import SwiftUI

struct HourlyWeatherItem: View {
    let weather: HourlyWeather

    var body: some View {
        VStack(spacing: 4) {
            // 시간 표시
            Text(weather.dateTimeString)
                .font(Font.system(size: 10, weight: .semibold))
                .foregroundStyle(Color.black.opacity(0.7))
            
            // 날씨 아이콘
            Image(
                weather.weatherCondition.imageAsset(
                    isNight: weather.isNight
                )
            )
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            // 온도 표시
            Text("\(weather.temperature)º")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    HourlyWeatherItem(weather: HourlyWeather.dummy)
}
