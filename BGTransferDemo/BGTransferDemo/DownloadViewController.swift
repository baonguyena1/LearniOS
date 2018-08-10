//
//  DownloadViewController.swift
//  BGTransferDemo
//
//  Created by Bao Nguyen on 8/10/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var session: URLSession?
    fileprivate var arrFileDownloadData: [FileDownloadInfo] = [FileDownloadInfo]()
    fileprivate lazy var docDirectoryURL: URL? = {
        return FileManager.default.urls(for: .documentationDirectory
            , in: .userDomainMask).first
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFileDownloadDataArray()
        let sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "com.baon.backgroundTransfer")
        sessionConfiguration.httpMaximumConnectionsPerHost = 5
        self.session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    @IBAction func startAllDownloads(_ sender: UIButton) {
        
    }
    
    @IBAction func stopAllDownloads(_ sender: UIButton) {
        
    }
    
    @IBAction func initialAll(_ sender: UIBarButtonItem) {
        initializeFileDownloadDataArray()
        tableView.reloadData()
    }
    
    fileprivate func initializeFileDownloadDataArray() {
        arrFileDownloadData = []
        var fileDownloadInfo: FileDownloadInfo
        fileDownloadInfo = FileDownloadInfo(title: "iOS Programming Guide", source: "https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/iphoneappprogrammingguide.pdf")
        arrFileDownloadData.append(fileDownloadInfo)
        
        fileDownloadInfo = FileDownloadInfo(title: "Human Interface Guidelines", source: "https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/MobileHIG.pdf")
        arrFileDownloadData.append(fileDownloadInfo)
        
        fileDownloadInfo = FileDownloadInfo(title: "Networking Overview", source: "https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/NetworkingOverview.pdf")
        arrFileDownloadData.append(fileDownloadInfo)
        
        fileDownloadInfo = FileDownloadInfo(title: "AV Foundation", source: "https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/AVFoundationPG.pdf")
        arrFileDownloadData.append(fileDownloadInfo)
        
        fileDownloadInfo = FileDownloadInfo(title: "iPhone User Guide", source: "http://manuals.info.apple.com/MANUALS/1000/MA1565/en_US/iphone_user_guide.pdf")
        arrFileDownloadData.append(fileDownloadInfo)
    }

}

extension DownloadViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFileDownloadData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DownloadProgressCell
        let file = arrFileDownloadData[indexPath.row]
        cell.fileDownload = file
        
        cell.startPauseCompletionHandler = { [weak self] in
            
            guard let `self` = self else { return }
            if !file.isDownloading {
                if file.taskIdentifier == -1 {
                    let url = URL(string: file.downloadSource)
                    file.downloadTask = self.session?.downloadTask(with: url!)
                    file.downloadTask?.resume()
                    file.taskIdentifier = file.downloadTask!.taskIdentifier
                }
            } else {
                // The resume of a download task will be done here.
            }
            
            file.isDownloading = !file.isDownloading
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.stopCompletionHandler = { [weak self] in
            
            guard let `self` = self else { return }
            file.isDownloading = false
            file.taskIdentifier = -1
            file.downloadProgress = 0.0
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}

extension DownloadViewController: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let originalURL = downloadTask.originalRequest?.url!
        let destinationURL = documentDirectory.appendingPathComponent(originalURL!.lastPathComponent)
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            let index = getFileDownloadInfoIndexWithTaskIdentifier(downloadTask.taskIdentifier)
            let file = arrFileDownloadData[index]
            file.isDownloading = false
            file.downloadComplete = true
            file.taskIdentifier = -1
            file.downloadTask = nil
            OperationQueue.main.addOperation { [weak self] in
                
                guard let `self` = self else { return }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown {
            print("NSURLSessionTransferSizeUnknown")
            return
        }
        
        let index = getFileDownloadInfoIndexWithTaskIdentifier(downloadTask.taskIdentifier)
        let file = arrFileDownloadData[index]
        OperationQueue.main.addOperation { [weak self] in
            
            guard let `self` = self else { return }
            file.downloadProgress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            DispatchQueue.global().async {
                
                self.session?.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                    
                    if downloadTasks.count == 0 {
                        if appDelegate.backgroundTransferCompletionHandler != nil {
                            
                            let completionHanlder = appDelegate.backgroundTransferCompletionHandler
                            appDelegate.backgroundTransferCompletionHandler = nil
                            OperationQueue.main.addOperation({
                                
                                completionHanlder?()
                                let localNotification = UILocalNotification()
                                localNotification.alertBody = "All files have been downloaded!"
                                DispatchQueue.main.async {
                                    UIApplication.shared.presentLocalNotificationNow(localNotification)
                                    print("done")
                                }
                            })
                        }
                    }
                })
            }
            
        }
        
    }
    
    fileprivate func getFileDownloadInfoIndexWithTaskIdentifier(_ identifier: Int) -> Int {
        for i in 0..<arrFileDownloadData.count {
            let file = arrFileDownloadData[i]
            if file.taskIdentifier == identifier {
                return i
            }
        }
        return -1
    }
}

