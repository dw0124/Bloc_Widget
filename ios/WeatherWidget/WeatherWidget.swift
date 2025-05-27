//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by 김두원 on 5/23/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), weather: Weather.dummy, locationAddress: LocationAddress.dummy)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), weather: Weather.dummy, locationAddress: LocationAddress.dummy)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let lng = 126.978388
        let lat = 37.56661
        
        Task {
            let (weather, locationAddress) = try await WeatherService.shared.fetchWeather(lat: lat, lng: lng)
            
            let entry = WeatherEntry(date: Date(), weather: weather, locationAddress: locationAddress)
            
            let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 30), to: Date())!
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    var weather: Weather
    var locationAddress: LocationAddress
}

struct WeatherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family // Widget 크기별 표시
    var entry: Provider.Entry

    var body: some View {
        switch self.family {
        case .systemSmall:
            WeatherWidgetSmall(weather: entry.weather, locationAddress: entry.locationAddress)
        case .systemMedium:
            WeatherWidgetMedium(weather: entry.weather, locationAddress: entry.locationAddress)
        case .systemLarge:
            WeatherWidgetLarge(weather: entry.weather, locationAddress: entry.locationAddress)
        default:
            Text("default")
        }
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WeatherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WeatherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemLarge) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy, locationAddress: LocationAddress.dummy)
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy, locationAddress: LocationAddress.dummy)
}

#Preview(as: .systemSmall) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy, locationAddress: LocationAddress.dummy)
}
