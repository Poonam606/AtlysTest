//
//  CarouselViewModel.swift
//  AtlysTest
//
//  Created by poonam on 12/07/25.
//

import Foundation
// MARK: - ViewModel
final class CarouselViewModel: ObservableObject {
    @Published var currentIndex: Int = 1
    @Published var dragOffset: CGFloat = 0
    let cards: [Card]
    private let maxCardSize: CGFloat = 250
    init(cards: [Card] = Card.cards) {
        self.cards = cards
    }
    // MARK: - Layout Calculations
    func calculateCardSize(availableWidth: CGFloat, availableHeight: CGFloat) -> CGFloat {
        let maxW = availableWidth * 0.7
        let maxH = availableHeight - 60
        return min(maxW, maxH, maxCardSize)
    }
    func calculateSpacing(cardSize: CGFloat) -> CGFloat {
        cardSize * 0.7
    }
    // MARK: -  Calculations Scale
    func calculateScale(for position: CGFloat) -> CGFloat {
        let absPos = abs(position)
        switch absPos {
        case 0..<0.1: return 1.0
        case 0.1..<0.5: return 1.0 - (absPos * 0.4)
        case 0.5..<1.0:
            let factor = (absPos - 0.5) / 0.9
            return 0.8 - (factor * 0.25)
        case 1.0..<2.0:
            let factor = (absPos - 1.0) / 1.0
            return 0.55 - (factor * 0.15)
        default:
            return max(0.3, 0.4 - ((absPos - 2.0) * 0.05))
        }
    }
    // MARK: -  Calculate Z index
    func calculateZIndex(for position: CGFloat) -> Double {
        let absPos = abs(position)
        switch absPos {
        case 0..<0.1: return 1000
        case 0.1..<1.0: return Double(1000 - absPos * 500)
        case 1.0..<2.0: return Double(500 - ((absPos - 1.0) * 200))
        default:       return Double(max(50, 300 - ((absPos - 2.0) * 50)))
        }
    }
    // MARK: -  Calculate Y offset
    func calculateYOffset(for position: CGFloat) -> CGFloat {
        let absPos = abs(position)
        if absPos <= 0.1 { return 0 }
        if absPos <= 1.0 { return absPos }
        return 15 + ((absPos - 1.0) * 10)
    }
    // MARK: -  Calculate x offset
    func calculateXOffset(for basePosition: CGFloat, dragPosition: CGFloat, spacing: CGFloat, cardWidth: CGFloat) -> CGFloat {
        let absPos = abs(dragPosition)
        let scale = calculateScale(for: dragPosition)
        let scaledWidth = cardWidth * scale
        let minGap: CGFloat = 15
        let effectiveSpacing = max(spacing, scaledWidth + minGap)
        if absPos > 0.1 && absPos < 1.0 {
            let transition = sin(absPos * .pi)
            let extra = transition * 15
            let dir: CGFloat = dragPosition > 0 ? 1 : -1
            return basePosition * effectiveSpacing + dragOffset + dir * extra
        }
        return basePosition * effectiveSpacing + dragOffset
    }
}


