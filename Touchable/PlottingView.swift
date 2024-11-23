//
//  PlottingView.swift
//  Touchable
//
//  Created by Leo Li on 2024/11/23.
//

import SwiftUI
import Charts

struct PlottingView: View {
    @ObservedObject var trackpadListener: TrackpadListener
    
    private var xDomain: ClosedRange<Double> {
        let points = trackpadListener.pressurePoints
        if let first = points.first?.id, let last = points.last?.id {
            return Double(first)...Double(last)
        }
        return 0...100
    }
    
    var body: some View {
        Chart {
            ForEach(trackpadListener.pressurePoints) { point in
                LineMark(
                    x: .value("Sample", point.id),
                    y: .value("Pressure", point.pressure)
                )
            }
        }
        .chartYScale(domain: 0...1)
        .chartXScale(domain: xDomain)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlottingView(trackpadListener: TrackpadListener())
}
