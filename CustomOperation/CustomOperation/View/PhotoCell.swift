//
//  PhotoCell.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

private var photoCollectionViewCellObservationContext = 0

class PhotoCell: UICollectionViewCell {
    
    fileprivate let imageKeyPath = "image"
    fileprivate let stateKeyPath = "state"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var photo: PhotoRecord? {
        willSet {
            guard let formerPhoto = photo else {
                return
            }
            formerPhoto.removeObserver(self, forKeyPath: imageKeyPath, context: &photoCollectionViewCellObservationContext)
            formerPhoto.removeObserver(self, forKeyPath: stateKeyPath, context: &photoCollectionViewCellObservationContext)
        }
        didSet {
            guard let newPhoto = photo else {
                return
            }
            newPhoto.addObserver(self, forKeyPath: imageKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
            newPhoto.addObserver(self, forKeyPath: stateKeyPath, options: [], context: &photoCollectionViewCellObservationContext)
            updateImageView()
            updateState()
            updateProgressView()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &photoCollectionViewCellObservationContext {
            OperationQueue.main.addOperation { [weak self] in

                guard let strongSelf = self else { return }
                if keyPath == strongSelf.imageKeyPath {
                    strongSelf.updateImageView()
                } else if keyPath == strongSelf.stateKeyPath {
                    strongSelf.updateState()
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func updateProgressView() {
        
    }
    
    fileprivate func updateState() {
        self.status.text = photo?.state.description
    }
    
    fileprivate func updateImageView() {
        self.image.image = photo?.image
    }
    
}
