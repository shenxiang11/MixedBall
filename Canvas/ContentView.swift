//
//  ContentView.swift
//  Canvas
//
//  Created by FS on 2024/1/12.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @State var circles: [CircleData] = []
    
    var body: some View {
        
        TimelineView(.animation(minimumInterval: 1)) {
            timeLine in
                    
            Canvas { context, size in
                context.addFilter(.alphaThreshold(min: 0.2,color: .pink))
                context.addFilter(.blur(radius: 15))
                
                context.drawLayer { ctx in
                    for circle in circles {
                        if let resolvedView = context.resolveSymbol(id: circle.id){
                            ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                        }
                    }
                    
                    if let rectView = context.resolveSymbol(id: "rect") {
                        ctx.draw(rectView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            } symbols: {
                let timeNow = timeLine.date
                
                ForEach(circles){ circle in
                    let second = timeNow.timeIntervalSince(circle.createTime)
                    let moveY = -(second * circle.speed)
                    let scale = 1 - min((-moveY) * 0.0015, 1)
                    
                    Circle()
                        .foregroundColor(.pink)
                        .frame(width: circle.r, height: circle.r)
                        .scaleEffect(scale)
                        .offset(circle.offset)
                        .offset(y: circle.moveY)
                        .animation(.linear(duration: 5), value: [circle.moveY, scale])
                        .onChange(of: moveY, {
                            if let targetIndex = circles.firstIndex(where: { c in
                                c.id == circle.id
                            }) {
                                circles[targetIndex].moveY = moveY
                            }
                            
                            if scale == 0 {
                                circles.removeAll { c in
                                    c.id == circle.id
                                }
                                circles.append(CircleData())
                            }
                        })
                        .tag(circle.id)
                }
                
                
                Rectangle()
                    .foregroundColor(.pink)
                    .frame(width: screenWidth + 200, height: 100)
                    .offset(x: 0, y: screenHeight/2)
                    .tag("rect")
            }
            .ignoresSafeArea(.all)
        }
        .onAppear {
            for _ in 0..<18 {
                circles.append(CircleData())
            }
        }
    }
}

#Preview {
    ContentView()
}
