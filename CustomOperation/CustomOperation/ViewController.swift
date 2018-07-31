//
//  ViewController.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

private var ProgressObserverContext = 0

class ViewController: UIViewController {
    
    fileprivate let overalProgressObservedKeys = [
        "fractionCompleted",
        "completedUnitCount",
        "totalUnitCount",
        "cancelled",
        "paused"
    ]
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    fileprivate var photos: [PhotoRecord] = []
    @IBOutlet weak var minValueButton: UIBarButtonItem!
    @IBOutlet weak var maxValueButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    fileprivate lazy var photoDictionary: [String: String] = {
        let path = Bundle.main.path(forResource: "ClassicPhotosDictionary", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        return data as! [String: String]
    }()
    
    fileprivate var progress: Progress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photos = self.photoDictionary.map { (name, value) -> PhotoRecord in
            return PhotoRecord(urlString: value)
        }
        self.startProgress()
        for photo in self.photos {
            self.startDownloader(photo)
        }
        self.photoCollectionView.reloadData()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        if value == QueueManager.shared.numberOperation {
            return
        }
        print("number of operation", value)
        QueueManager.shared.queue.maxConcurrentOperationCount = value
    }
    
    fileprivate func startProgress() {
        self.progress = Progress(totalUnitCount: Int64(self.photos.count))
        for keyPath in overalProgressObservedKeys {
            self.progress.addObserver(self, forKeyPath: keyPath, options: [], context: &ProgressObserverContext)
        }
        self.updateProgressView()
    }
    
    fileprivate func startDownloader(_ photo: PhotoRecord) {
        if photo.state == .new {
            let photoDownloader = DownloaderOperation(photo)
            QueueManager.shared.queue.addOperation(photoDownloader)
            self.progress.addChild(photoDownloader.progress, withPendingUnitCount: 1)
            
            photoDownloader.completionBlock = {
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadData()
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ProgressObserverContext {
            OperationQueue.main.addOperation {
                self.updateProgressView()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func updateProgressView() {
        guard let progress = self.progress else {
            return
        }
        progressView.progress = Float(progress.fractionCompleted)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        let photo = self.photos[indexPath.row]
        cell.photo = photo
        
//        switch photo.state {
//        case .new:
//        self.startDownloader(photo, at: indexPath)
//        default: break
//        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2.0 - 10/2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
