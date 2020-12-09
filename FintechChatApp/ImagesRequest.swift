//
//  ImagesRequest.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class ImagesRequest: IRequest {
    
    private var baseUrl: String = "https://pixabay.com/api/"
    private let apiKey: String
    private let q = "space"
    private let image_type = "photo"
    private let per_page = "100"
    
    private var getParameters: [String: String] {
        return ["key": apiKey,
                "q": q,
                "image_type": image_type,
                "per_page": per_page]
    }
    
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization

    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
}

class ImageRequest: IRequest {
    
    private let urlImage: String
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlImage) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    init(urlImage: String) {
        self.urlImage = urlImage
    }
}
