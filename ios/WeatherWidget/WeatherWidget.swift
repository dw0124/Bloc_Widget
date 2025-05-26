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
        WeatherEntry(date: Date(), weather: Weather.dummy)
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), weather: Weather.dummy)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WeatherEntry(date: entryDate, weather: Weather.dummy)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    let weather: Weather
}

struct WeatherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family // Widget 크기별 표시
    var entry: Provider.Entry

    var body: some View {
        switch self.family {
        case .systemSmall:
            WeatherWidgetSmall(weather: entry.weather)
        case .systemMedium:
            WeatherWidgetMedium(weather: entry.weather)
        case .systemLarge:
            WeatherWidgetLarge(weather: entry.weather)
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
    WeatherEntry(date: .now, weather: Weather.dummy)
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy)
}

#Preview(as: .systemSmall) {
    WeatherWidget()
} timeline: {
    WeatherEntry(date: .now, weather: Weather.dummy)
}
