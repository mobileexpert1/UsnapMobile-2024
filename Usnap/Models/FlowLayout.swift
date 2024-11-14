//
//  MaterialSelection.swift
//  NextStone
//
//  Created by Mobile on 02/04/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class TwoRowsLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
        footerReferenceSize = CGSize(width: 250, height: 250)
    }
    
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 2
            
            let itemWidth = (self.collectionView!.frame.width - 10) / numberOfColumns
            return CGSize(width: itemWidth, height: 113)
        }
    }
}



// popup collection view flow layout
class HorizontalFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .horizontal
    }
    
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let itemWidth = (self.collectionView!.frame.width - 1)
            return CGSize(width: itemWidth, height: 263)
        }
    }
    
}



