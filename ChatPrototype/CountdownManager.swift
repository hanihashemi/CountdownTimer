//
//  CountdownManager.swift
//  ChatPrototype
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import ActivityKit
import Foundation

@MainActor
final class CountdownManager {
    static let shared = CountdownManager()
    private var activity: Activity<CountdownAttributes>?

    func start(minutes: Int, title: String = "Countdown") async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        guard activity == nil else { return } // only one

        let now = Date()
        let end = now.addingTimeInterval(TimeInterval(minutes * 60))
        let state = CountdownAttributes.ContentState(endDate: end, startedAt: now, title: title)

        do {
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
        guard let act = activity else { return }
        await act.end(nil, dismissalPolicy: .immediate)
        activity = nil
        // TODO: Implement notification cancellation if needed
    }
}
