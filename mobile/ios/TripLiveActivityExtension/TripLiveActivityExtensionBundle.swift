//
//  TripLiveActivityExtensionBundle.swift
//  TripLiveActivityExtension
//
//  Created by Boris Mulder on 09/01/2026.
//

import WidgetKit
import SwiftUI

@main
struct TripLiveActivityExtensionBundle: WidgetBundle {
    var body: some Widget {
        TripLiveActivityExtension()
        TripLiveActivityExtensionControl()
        TripLiveActivityExtensionLiveActivity()
    }
}
