//
//  PhotoManager.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

class PhotoManager {
    fileprivate let photos: [PhotoRecord]
    
    var numberOfItem: Int {
        return photos.count
    }
    
    func photo(at index: Int) -> PhotoRecord? {
        if index < 0 || index > photos.count - 1 {
            return nil
        }
        return photos[index]
    }
    
    init(_ photoRecords: [PhotoRecord]) {
        photos = photoRecords
    }
    
    func importProgress(_ completion: (() -> Void)? = nil) -> Progress {
        let progress = Progress(totalUnitCount: Int64(self.photos.count))
        for photo in photos {
            let downloadOperation = DownloaderOperation(photo)
            downloadOperation.completionBlock = completion
            progress.addChild(downloadOperation.progress, withPendingUnitCount: 1)
            QueueManager.shared.addOperation(downloadOperation)
        }
        return progress
    }
}
