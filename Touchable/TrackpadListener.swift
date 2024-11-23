//
//  TrackpadListener.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/21.
//

import AppKit
import CoreGraphics

class TrackpadListener: ObservableObject {
    @Published var pointerPosition = CGPoint(x: 200, y: 150)
    @Published var trackpadPressure: CGFloat = 0.0
    @Published var pressureValues: [CGFloat] = []
    
    let eventTypes: NSEvent.EventTypeMask = [.mouseMoved, .pressure]
    
    private var eventMonitor: Any?
    
    init() {
        startListening()
    }
    
    private func startListening() {
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: eventTypes) {
            [weak self] event in self?.handleEvent(event)
            return event
        }
    }
    
    private func handleEvent(_ event: NSEvent) {
        if event.type == .pressure {
            trackpadPressure = CGFloat(event.pressure)
        }
        pointerPosition = event.locationInWindow
        pressureValues.append(trackpadPressure)
        if pressureValues.count > 100 {
            pressureValues.removeFirst()
        }
    }
    
    deinit {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    public func getRadius() -> CGFloat {
        return 50.0 + 100.0 * trackpadPressure
    }
}
