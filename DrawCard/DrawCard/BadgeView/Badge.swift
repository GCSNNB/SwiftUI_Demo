//
//  Badge.swift
//  Sortition
//
//  Created by 宋冠辰 on 2021/6/27.
//

import SwiftUI

struct Badge: View {
    let gradientColor: (start: Color, end: Color)
    @Binding var startRotate: Bool
    @State private var rotationCounts: [Int] = [1, 2, 3, 4]
    @State private var timer: Timer?
    
    var badgeSymbols: some View {
        ForEach(rotationCounts, id: \.self) { i in
            RotatedBadgeSymbol(angle: Angle(degrees: Double(i) / Double(rotationCounts.count)) * 360.0)
            
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack {
            BadgeBackground(gradientColor: gradientColor)
            
            GeometryReader { geometry in badgeSymbols
                .scaleEffect(1.0 / 4.0, anchor: .top)
                .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
        .onChange(of: startRotate) { value in
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1 / 30, repeats: true
        ) {  _ in
            if (rotationCounts.count < 300) {
                rotationCounts.append(rotationCounts.last! + 1)
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255 , blue: 221.0 / 255)
        let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255 , blue: 120.0 / 255)
        Badge(gradientColor: (start: gradientStart, end: gradientEnd), startRotate: .constant(true))
    }
}
