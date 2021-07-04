//
//  RoomDetail.swift
//  Rooms
//
//  Created by 宋冠辰 on 2021/7/4.
//

import SwiftUI

struct RoomDetail: View {
    let room: Room
    @State private var zoomed = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(room.imageName)
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fit : .fill)
                .navigationBarTitle(Text(room.name), displayMode: .inline)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 2)) {
                        self.zoomed.toggle()
                    }
                }
                .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            if room.hasVideo && !zoomed {
                Image(systemName: "video.fill")
                    .font(.title)
                    .padding(.all)
                    .transition(.move(edge: .leading))
            }
            
        }
    }
}

struct RoomDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            /*
             只设置`navigationTitle`不会看到展示效果，这是因为上下文缺乏`NavigationView`
             */
            NavigationView {
                RoomDetail(room: testData[0])
            }
            NavigationView {
                RoomDetail(room: testData[1])
            }
        }
        
    }
}
