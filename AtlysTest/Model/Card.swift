//
//  Card.swift
//  AtlysTest
//
//  Created by poonam on 12/07/25.
//

import Foundation
struct Card: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
}
extension Card{
    static let cards = [
        Card(imageName: "Dubai1"),
        Card(imageName: "Dubai2"),
        Card(imageName: "Dubai3"),
        Card(imageName: "Dubai4"),
        Card(imageName: "Dubai5"),
    ]
}
