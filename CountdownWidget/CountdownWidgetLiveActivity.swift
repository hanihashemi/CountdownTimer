//
//  CountdownWidgetLiveActivity.swift
//  CountdownWidget
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountdownWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountdownAttributes.self) { context in
            let state = context.state
            VStack(alignment: .leading, spacing: 8) {
                Text(state.title)
                    .font(.headline)
                Text(state.endDate, style: .timer)
                    .font(.title).monospacedDigit()
                ProgressView(value: progress(start: state.startedAt, end: state.endDate))
            }
            .padding(.vertical, 4)
            .activityBackgroundTint(.secondary.opacity(0.2))
            .activitySystemActionForegroundColor(.accentColor)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.endDate, style: .timer)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.title)
                }
            } compactLeading: {
                Image(systemName: "timer")
            } compactTrailing: {
                Text(context.state.endDate, style: .timer)
                    .monospacedDigit()
            } minimal: {
                Text(context.state.endDate, style: .timer)
                    .monospacedDigit()
            }
            .keylineTint(.accentColor)
        }
    }
}


// Preview
extension CountdownAttributes {
    fileprivate static var preview: CountdownAttributes {
        CountdownAttributes()
    }
}

extension CountdownAttributes.ContentState {
    fileprivate static var sample: CountdownAttributes.ContentState {
        let now = Date()
        return .init(endDate: now.addingTimeInterval(300), startedAt: now, title: "Sample")
    }
}

#Preview("Notification", as: .content, using: CountdownAttributes.preview) {
   CountdownWidgetLiveActivity()
} contentStates: {
    CountdownAttributes.ContentState.sample
}

private func progress(start: Date, end: Date) -> Double {
    let total = end.timeIntervalSince(start)
    guard total > 0 else { return 1 }
    let elapsed = Date().timeIntervalSince(start)
    return max(0, min(1, elapsed / total))
}
