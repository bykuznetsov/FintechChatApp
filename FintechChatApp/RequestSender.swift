//
//  RequestSender.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, Error>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) {
        
        guard let urlRequest = config.request.urlRequest else {
            fatalError("Invalid urlRequest in RequestSender")
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, _: URLResponse?, error: Error?) in
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    fatalError("Invalid data in RequestSender")
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
