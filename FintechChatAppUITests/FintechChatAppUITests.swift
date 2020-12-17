//
//  FintechChatAppUITests.swift
//  FintechChatAppUITests
//
//  Created by Никита Кузнецов on 02.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import XCTest

class FintechChatAppUITests: XCTestCase {

    func testExistingOfTextViewAndTextFieldInProfileVC() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let profileButton = app.buttons["openProfileButton"]
        _ = profileButton.waitForExistence(timeout: 3)
        profileButton.tap()
        
        let editProfileButton = app.buttons["editProfileButton"]
        _ = editProfileButton.waitForExistence(timeout: 3)
        editProfileButton.tap()
        
        let textField = app.textFields.element
        _ = textField.waitForExistence(timeout: 3)
        
        let textView = app.textViews.element
        _ = textView.waitForExistence(timeout: 3)
        
        XCTAssert(textField.exists)
        XCTAssert(textView.exists)
    }
    
}
