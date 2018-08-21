//
//  FilterCameraViewController.swift
//  GPUIImageFilter
//
//  Created by Bao Nguyen on 8/21/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import GPUImage

class FilterCameraViewController: UIViewController {

    @IBOutlet weak var topCameraImageView: GPUImageView!
    
    fileprivate var stillCamera: GPUImageStillCamera?
    fileprivate var grayscaleFilter: GPUImageGrayscaleFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        configureCamera()
        configureFilter()
        configureImageView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stillCamera?.startCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stillCamera?.stopCapture()
    }

    fileprivate func initCommon() {
    }
    
    fileprivate func configureCamera() {
        stillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: .back)
        stillCamera?.outputImageOrientation = .portrait
    }
    
    fileprivate func configureFilter() {
        grayscaleFilter = GPUImageGrayscaleFilter()
    }
    
    fileprivate func configureImageView() {
        stillCamera?.addTarget(grayscaleFilter)
        grayscaleFilter?.addTarget(topCameraImageView)
        
    }

}

