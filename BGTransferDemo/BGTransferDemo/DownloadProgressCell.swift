//
//  DownloadProgressCell.swift
//  BGTransferDemo
//
//  Created by Bao Nguyen on 8/10/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class DownloadProgressCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var progressView: UIProgressView!
    
    var startPauseCompletionHandler, stopCompletionHandler: (() -> Void)?
    
    fileprivate lazy var startButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startPauseButtonTapped(_:)))
        return button
    }()
    
    fileprivate lazy var pauseButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(startPauseButtonTapped(_:)))
        return button
    }()
    
    fileprivate lazy var stopButton: UIBarButtonItem! = {
        let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopButtonTapped(_:)))
        return button
    }()
    
    var fileDownload: FileDownloadInfo! {
        didSet {
            titleLabel.text = fileDownload.fileTitle
            
            if !fileDownload.isDownloading {
                
                progressView.isHidden = true
                stopButton.isEnabled = false
                let hideControls = fileDownload.downloadComplete ? true : false
                var items = [UIBarButtonItem]()
                if !hideControls {
                    items = [startButton, stopButton]
                }
                toolBar.setItems(items, animated: true)
                readyLabel.isHidden = !hideControls
            } else {
                
                progressView.isHidden = false
                stopButton.isEnabled = true
                progressView.progress = Float(fileDownload.downloadProgress)
                
                let items: [UIBarButtonItem] = [pauseButton, stopButton]
                toolBar.setItems(items, animated: true)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func startPauseButtonTapped(_ sender: UIBarButtonItem) {
        startPauseCompletionHandler?()
    }
    
    
    @objc func stopButtonTapped(_ sender: UIBarButtonItem) {
        stopCompletionHandler?()
    }
    
    
}
