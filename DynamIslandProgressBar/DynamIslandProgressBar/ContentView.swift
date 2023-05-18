//
//  ContentView.swift
//  DynamIslandProgressBar
//
//  Created by Boris on 18.05.2023.
//

import SwiftUI

let size: CGSize = {
    return .init(width: 126.0, height: 36.9)
}()

let origin: CGPoint = {
    return .init(x: UIScreen.main.bounds.midX - 0.4, y: 29.4)
}()

let indicator: CGPoint = {
    return .init(x: UIScreen.main.bounds.midX - 180, y: 19.4)
}()

struct DynamicIslandProgressViewStyle: ProgressViewStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        let isCompleted: Bool
            = configuration.fractionCompleted != 1.0
        
        ZStack {
            
            Capsule(style: .continuous)
                .fill(.black)
                .frame(width: size.width, height: size.height)
                .offset(CGSize(width: configuration.fractionCompleted == 0.0 ? 31.0 : 0.0, height: 0.0))
            
            if !isCompleted {
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundColor(Color.green)
                    .frame(width: 10, height: 8)
                    .position(CGPoint(x: indicator.x, y: indicator.y))
            }
            
            Circle()
                .trim(from: 0, to: configuration.fractionCompleted ?? 0.0)
                .stroke(
                    isCompleted ? Color.purple : Color.green,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )  .frame(width: size.width - 15, height: size.height - 15)
                .position(CGPoint(x: indicator.x, y: indicator.y))
            
        }
        
        .frame(width: size.width, height: size.height)
        .position(CGPoint(x: origin.x-30, y: origin.y))
        .edgesIgnoringSafeArea(.top)
    }
}

struct DynamicIslandProgressViewModifier<Value: BinaryFloatingPoint>:
    ViewModifier
{
    let value: Value
    let total: Value
    
    func body(content: Content) -> some View {
        ZStack {
            ProgressView(value: value, total: total)
                .progressViewStyle(DynamicIslandProgressViewStyle())
            content
        }
    }
}

extension View {
    func dynamicIslandProgress<Value: BinaryFloatingPoint, Style: ShapeStyle>(
        value: Value, total: Value = 1.0, style: Style = .tint
    ) -> some View {
        self.overlay {
            Color.clear.modifier(
                DynamicIslandProgressViewModifier(
                    value: value,
                    total: total
                )
            )
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ContentView: View {
    
    @State
    private var progress = 0.0
    
    let total = 10.0
    
    var body: some View {
        NavigationView {
            List {
                Stepper("Progress", value: $progress.animation(), in: 0...total)
            }
            .navigationTitle("Dynamic Island circle progress")
            .navigationBarTitleDisplayMode(.inline)
        }
        .dynamicIslandProgress(
            value: progress,
            total: total
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
