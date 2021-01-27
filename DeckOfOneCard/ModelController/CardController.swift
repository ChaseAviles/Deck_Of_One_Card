//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Johnathan Aviles on 1/26/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardController: Decodable{
    
    // https://deckofcardsapi.com/api/deck/new/draw/?count=1
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        
        guard let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/") else { return completion(.failure(.invalidURL)) }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let countItem = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [countItem]
        guard let finalURL = components?.url else { return (completion(.failure(.invalidURL))) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print(error.localizedDescription)
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else { return completion(.failure(.noData)) }
                completion(.success(card))
                
            }catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print(error.localizedDescription)
                print("======== ERROR ========")
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result<UIImage, CardError>) -> Void){
        //let url = pokemon.sprites.front_shiny
        let url = card.image
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print(error.localizedDescription)
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            completion(.success(image))
            
            
        }.resume()
    }
}
