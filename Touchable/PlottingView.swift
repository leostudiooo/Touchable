//
//  PlottingView.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/23.
//

import SwiftUI

struct PlottingView: View {
    @ObservedObject var trackpadListener: TrackpadListener
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
//                let maxPressure = trackpadListener.pressureValues.max() ?? 1
                let maxPressure = 1.0
                let points = trackpadListener.pressureValues.enumerated().map { index, pressure in
                    CGPoint(x: CGFloat(index) * width / CGFloat(trackpadListener.pressureValues.count), y: height - (pressure / maxPressure * height))
                }
                path.addLines(points)
            }
            .stroke(.blue, lineWidth: 2)
        }
    }
}

#Preview {
    PlottingView(trackpadListener: TrackpadListener())
}
