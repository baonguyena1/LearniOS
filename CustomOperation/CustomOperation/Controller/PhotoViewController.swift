//
//  ViewController.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

private var ProgressObserverContext = 0

class PhotoViewController: UIViewController {
    
    fileprivate let overalProgressObservedKeys = [
        "fractionCompleted",
        "completedUnitCount",
        "totalUnitCount",
        "cancelled",
        "paused"
    ]
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    fileprivate var photoManager: PhotoManager? = nil {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    @IBOutlet weak var minValueButton: UIBarButtonItem!
    @IBOutlet weak var maxValueButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    fileprivate lazy var photoDictionary: [String: String] = {
        let path = Bundle.main.path(forResource: "ClassicPhotosDictionary", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        return data as! [String: String]
    }()
    
    fileprivate var progress: Progress! {
        willSet {
            guard let formerProgress = progress else {
                return
            }
            for keyPath in overalProgressObservedKeys {
                formerProgress.removeObserver(self, forKeyPath: keyPath, context: &ProgressObserverContext)
            }
        }
        
        didSet {
            guard let newProgress = progress else {
                return
            }
            for keyPath in overalProgressObservedKeys {
                newProgress.addObserver(self, forKeyPath: keyPath, options: [], context: &ProgressObserverContext)
            }
        }
    }
    
    fileprivate var progressIsFinished: Bool {
        let completed = progress.completedUnitCount
        let total = progress.totalUnitCount
        return (completed >= total && total > 0 && completed > 0) || (completed > 0 && total == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startImportProgress()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        if value == QueueManager.shared.numberOperation {
            return
        }
        QueueManager.shared.queue.maxConcurrentOperationCount = value
    }
    
    fileprivate func startImportProgress() {
        let photos = self.photoDictionary.map { (name, value) -> PhotoRecord in
            return PhotoRecord(urlString: value)
        }
        photoManager = PhotoManager(photos)
        progress = photoManager?.importProgress()
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

extension PhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoManager == nil ? 0 : self.photoManager!.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        let photo = photoManager!.photo(at: indexPath.row)
        cell.photo = photo
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
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
