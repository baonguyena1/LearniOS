//
//  DownloaderOperation.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class DownloaderOperation: Operation {
    
    var photo: PhotoRecord
    
    init(_ photo: PhotoRecord) {
        self.photo = photo
    }
    
    override func main() {
        if self.isCancelled {
            photo.state = .failed
            return
        }
        let url = URL(string: photo.urlString)
        if url == nil {
            photo.state = .failed
            return
        }
        let imageData = try? Data(contentsOf: url!)

        if self.isCancelled {
            photo.state = .failed
            return
        }
        if imageData != nil {
            let image = UIImage(data: imageData!)
            photo.state = .downloaded
            photo.image = image
        } else {
            photo.state = .failed
        }
    }
    
}
