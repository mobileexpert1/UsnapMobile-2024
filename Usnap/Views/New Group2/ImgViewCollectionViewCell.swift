//
//  ImgViewCollectionViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 25/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class ImgViewCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet var imgScroll: UIScrollView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var viewerPlayButton: UIButton!
    
    override func awakeFromNib() {
        self.imgScroll.minimumZoomScale = 0.5
        self.imgScroll.maximumZoomScale = 3.5
        self.imgScroll.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
}
