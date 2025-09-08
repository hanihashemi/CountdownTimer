//
//  CountdownManager.swift
//  ChatPrototype
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import ActivityKit
import Foundation
import WidgetKit

@MainActor
final class CountdownManager {
    static let shared = CountdownManager()
    private var activity: Activity<CountdownAttributes>?

    func start(minutes: Int, title: String = "Countdown") async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            // Persist anyway so widget can show countdown
            persist(end: Date().addingTimeInterval(TimeInterval(minutes * 60)), startedAt: Date(), title: title)
            WidgetCenter.shared.reloadTimelines(ofKind: "CountdownWidget")
            return
        }
        guard activity == nil else { return } // only one

        let now = Date()
        let end = now.addingTimeInterval(TimeInterval(minutes * 60))
        let state = CountdownAttributes.ContentState(endDate: end, startedAt: now, title: title)

        do {
            // Persist for Widget access via App Group (even if Activity request fails)
            persist(end: end, startedAt: now, title: title)
            WidgetCenter.shared.reloadTimelines(ofKind: "CountdownWidget")

            activity = try Activity<CountdownAttributes>.request(
                attributes: CountdownAttributes(),
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            // TODO: Implement notification scheduling if needed
        } catch {
            print("Failed to start activity: \(error)")
        }
    }

    func cancel() async {
        if let act = activity {
            await act.end(nil, dismissalPolicy: .immediate)
            activity = nil
        }
        // Always clear shared state so widget updates even if no Activity was running
        if let defaults = UserDefaults(suiteName: Shared.appGroup) {
            defaults.removeObject(forKey: Shared.Keys.endDate)
            defaults.removeObject(forKey: Shared.Keys.startedAt)
            defaults.removeObject(forKey: Shared.Keys.title)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "CountdownWidget")
        // TODO: Implement notification cancellation if needed
    }

    private func persist(end: Date, startedAt: Date, title: String) {
        if let defaults = UserDefaults(suiteName: Shared.appGroup) {
            defaults.set(end.timeIntervalSince1970, forKey: Shared.Keys.endDate)
            defaults.set(startedAt.timeIntervalSince1970, forKey: Shared.Keys.startedAt)
            defaults.set(title, forKey: Shared.Keys.title)
        }
    }
}
