//
//  CarouselView.swift
//  AtlysTest
//
//  Created by poonam on 12/07/25.
//

import SwiftUI
struct CarouselView: View {
    @StateObject private var viewModel = CarouselViewModel()
    var body: some View {
        VStack {
            GeometryReader { geo in
                let cardSize   = viewModel.calculateCardSize(availableWidth: geo.size.width,
                                                             availableHeight: geo.size.height)
                let spacing    = viewModel.calculateSpacing(cardSize: cardSize)
                ZStack {
                    ForEach(viewModel.cards.indices, id: \.self) { index in
                        let position     = CGFloat(index - viewModel.currentIndex)
                        let dragPosition = position + (viewModel.dragOffset / spacing)
                        CardView(card: viewModel.cards[index], cardWidth: cardSize)
                            .frame(width: cardSize, height: cardSize)
                            .scaleEffect(viewModel.calculateScale(for: dragPosition))
                            .offset(
                                x: viewModel.calculateXOffset(for: position,
                                                              dragPosition: dragPosition,
                                                              spacing: spacing,
                                                              cardWidth: cardSize/2),
                                y: viewModel.calculateYOffset(for: dragPosition)
                            )
                            .zIndex(viewModel.calculateZIndex(for: dragPosition))
                            .animation(.spring(response: 0.8, dampingFraction: 0.75, blendDuration: 0.3),
                                       value: viewModel.currentIndex)
                            .animation(.easeOut(duration: 0.3), value: viewModel.dragOffset)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: cardSize + 50)
                .padding(.horizontal, max(0, (geo.size.width - cardSize) / 2))
                .gesture(
                    DragGesture()
                        .onChanged { onDragChanged($0, cardSize: cardSize) }
                        .onEnded   { onDragEnded($0,   cardSize: cardSize) }
                )
                // Page Indicators
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.cards.count, id: \.self) { idx in
                            Circle()
                                .fill(idx == viewModel.currentIndex ? Color.blue : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .scaleEffect(idx == viewModel.currentIndex ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: viewModel.currentIndex)
                        }
                    }
                    Spacer()
                }
                .padding(.top, cardSize + 50)
            }
        }
    }
    // MARK: - Gesture Handling
    func onDragChanged(_ value: DragGesture.Value, cardSize: CGFloat) {
        let translation = value.translation.width
        let resistance: CGFloat = 0.7
        if (viewModel.currentIndex  == 0 && translation > 0) ||
            (viewModel.currentIndex  == viewModel.cards.count - 1 && translation < 0) {
            viewModel.dragOffset = translation * resistance
        } else {
            viewModel.dragOffset = translation
        }
    }
    func onDragEnded(_ value: DragGesture.Value, cardSize: CGFloat) {
        let threshold = cardSize / 4
        let velocity = value.predictedEndTranslation.width / cardSize
        var newIndex = viewModel.currentIndex
        if abs(velocity) > 0.5 {
            if velocity < -0.5 && viewModel.currentIndex < viewModel.cards.count - 1 { newIndex += 1 }
            else if velocity > 0.5 && viewModel.currentIndex > 0      { newIndex -= 1 }
        } else {
            if -value.translation.width > threshold && viewModel.currentIndex < viewModel.cards.count - 1 {
                newIndex += 1
            } else if value.translation.width > threshold && viewModel.currentIndex > 0 {
                newIndex -= 1
            }
        }
        
        withAnimation(.spring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.2)) {
            viewModel.currentIndex = newIndex
            viewModel.dragOffset = 0
        }
    }
}

#Preview {
    CarouselView()
}
