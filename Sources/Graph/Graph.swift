//
//  SwiftUIView.swift
//  
//
//  Created by Ohara Yoji on 2023/05/06.
//

import SwiftUI

public struct Graph: View {
    // This value is set when initialize
    private(set) var edgeValue: Int = 5
    private(set) var f: (Double) -> Double = { x in
        return sin(x) * 2
    }
    
    // This value is not set when initialize
    private(set) var plotNum: Int = 300
    private(set) var scaleTextColor: Color = .secondary
    
    public init(edgeValue: Int, f: @escaping (Double) -> Double) {
        self.edgeValue = edgeValue
        self.f = f
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let graphCanvas = CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height)
            let scaleSeparateNum: Double = Double(edgeValue) * 2
            let scaleIntervalX: Double = Double(graphCanvas.width) / scaleSeparateNum
            let scaleIntervalY: Double = Double(graphCanvas.height) / scaleSeparateNum
            
            ZStack {
                
                // XY-axis
                Path { path in
                    path.move(to: CGPoint(x: 0, y: graphCanvas.midY))
                    path.addLine(to: CGPoint(x: graphCanvas.width, y: graphCanvas.midY))
                    path.move(to: CGPoint(x: graphCanvas.midX, y: 0))
                    path.addLine(to: CGPoint(x: graphCanvas.midX, y: graphCanvas.height))
                }.stroke(Color.black, lineWidth: 2)
                
                // ScalePlot
                Path { path in
                    for i in 0...Int(scaleSeparateNum) {
                        path.move(to: CGPoint(x: Double(i) * scaleIntervalX, y: 0))
                        path.addLine(to: CGPoint(x: Double(i) * scaleIntervalX, y: graphCanvas.height))
                        path.move(to: CGPoint(x: 0, y: Double(i) * scaleIntervalY))
                        path.addLine(to: CGPoint(x: graphCanvas.width, y: Double(i) * scaleIntervalY))
                    }
                }
                .stroke(lineWidth: 1)
                .foregroundColor(.gray)
                
                // Plot
                Path { path in
                    let plotIntervalX: Double = Double(graphCanvas.width) / Double(plotNum - 1)
                    let mathIntervalX: Double = Double(edgeValue * 2) / Double(plotNum - 1)
                    var plotX: Double = 0
                    var mathX: Double = Double(-edgeValue)
                    path.move(to: mathToCGPoint(rect: graphCanvas, mathX: mathX, mathY: f(mathX)))
                    for _ in 1...plotNum {
                        plotX += plotIntervalX
                        mathX += mathIntervalX
                        path.addLine(to: mathToCGPoint(rect: graphCanvas, mathX: mathX, mathY: f(mathX)))
                    }
                }
                .stroke(lineWidth: 3)
                
                // Scale text
                Text("\(String(Double(edgeValue)))")
                    .offset(x: 20, y: -graphCanvas.midY + 10)
                    .foregroundColor(scaleTextColor)
                Text("-\(String(Double(edgeValue)))")
                    .offset(x: 20, y: graphCanvas.midY - 10)
                    .foregroundColor(scaleTextColor)
                Text("-\(String(Double(edgeValue)))")
                    .offset(x: -graphCanvas.midX + 20, y: 20)
                    .foregroundColor(scaleTextColor)
                Text("\(String(Double(edgeValue)))")
                    .offset(x: graphCanvas.midX - 20, y: 20)
                    .foregroundColor(scaleTextColor)
            }
        }
    }
    
    private func mathToCGPoint(rect: CGRect, mathX: Double, mathY: Double) -> CGPoint {
        let x: Double = mathX * (rect.midX / Double(edgeValue)) + rect.midX
        let y: Double = -mathY * (rect.midY / Double(edgeValue)) + rect.midY
        return CGPoint(x: x, y: y)
    }
}
