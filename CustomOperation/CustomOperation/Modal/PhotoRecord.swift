//
//  PhotoRecord.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

enum PhotoState {
    case new, downloading, downloaded, failed
    
    var description: String {
        switch self {
        case .new:
            return "new"
        case .downloading:
            return "downloading"
        case .downloaded:
            return "downloaded"
        case .failed:
            return "failed"
        }
    }
}

class PhotoRecord {
    let urlString: String
    var image = UIImage(named: "Placeholder")
    var state = PhotoState.new
    
    init(urlString: String) {
        self.urlString = urlString
    }
}
