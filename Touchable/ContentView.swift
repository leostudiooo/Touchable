//
//  ContentView.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var trackpadListener = TrackpadListener() // 监听逻辑
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: trackpadListener.getRadius())
                    .position(
                        CGPoint(x: trackpadListener.pointerPosition.x, y: geo.size.height - trackpadListener.pointerPosition.y)
                    )
                    .opacity(0.5)
                HStack {
                    VStack {
                        Text("Pressure:")
                            .fontWeight(.semibold)
                        Text("\(trackpadListener.trackpadPressure, specifier: "%.4f")")
                            .fontDesign(.monospaced)
                        Text("Position:")
                            .fontWeight(.semibold)
                        Text("[\(trackpadListener.pointerPosition.x, specifier: "%.2f"), \(trackpadListener.pointerPosition.y, specifier: "%.2f")]")
                            .fontDesign(.monospaced)
                    }
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 200, minHeight: 300, idealHeight: 300)
                    .padding(20)
                    // Plotting
                    PlottingView(trackpadListener: trackpadListener)
                        .frame(minWidth: 200, idealWidth: 300, minHeight: 300)
                        .padding(20)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

#Preview {
    ContentView()
}
