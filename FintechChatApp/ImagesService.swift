//
//  ImagesService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IImagesService {
    func loadImages(completionHandler: @escaping ([PhotosModel]?) -> Void)
    func loadImage(urlImage: String, completionHandler: @escaping (Data?) -> Void)
}

class ImagesService: IImagesService {
    
    let networkRequestSender: IRequestSender
    
    init(networkRequestSender: IRequestSender) {
        self.networkRequestSender = networkRequestSender
    }
    
    func loadImages(completionHandler: @escaping ([PhotosModel]?) -> Void) {
        let requestConfig = RequestFactory.ImagesRequests.imagesConfig()
        
        networkRequestSender.send(requestConfig: requestConfig) { (result) in
            
            switch result {
            case .success(let images):
                completionHandler(images)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
            
        }
    }
    
    func loadImage(urlImage: String, completionHandler: @escaping (Data?) -> Void) {
        let requestConfig = RequestFactory.ImagesRequests.imageConfig(urlImage: urlImage)
        
        networkRequestSender.send(requestConfig: requestConfig) { (result) in
            switch result {
            case .success(let imageData):
                completionHandler(imageData)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }
    }
    
}
