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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var importButton: UIBarButtonItem!
    @IBOutlet var pauseButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var resetButton: UIBarButtonItem!
    @IBOutlet var resumeButton: UIBarButtonItem!
    
    fileprivate var photoManager: PhotoManager? = nil {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var progressView: UIProgressView!
    
    fileprivate lazy var photoDictionary: [String: String] = {
        let path = Bundle.main.path(forResource: "ClassicPhotosDictionary", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        return data as! [String: String]
    }()
    
    fileprivate var progress: Progress! {
        willSet {
            if let formerProgress = progress {
                
                for keyPath in overalProgressObservedKeys {
                    formerProgress.removeObserver(self, forKeyPath: keyPath, context: &ProgressObserverContext)
                }
            }
        }
        
        didSet {
            if let newProgress = progress {
                
                for keyPath in overalProgressObservedKeys {
                    newProgress.addObserver(self, forKeyPath: keyPath, options: [], context: &ProgressObserverContext)
                }
            }
            updateProgressView()
            updateToolbar()
        }
    }
    
    fileprivate var progressIsFinished: Bool {
        let completed = progress.completedUnitCount
        let total = progress.totalUnitCount
        return (completed >= total && total > 0 && completed > 0) || (completed > 0 && total == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateToolbar()
        initialData()
    }
    
    // MARK: - Actions
    @IBAction func valueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        if value == QueueManager.shared.numberOperation {
            return
        }
        QueueManager.shared.queue.maxConcurrentOperationCount = value
    }
    
    @IBAction func importTapped(_ sender: UIBarButtonItem) {
        initialData()
        progress = photoManager?.importProgress()
    }
    
    @IBAction func pauseTapped(_ sender: UIBarButtonItem) {
        progress.pause()
        QueueManager.shared.queue.isSuspended = true
    }
    
    @IBAction func resumeTapped(_ sender: UIBarButtonItem) {
        progress.resume()
        QueueManager.shared.queue.isSuspended = false
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        progress.cancel()
        QueueManager.shared.queue.cancelAllOperations() 
    }
    
    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        photoManager?.reset()
        progress = nil
    }
    
    fileprivate func initialData() {
        let photos = self.photoDictionary.map { (name, value) -> PhotoRecord in
            return PhotoRecord(urlString: value)
        }
        photoManager = PhotoManager(photos)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &ProgressObserverContext {
            OperationQueue.main.addOperation {
                self.updateProgressView()
                self.updateToolbar()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func updateProgressView() {
        guard let progress = self.progress else {
            progressView.progress = 0.0
            descriptionLabel.text = ""
            return
        }
        progressView.progress = Float(progress.fractionCompleted)
        descriptionLabel.text = progress.localizedAdditionalDescription
//        print(progress.localizedAdditionalDescription, progress.localizedDescription)
    }
    
    fileprivate func updateToolbar() {
        var items = [UIBarButtonItem]()
        if let progress = progress {
            
            if progressIsFinished {
                items.append(resetButton)
            } else {
                items.append(cancelButton)
                if progress.isPaused {
                    items.append(resumeButton)
                } else {
                    items.append(pauseButton)
                }
            }
            
        } else {
            items = [importButton]
        }
        
        toolbar.setItems(items, animated: true)
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
