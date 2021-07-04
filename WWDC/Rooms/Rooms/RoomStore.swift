//
//  RoomStore.swift
//  Rooms
//
//  Created by 宋冠辰 on 2021/7/4.
//

import SwiftUI
import Combine

class RoomStore: ObservableObject {
    @Published var rooms: [Room]
    
    init(rooms: [Room] = []) {
        self.rooms = rooms
    }
}
