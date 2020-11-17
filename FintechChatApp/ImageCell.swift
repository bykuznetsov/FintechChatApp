//
//  ImageCell.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 16.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell, ConfigurableView {
    
    struct ImageCellModel {
        let image: UIImage?
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with model: ImageCellModel, with theme: Theme) {
        if let image = model.image {
            self.imageView.image = image
        }
    }
    
}
