//
//  CardView.swift
//  DrawCard
//
//  Created by 宋冠辰 on 2021/7/9.
//

import SwiftUI
import Combine

struct CardView: View {
    var card: CardList.Card
    let generator: PassthroughSubject<Int, Never>
    @State private var flipped: Bool = false
    @State private var animate3d = false
    @State private var animateDone = false
    
    var body: some View {
        let frontStart = Color(red: 239.0 / 255, green: 120.0 / 255 , blue: 221.0 / 255)
        let frontEnd = Color(red: 239.0 / 255, green: 172.0 / 255 , blue: 120.0 / 255)
        
        let gradientStart = card.startColor
        let gradientEnd = card.endColor
        
        let frontCard = CardFrontView(card: card, gradientColor: (start: frontStart, end: frontEnd))
        let backCard = CardBackView(card: card, gradientColor: (start: gradientStart, end: gradientEnd), startRotate: $animateDone)
            
        ZStack {
            backCard
                .opacity(flipped ? 1.0 : 0)
                .onTapGesture {
                    generator.send(card.tag)
                }
                
            frontCard
                .opacity(flipped ? 0 : 1.0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.animate3d.toggle()
                    }
                }
        }
        .modifier(FlipEffect(flipped: $flipped, animateDone:$animateDone, angle: animate3d ? 180 : 0, axis: (x: 1, y: 1)))
    }
}

struct CardFrontView: View {
    var card: CardList.Card
    let gradientColor: (start: Color, end: Color)
    @State private var breath = false
    
    var body: some View {
        BadgeBackground(gradientColor: gradientColor)
            .scaleEffect(breath ? 0.95 : 1, anchor: .center)
            .animation(.easeInOut(duration: 1.5).delay(1).repeatForever(autoreverses: true))
            .onAppear {
                breath.toggle()
            }
    }
}

struct CardBackView: View {
    var card: CardList.Card
    let gradientColor: (start: Color, end: Color)
    @Binding var startRotate: Bool
    
    var body: some View {
        ZStack {
            Badge(gradientColor: gradientColor, startRotate: $startRotate)
            Text(card.number).font(.system(size: 100))
                .scaleEffect(startRotate ? 1 : 0)
                .opacity(startRotate ? 1 : 0)
                .animation(.easeIn(duration: 2))
        }
    }
}

struct FlipEffect: GeometryEffect {
      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      @Binding var animateDone: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
                  self.animateDone = self.angle == 180
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

extension CardList.Card {
    var startColor: Color {
        return Color(hue: hue, saturation: 0.4, brightness: 0.8)
    }

    var endColor: Color {
        return Color(hue: hue, saturation: 0.7, brightness: 0.9)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let generator = PassthroughSubject<Int, Never>()
        CardView(card: .newCard, generator: generator)
    }
}
