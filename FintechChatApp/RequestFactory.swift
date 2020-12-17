//
//  RequestFactory.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

struct RequestFactory {
    
    struct ImagesRequests {
        static func imagesConfig() -> RequestConfig<ImagesParser> {
            
            let requestString = Bundle.main.infoDictionary?["pixabayapikey"] as? String ?? ""
            print(requestString)
            if requestString == "" {
                print("Add Config.xcconfig with API key")
            }
            
            let request = ImagesRequest(apiKey: requestString)
            return RequestConfig(request: request, parser: ImagesParser())
            
        }
        
        static func imageConfig(urlImage: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(urlImage: urlImage)
            return RequestConfig(request: request, parser: ImageParser())
        }
    }
}
