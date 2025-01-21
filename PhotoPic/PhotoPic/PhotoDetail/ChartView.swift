//
//  ChartView.swift
//  PhotoPic
//
//  Created by 조성민 on 1/20/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    private var elements: [HistoricalValue] = []
    
    var body: some View {
        Chart(elements, id: \.self) {
            LineMark(
                x: .value("", $0.date),
                y: .value("", $0.value)
            )
            AreaMark(
                x: .value("", $0.date),
                y: .value("", $0.value)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        .blue,
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
    
    mutating func configure(elements: [HistoricalValue]) {
        self.elements = elements
    }
}
