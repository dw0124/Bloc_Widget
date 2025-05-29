//
//  WeatherWidgetRectangular.swift
//  WeatherWidgetExtension
//
//  Created by 김두원 on 5/29/25.
//

import WidgetKit
import SwiftUI

struct WeatherWidgetCircular: View {
    
    let entry: WeatherEntry
    let pop: Int
    
    init(entry: WeatherEntry) {
        self.entry = entry
        self.pop = entry.weather.daily.first?.pop ?? 0
    }

    var body: some View {
        ZStack(alignment: .center) {
            Gauge(value: Double(pop), in: 0...100) {
                
            } currentValueLabel: {
                Text(
                    Image(systemName: "umbrella.fill")
                )
            }
            .gaugeStyle(.accessoryCircular)
            
            VStack {
                Spacer()
                Text("\(pop)")
                    .font(.caption)
                    .padding(.bottom, -2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(as: .accessoryCircular) {
    WeatherWidget()
} timeline: {
    WeatherEntry.dummy
}
