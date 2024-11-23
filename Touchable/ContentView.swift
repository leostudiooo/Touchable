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
        
        ZStack{
            Circle()
                .fill(.blue)
                .frame(width: trackpadListener.getRadius())
                .position(trackpadListener.pointerPosition)
                .opacity(0.5)
            HStack {
                VStack {
                    Text("Pointer Position: \(trackpadListener.pointerPosition.x), \(trackpadListener.pointerPosition.y)")
                    Text("Pressure: \(trackpadListener.trackpadPressure)")
                }
                .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 300, idealHeight: 300)
                // Plotting
                PlottingView(trackpadListener: trackpadListener)
                    .frame(minWidth: 200, idealWidth: 300, maxWidth: 350, maxHeight: 300)
            }
        }
    }
}

#Preview {
    ContentView()
}
