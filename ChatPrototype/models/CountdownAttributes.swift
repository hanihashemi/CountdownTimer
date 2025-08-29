//
//  CountdownAttributes.swift
//  ChatPrototype
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//
import ActivityKit
import Foundation

public struct CountdownAttributes: ActivityAttributes {
    public init() {}
    
    public struct ContentState: Codable, Hashable {
        public var endDate: Date
        public var startedAt: Date
        public var title: String
        
        public init(endDate: Date, startedAt: Date, title: String) {
            self.endDate = endDate
            self.startedAt = startedAt
            self.title = title
        }
    }
}
