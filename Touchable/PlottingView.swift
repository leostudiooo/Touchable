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
        let points = trackpadListener.dataPoints
        if let first = points.first?.id, let last = points.last?.id {
            return Double(first)...Double(last)
        }
        return 0...100
    }
    
    private var movementDomain: ClosedRange<Double> {
        let allDeltas = trackpadListener.dataPoints.flatMap { [$0.xDelta, $0.yDelta] }
        if let min = allDeltas.min(), let max = allDeltas.max() {
            let padding = (max - min) * 0.1
            return (min - padding)...(max + padding)
        }
        return -100...100
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Pressure Plot
            Chart {
                ForEach(trackpadListener.dataPoints) { point in
                    LineMark(
                        x: .value("Sample", point.id),
                        y: .value("Pressure", point.pressure)
                    )
                    .foregroundStyle(.blue)
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
            .frame(height: 150)
            .overlay(alignment: .topLeading) {
                Text("Pressure")
                    .font(.caption)
                    .padding(4)
            }
            
            // Movement Plot
            Chart {
                ForEach(trackpadListener.dataPoints) { point in
                    LineMark(
                        x: .value("Sample", point.id),
                        y: .value("X Movement", point.xDelta)
                    )
                    .foregroundStyle(.green)
                
                    LineMark(
                        x: .value("Sample", point.id),
                        y: .value("Y Movement", point.yDelta)
                    )
                    .foregroundStyle(.red)
                }
            }
            .chartYScale(domain: movementDomain)
            .chartXScale(domain: xDomain)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .frame(height: 150)
            .overlay(alignment: .topLeading) {
                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("X Movement")
                    }
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                        Text("Y Movement")
                    }
                }
                .font(.caption)
                .padding(4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlottingView(trackpadListener: TrackpadListener())
}
