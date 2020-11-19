//
//  ImageCell.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 16.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var url: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage(imageLiteralResourceName: "imagePlaceholder")
    }
}
