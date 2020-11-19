//
//  ImagesParser.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

struct PhotosModel {
    let id: Int
    let webformatURL: String
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

class ImagesParser: IParser {

    typealias Model = [PhotosModel]
    
    func parse(data: Data) -> [PhotosModel]? {
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let json = jsonObject as? [String: Any] else { return nil }
            
            guard let hits = json["hits"] as? [[String: Any]] else { return nil }
            
            var images: [PhotosModel] = []
            
            for image in hits {
                guard let id = image["id"] as? Int, let webformatURL = image["webformatURL"] as? String else { continue }
                images.append(PhotosModel(id: id, webformatURL: webformatURL))
            }
            
            return images
            
        } catch {
            print("Parse error")
            return nil
        }
        
    }
    
}

class ImageParser: IParser {
    
    typealias Model = Data
    
    func parse(data: Data) -> Data? {
        return data
    }
    
}
