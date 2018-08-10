//
//  FileDownloadInfo.swift
//  BGTransferDemo
//
//  Created by Bao Nguyen on 8/10/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class FileDownloadInfo: NSObject {
    
    var fileTitle: String
    var downloadSource: String
    var downloadTask: URLSessionDownloadTask?
    var taskResumeData: Data?
    var downloadProgress: Double
    var isDownloading: Bool
    var downloadComplete: Bool
    var taskIdentifier: Int

    override init() {
        fileTitle = ""
        downloadSource = ""
        downloadProgress = 0.0
        isDownloading = false
        downloadComplete = false
        taskIdentifier = -1
    }
    
    init(title: String, source: String) {
        fileTitle = title
        downloadSource = source
        downloadProgress = 0.0
        isDownloading = false
        downloadComplete = false
        taskIdentifier = -1
    }
}
