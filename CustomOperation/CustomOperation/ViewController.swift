//
//  ViewController.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    fileprivate var photos: [PhotoRecord] = []
    
    fileprivate lazy var photoDictionary: [String: String] = {
        let path = Bundle.main.path(forResource: "ClassicPhotosDictionary", ofType: "plist")
        let data = NSDictionary(contentsOfFile: path!)
        return data as! [String: String]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photos = self.photoDictionary.map { (name, value) -> PhotoRecord in
            return PhotoRecord(urlString: value)
        }
    }

    fileprivate func startDownloader(_ photo: PhotoRecord, at indexPath: IndexPath) {
        if photo.state == .new {
            let photoDownloader = DownloaderOperation(photo)
            QueueManager.shared.queue.addOperation(photoDownloader)
            
            photoDownloader.completionBlock = {
                
                DispatchQueue.main.async {
                    self.photoCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
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
        cell.image.image = photo.image
        cell.status.text = photo.state.description
        
        switch photo.state {
        case .new:
        self.startDownloader(photo, at: indexPath)
        case .downloaded:
            cell.image.image = photo.image
        case .failed:
            cell.image.image = UIImage(named: "Failed")
        default: break
        }
        
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
