//
//  ContentView.swift
//  ChatPrototype
//
//  Created by Hanialhassan Hashemifar on 28.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var minutes: Int = 25
    @State private var endDate: Date?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Countdown").font(.title).bold()
            
            Text("Minutes: \(minutes)")
            
            if let end = endDate {
                Text(end, style: .timer)
                    .font(.largeTitle).monospacedDigit()
                
                Button("Cancel", role: .destructive) {
                    Task {
                        await CountdownManager.shared.cancel()
                        endDate = nil
                    }
                }
            } else {
                Button("Start") {
                    Task {
                        await CountdownManager.shared.start(minutes: minutes)
                        endDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
                    }
                }
            }
        }
        .padding()
    }
}
