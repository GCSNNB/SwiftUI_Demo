//
//  DrawCardApp.swift
//  DrawCard
//
//  Created by 宋冠辰 on 2021/7/9.
//

import SwiftUI

@main
struct DrawCardApp: App {
    
    private var sharedCardList = CardList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sharedCardList)
            
        }
    }
}
