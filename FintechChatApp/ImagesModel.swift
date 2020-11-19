//
//  ImagesModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 18.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

struct ImageCellModel {
    let id: Int
    let url: String
}

protocol IImagesModelDelegate: class {
    func setup(dataSource: [ImageCellModel])
}

protocol IImagesModel: class {
    func fetchImages()
    func fetchImage(urlImage: String, completion: @escaping (UIImage) -> Void)
}

class ImagesModel: IImagesModel {
    var delegate: IImagesModelDelegate?
    
    let imagesService: IImagesService
    
    init(imagesService: IImagesService) {
        self.imagesService = imagesService
    }
    
    func fetchImages() {
        imagesService.loadImages { (images) in
            if let images = images {
                let cells = images.map { ImageCellModel(id: $0.id, url: $0.webformatURL) }
                self.delegate?.setup(dataSource: cells)
            }
        }
    }
    
    func fetchImage(urlImage: String, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.imagesService.loadImage(urlImage: urlImage) { (imageData) in
                if let imageData = imageData {
                    DispatchQueue.main.async {
                        completion(UIImage(data: imageData) ?? UIImage(imageLiteralResourceName: "imagePlaceholder"))
                    }
                }
            }
        }
    }
}
