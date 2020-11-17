//
//  ImagesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 16.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController {
    
    //CollectionView values
    let itemsPerRow: CGFloat = 3
    let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private let cellIdentifier = String(describing: ImageCell.self)
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
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
    
}

extension ImagesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        
        cell.configure(with: .init(image: UIImage(named: "dayTheme")), with: .classic)
        
        return cell
    }
    
}

extension ImagesViewController: UICollectionViewDelegate {
    
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
