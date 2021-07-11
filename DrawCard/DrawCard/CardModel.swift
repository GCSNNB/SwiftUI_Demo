//
//  CardModel.swift
//  DrawCard
//
//  Created by 宋冠辰 on 2021/7/9.
//

import SwiftUI
import Combine

class CardList: ObservableObject {
    struct Card: Equatable {
        var tag: Int = 0
        var number: String = ""
        var width: Double = 0.0
        var height: Double = 0.0
        var hue: Double = .random(in: 0 ... 1)
        
        static var newCard: Card {
            return Card()
        }
    }
    
    /// The collection of wedges, tracked by their id.
    var cardInfo: [Int: Card] {
        get {
            if _cardsNeedUpdate {
                let tempArr = self.shuffleArray(arr: cardIDs)
                for (i, id) in cardIDs.enumerated() {
                    var card = _cards[id]!
                    card.tag = id
                    card.number = String(tempArr[i] + 1)
                    _cards[id] = card
                }
                _cardsNeedUpdate = false
            }
            return _cards
        }
        set {
            objectWillChange.send()
            _cards = newValue
            _cardsNeedUpdate = true
        }
    }
    
    func shuffleArray(arr:[Int]) -> [Int] {
        if arr.count <= 1 {
            return arr
        }
        var data:[Int] = arr
        for i in 1..<arr.count {
            let index:Int = Int(arc4random()) % i
            if index != i {
                data.swapAt(i, index)
            }
        }
        return data
    }

    private var _cards = [Int: Card]()
    private var _cardsNeedUpdate = false
    
    private(set) var cardIDs = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }

    private var numIndex = 0
    
    let objectWillChange = PassthroughSubject<Void, Never>()

    func addCard(_ value: Card) {
        let id = numIndex
        numIndex += 1
        cardInfo[id] = value
        cardIDs.append(id)
    }

    func removeCard(id: Int) {
        let selectCard = cardInfo[id]
        let deleteID = Int(selectCard!.number)! - 1
        if let removeId = cardIDs.firstIndex(where: { $0 == deleteID}) {
            cardIDs.remove(at: removeId)
        }
        cardInfo.removeValue(forKey: deleteID)
    }

    func reset() {
        if !cardIDs.isEmpty {
            cardIDs = []
            cardInfo = [:]
            numIndex = 0
        }
    }
}
