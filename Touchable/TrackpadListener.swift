//
//  TrackpadListener.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/21.
//

import AppKit
import CoreGraphics

struct TrackpadDataPoint: Identifiable {
    let id: Int
    let pressure: Double
    let xDelta: Double
    let yDelta: Double
}

class TrackpadListener: ObservableObject {
    @Published var pointerPosition = CGPoint(x: 200, y: 150)
    @Published var trackpadPressure: Double = 0.0
    @Published var dataPoints: [TrackpadDataPoint] = []
    
    private var currentIndex = 0
    private var pressStartPosition: CGPoint?
    private var isPressed: Bool = false
    
    let eventTypes: NSEvent.EventTypeMask = [.mouseMoved, .pressure, .leftMouseDragged]
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
                if self.trackpadPressure > 0 {
                    if !self.isPressed {
                        self.isPressed = true
                        self.pressStartPosition = self.pointerPosition
                        self.dataPoints.removeAll()
                        self.currentIndex = 0
                        print("Started pressing at: \(self.pressStartPosition!)")
                    }
                    
                    let xDelta = self.pressStartPosition.map { self.pointerPosition.x - $0.x } ?? 0
                    let yDelta = self.pressStartPosition.map { -(self.pointerPosition.y - $0.y) } ?? 0  // Invert Y delta
                    
                    print("Current position: \(self.pointerPosition)")
                    print("Deltas - X: \(xDelta), Y: \(yDelta)")
                    
                    let newPoint = TrackpadDataPoint(
                        id: self.currentIndex,
                        pressure: self.trackpadPressure,
                        xDelta: Double(xDelta),
                        yDelta: Double(yDelta)
                    )
                    
                    self.dataPoints.append(newPoint)
                    self.currentIndex += 1
                    
                    if self.dataPoints.count > 200 {
                        self.dataPoints.removeFirst()
                    }
                } else if self.isPressed {
                    self.isPressed = false
                    print("Released pressure")
                }
            }
        }
    }
    
    private func startListening() {
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: eventTypes) {
            [weak self] event in
            self?.handleEvent(event)
            return event
        }
    }
    
    private func handleEvent(_ event: NSEvent) {
        if event.type == .pressure {
            trackpadPressure = Double(event.pressure)
        }
        pointerPosition = event.locationInWindow
    }
    
    deinit {
        timer?.invalidate()
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    public func getRadius() -> CGFloat {
        return 50.0 + 100.0 * CGFloat(trackpadPressure)
    }
}
