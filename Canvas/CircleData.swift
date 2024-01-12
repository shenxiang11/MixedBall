//
//  CircleData.swift
//  Canvas
//
//  Created by FS on 2024/1/12.
//

import SwiftUI

struct CircleData: Identifiable {
    let id = UUID()
    let createTime = Date()
    let r: CGFloat = CGFloat.random(in: 40...100)
    let x: CGFloat = CGFloat.random(in: -screenWidth/2...screenWidth/2)
    let speed: CGFloat = CGFloat.random(in: 30...100)
    var moveY: CGFloat = 0
    
    var offset: CGSize {
        CGSize(width: self.x, height: screenHeight / 2 - (100 - self.r) / 2)
    }
}


#Preview {
    ContentView()
}
