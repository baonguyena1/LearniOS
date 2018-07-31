//
//  PhotoRecord.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

@objc enum PhotoState: Int, CustomStringConvertible {
    case new, queueing, downloading, downloaded, failed
    
    var description: String {
        switch self {
        case .new:
            return "new"
        case .queueing:
            return "queueing"
        case .downloading:
            return "downloading"
        case .downloaded:
            return "downloaded"
        case .failed:
            return "failed"
        }
    }
}

class PhotoRecord: NSObject {
    // Marked "dynamic" so it is KVO observable.
    let urlString: String
    @objc dynamic var image = UIImage(named: "Placeholder")
    @objc dynamic var state = PhotoState.new
    @objc dynamic var downloader: PhotoDownload
    
    init(urlString: String) {
        self.urlString = urlString
        downloader = PhotoDownload(urlString)
    }
}
