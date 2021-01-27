//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Johnathan Aviles on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct Card: Decodable {
    var value: String
    var suit: String
    var image: URL
}

struct TopLevelObject: Decodable {
    var cards: [Card]
}
