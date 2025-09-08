//
//  CountdownWidget.swift
//  CountdownWidget
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import WidgetKit
import SwiftUI
import Foundation

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: .now, title: "Countdown", endDate: .now.addingTimeInterval(300))
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(loadShared())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = loadShared()
        if let end = entry.endDate {
            completion(Timeline(entries: [entry], policy: .after(end)))
        } else {
            completion(Timeline(entries: [entry], policy: .atEnd))
        }
    }

    private func loadShared() -> Entry {
        let defaults = UserDefaults(suiteName: Shared.appGroup)
        let title = defaults?.string(forKey: Shared.Keys.title) ?? "No Active Countdown"
        if let ts = defaults?.double(forKey: Shared.Keys.endDate), ts > 0 {
            let end = Date(timeIntervalSince1970: ts)
            return Entry(date: .now, title: title, endDate: end)
        }
        return Entry(date: .now, title: title, endDate: nil)
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let title: String
    let endDate: Date?
}

struct CountdownWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.caption).foregroundStyle(.secondary)
            if let end = entry.endDate {
                Text(end, style: .timer)
                    .font(.title2).monospacedDigit()
            } else {
                Text("—")
                    .font(.title2).monospacedDigit()
            }
        }
        .padding(.vertical, 2)
    }
}

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    CountdownWidget()
} timeline: {
    Entry(date: .now, title: "Preview", endDate: .now.addingTimeInterval(300))
    Entry(date: .now, title: "No Active Countdown", endDate: nil)
}
