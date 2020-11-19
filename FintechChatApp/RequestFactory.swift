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
            let request = ImagesRequest(apiKey: "19155021-8859246a4990c09f3d480272b")
            return RequestConfig(request: request, parser: ImagesParser())
        }
        
        static func imageConfig(urlImage: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(urlImage: urlImage)
            return RequestConfig(request: request, parser: ImageParser())
        }
    }
}
