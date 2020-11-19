//
//  ImagesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 16.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController, IImagesModelDelegate {
    
    // Dependencies
    private var presentationAssembly: IPresentationAssembly?
    private var model: IImagesModel?
    
    //CollectionView values
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private let cellIdentifier = String(describing: ImageCell.self)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cache = NSCache<NSNumber, UIImage>()
    
    // Display Model
    private var dataSource: [ImageCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        configureActivityIndicator()
        
        self.activityIndicator.startAnimating()
        
        if let model = model {
            model.fetchImages()
        }
        
    }
    
    func applyDependencies(model: IImagesModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
    }
    
    @IBAction func closeImages(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "Choose"
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: String(describing: ImageCell.self), bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier)
    }
    
    private func configureActivityIndicator() {
        self.activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - IImagesModelDelegate
    
    func setup(dataSource: [ImageCellModel]) {
        
        self.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
        
    }
    
}

extension ImagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        
        let imageData = self.dataSource[indexPath.item]
        cell.url = imageData.url
        
        return cell
    }
    
}

extension ImagesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageCell else { return }

        let itemNumber = NSNumber(value: indexPath.item)
        let imageData = self.dataSource[indexPath.item]
        
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            cell.imageView.image = cachedImage
        } else {
            if let model = self.model {
                model.fetchImage(urlImage: imageData.url) { [weak self] (image) in
                    if cell.url == imageData.url {
                        cell.imageView.image = image
                        self?.cache.setObject(image, forKey: itemNumber)
                    }
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    
    //Размер ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = self.sectionInserts.left * (self.itemsPerRow + 1)
        let availibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availibleWidth / self.itemsPerRow
        let heightPerItem = widthPerItem

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    //Настройка отступов по всем направлениям
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    //Настройка отступов по рядам
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    //Настройка отступов по строкам
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}

//class NetworkService {
//
//    private let token: String = "19155021-8859246a4990c09f3d480272b"
//
//    // MARK: - requestForStockInfo()
//
//    func requestForImages(completion: @escaping (Result <[String: Any], Error> ) -> Void) {
//        guard let url = URL(string: "https://pixabay.com/api/?key=\(self.token)&q=space&image_type=photo&per_page=5") else { return }
//        let urlSession = URLSession.shared
//        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
//            guard let data = data, (response as? HTTPURLResponse)?.statusCode == 200, error == nil else {
//                completion(.failure(error!))
//                return
//            }
//            do {
//                let jsonObject = try JSONSerialization.jsonObject(with: data)
//                guard let json = jsonObject as? [String: Any] else { return }
//                completion(.success(json))
//
//            } catch let jsonError {
//                completion(.failure(jsonError))
//            }
//        }
//        dataTask.resume()
//    }
//
//}
