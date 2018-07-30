//
//  PhotoCell.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var photo: PhotoRecord! {
        didSet {
            switch photo.state {
            case .new, .downloading:
                indicator.startAnimating()
            default:
                indicator.stopAnimating()
            }
            self.image.image = photo.image
            self.status.text = photo.state.description
            if photo.state == .failed {
                self.image.image = UIImage(named: "Failed")
            }
        }
    }
    
}
