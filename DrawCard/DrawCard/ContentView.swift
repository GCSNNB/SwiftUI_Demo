//
//  ContentView.swift
//  DrawCard
//
//  Created by 宋冠辰 on 2021/7/9.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var cardList: CardList
    let generator = PassthroughSubject<Int, Never>()
    
    var body: some View {
        let overlayContent = VStack(alignment: .leading) {
            Button(action: newCard) { Text("New Card") }
            Spacer()
        }
        .padding()

        let lines = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        let Cards = ZStack {
            GeometryReader { geometry in
                LazyHGrid(rows: lines) {
                    ForEach(cardList.cardIDs, id: \.self) { cardID in
                        let card: CardList.Card = cardList.cardInfo[cardID]!
                        CardView(card: card, generator: generator)
                    }
                    .transition(.scaleAndFade)
                }
                .padding([.top, .leading], 30)
                Spacer()
            }
        }.onReceive(generator, perform: { id in
            withAnimation() {
                cardList.removeCard(id: id)
            }
        })
        .padding()

        return Cards
            .overlay(overlayContent, alignment: .topLeading)
    }
    
    func newCard() {
        withAnimation() {
            cardList.addCard(.newCard)
        }
    }
}

struct ScaleAndFade: ViewModifier {
    /// True when the transition is active.
    var isEnabled: Bool

    // Scale and fade the content view while transitioning in and
    // out of the container.

    func body(content: Content) -> some View {
        return content
            .scaleEffect(isEnabled ? 0.1 : 1)
            .opacity(isEnabled ? 0 : 1)
    }
}

extension AnyTransition {
    static let scaleAndFade = AnyTransition.modifier(
        active: ScaleAndFade(isEnabled: true),
        identity: ScaleAndFade(isEnabled: false))
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardList())
    }
}
