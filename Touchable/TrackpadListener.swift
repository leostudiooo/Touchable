//
//  TrackpadListener.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/21.
//

import AppKit

struct PressurePoint: Identifiable {
    let id: Int  // Using simple integer instead of UUID
    let pressure: Double
}

class TrackpadListener: ObservableObject {
    @Published var pointerPosition = CGPoint(x: 200, y: 150)
    @Published var trackpadPressure: Double = 0.0
    @Published var pressurePoints: [PressurePoint] = []
    private var currentIndex = 0
    
    let eventTypes: NSEvent.EventTypeMask = [.mouseMoved, .pressure]
    private var eventMonitor: Any?
    private var timer: Timer?
    
    init() {
        startListening()
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let newPoint = PressurePoint(id: self.currentIndex, pressure: self.trackpadPressure)
                self.pressurePoints.append(newPoint)
                self.currentIndex += 1
                if self.pressurePoints.count > 150 {
                    self.pressurePoints.removeFirst()
                }
            }
        }
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
