//
//  CampaignDetailViewerCollectionViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 26/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class CampaignDetailViewerCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet var viewerScrollView: UIScrollView!
    @IBOutlet var viewerPlayButton: UIButton!
    @IBOutlet var viewerImageView: UIImageView!
    
    override func awakeFromNib() {
        self.viewerScrollView.minimumZoomScale = 0.5
        self.viewerScrollView.maximumZoomScale = 3.5
        self.viewerScrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.viewerImageView
    }
}
