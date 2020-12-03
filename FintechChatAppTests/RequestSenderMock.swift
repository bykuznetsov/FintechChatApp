//
//  RequestSenderMock.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 02.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import Foundation

class RequestSenderMock: IRequestSender {
    
    var sendingRequestCount: Int = 0
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        sendingRequestCount += 1
    }
    
}
