//
//  CountdownWidgetLiveActivity.swift
//  CountdownWidget
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountdownWidgetAttributes: ActivityAttributes {
    // Dynamic state (now empty)
    public struct ContentState: Codable, Hashable { }

    // Fixed, non-changing attributes
    var name: String
}

struct CountdownWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountdownWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}


// Preview

extension CountdownWidgetAttributes {
    fileprivate static var preview: CountdownWidgetAttributes {
        CountdownWidgetAttributes(name: "World")
    }
}

extension CountdownWidgetAttributes.ContentState {
    // Empty preview state
    fileprivate static var empty: CountdownWidgetAttributes.ContentState {
        CountdownWidgetAttributes.ContentState()
    }
}

#Preview("Notification", as: .content, using: CountdownWidgetAttributes.preview) {
   CountdownWidgetLiveActivity()
} contentStates: {
    CountdownWidgetAttributes.ContentState.empty
}
