//
//  CountdownWidgetBundle.swift
//  CountdownWidget
//
//  Created by Hanialhassan Hashemifar on 29.08.25.
//

import WidgetKit
import SwiftUI

@main
struct CountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountdownWidget()
        CountdownWidgetControl()
        CountdownWidgetLiveActivity()
    }
}
