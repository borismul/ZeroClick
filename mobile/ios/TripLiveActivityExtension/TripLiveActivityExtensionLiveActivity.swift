//
//  TripLiveActivityExtensionLiveActivity.swift
//  TripLiveActivityExtension
//
//  Created by Boris Mulder on 09/01/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TripLiveActivityExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TripLiveActivityExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripLiveActivityExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TripLiveActivityExtensionAttributes {
    fileprivate static var preview: TripLiveActivityExtensionAttributes {
        TripLiveActivityExtensionAttributes(name: "World")
    }
}

extension TripLiveActivityExtensionAttributes.ContentState {
    fileprivate static var smiley: TripLiveActivityExtensionAttributes.ContentState {
        TripLiveActivityExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TripLiveActivityExtensionAttributes.ContentState {
         TripLiveActivityExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TripLiveActivityExtensionAttributes.preview) {
   TripLiveActivityExtensionLiveActivity()
} contentStates: {
    TripLiveActivityExtensionAttributes.ContentState.smiley
    TripLiveActivityExtensionAttributes.ContentState.starEyes
}
