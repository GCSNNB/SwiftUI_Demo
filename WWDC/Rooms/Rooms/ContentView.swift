//
//  ContentView.swift
//  Rooms
//
//  Created by 宋冠辰 on 2021/7/4.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: RoomStore
    
    var body: some View {
        NavigationView {
//            List(store.rooms) { room in
//                RoomCell(room: room)
//            }
            List {
                Section {
                    Button(action:addRoom) {
                        Text("Add Room")
                    }
                }
                
                Section {
                    ForEach(store.rooms)  { room in
                        RoomCell(room: room)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                
            }
            .navigationBarTitle(Text("Rooms"))
            .navigationBarItems(trailing: EditButton())
            .listStyle(GroupedListStyle())
        }
    }
    
    func addRoom() {
        store.rooms.append(Room(name: "Hall 2", capacity: 2000))
    }
    func delete(at offsets: IndexSet) {
        store.rooms.remove(atOffsets: offsets)
    }
    func move(from source: IndexSet, to destination: Int) {
        store.rooms.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(RoomStore(rooms: testData))
            // 大字号环境
            ContentView()
                .environmentObject(RoomStore(rooms: testData))
                .environment(\.sizeCategory, .extraExtraLarge)
            // 深色模式
            ContentView()
                .environmentObject(RoomStore(rooms: testData))
                .environment(\.colorScheme, .dark)
            // 布局方向
            ContentView()
                .environmentObject(RoomStore(rooms: testData))
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "ar"))
        }
    }
}

struct RoomCell: View {
    let room: Room
    
    var body: some View {
        NavigationLink(destination: RoomDetail(room: room)) {
            Image(room.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8.0)
            
            
            VStack(alignment: .leading) {
                Text(room.name)
                Text("\(room.capacity) people")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
