//
//  ParaphraseTests.swift
//  ParaphraseTests
//
//  Created by slava bily on 23/12/19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import XCTest
@testable import Paraphrase

class ParaphraseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadingInitialQuotes() {
        let model = QuotesModel(testing: true)
        XCTAssert(model.count == 12)
    }
    
    func testRandomQuote() {
        let model = QuotesModel(testing: true)
        guard let quote = model.random() else {
            XCTFail()
            return
        }
        XCTAssert(quote.author == "Henley")
    }
    
    func testFormatting() {
        let model = QuotesModel(testing: true)
        let quote = model.quote(at: 0)
        
        let testString = "\"\(quote.text)\"\n   — \(quote.author)"
        XCTAssert(quote.multiLine == testString)
    }
    
    func testAddingquote() {
        var model = QuotesModel(testing: true)
        let quoteCount = model.count
        
        let newQuote = Quote(author: "Paul Hudson", text: "Programming is an art. Don't spend all your time sharpening your pencil when you should be drawing.")
        model.add(newQuote)
        
        XCTAssert(model.count == quoteCount + 1)
    }
    
    func testRemovingQuote() {
        var model = QuotesModel(testing: true)
        let quoteCount = model.count
        
        model.remove(at: 0)
        XCTAssert(model.count == quoteCount - 1)
    }
    
    func testReplacingQuote() {
        var model = QuotesModel(testing: true)
        
        let newQuote = Quote(author: "Ted Logan", text: "All we are is dust in the wind, dude.")
        model.replace(index: 0, with: newQuote)
        
        let testQuote = model.quote(at: 0)
        XCTAssert(testQuote.author == "Ted Logan")
    }
    
    func testReplacingEmptyQuote() {
        var model = QuotesModel(testing: true)
        let previosCount = model.count
        
        let newQuote = Quote(author: "", text: "")
        model.replace(index: 0, with: newQuote)
        
        XCTAssert(model.count == previosCount - 1)
    }

    

}
