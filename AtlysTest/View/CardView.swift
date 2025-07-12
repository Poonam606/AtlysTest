//
//  CardView.swift
//  AtlysTest
//
//  Created by poonam on 12/07/25.
//

import SwiftUI
struct CardView: View {
    let card: Card
    let cardWidth: CGFloat
    var body: some View {
        ZStack() {
            Image(card.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth,height: cardWidth)
                .cornerRadius(20)
                .shadow(radius: 5)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .frame(width: cardWidth, height: cardWidth)
    }
}

