//
//  QuotesModel.swift
//  Paraphrase
//
//  Created by slava bily on 23/12/19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation
import GameplayKit
import SwiftyBeaver
 
struct QuotesModel {
    private var quotes = [Quote]()
    
    var count: Int {
        return quotes.count
    }
    
    var randomSource: GKRandomSource?
    
    init(testing: Bool = false) {
        if testing {
            randomSource = GKMersenneTwisterRandomSource(seed: 1)
        } else {
            randomSource = GKMersenneTwisterRandomSource()
        }
        let defaults = UserDefaults.standard
        let quoteData: Data
        
        if !testing, let savedQuotes = defaults.data(forKey: "SavedQuotes") {
            // we have saved quotes; use them
            SwiftyBeaver.info("Loading saved quotes")
            quoteData = savedQuotes
        } else {
            // no saved quotes; load the default initial quotes
            SwiftyBeaver.info("No saved quotes")
            let path = Bundle.main.url(forResource: "initial-quotes", withExtension: "json")!
            quoteData = (try? Data(contentsOf: path)) ?? Data()
        }
        
        let decoder = JSONDecoder()
        quotes = (try? decoder.decode([Quote].self, from: quoteData)) ?? [Quote]()
    }
    
    func random() -> Quote? {
        guard !quotes.isEmpty else {return nil}
        let randomNumber = randomSource?.nextInt(upperBound: quotes.count) ?? 0
        return quotes[randomNumber]
    }
    
    func quote(at position: Int) -> Quote {
        return quotes[position]
    }
    
    mutating func add(_ quote: Quote) {
        quotes.append(quote)
        save()
    }

    mutating func remove(at index: Int) {
        quotes.remove(at: index)
        save()
    }
    
    mutating func replace(index: Int, with quote: Quote) {
        if quote.author.isEmpty && quote.text.isEmpty {
            // if no text was entered just delete the quote
            SwiftyBeaver.info("Removing empty quote")
            quotes.remove(at: index)
        } else {
            // replace our existing quote with this new one then save
            SwiftyBeaver.info("Replacing quote at index \(index)")
            quotes[index] = quote
        }
        save()
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(quotes)
            defaults.set(data, forKey: "SavedQuotes")
            SwiftyBeaver.info("Quotes saved")
        } catch {
            SwiftyBeaver.error("Could not save quotes")
        }
     }
}
