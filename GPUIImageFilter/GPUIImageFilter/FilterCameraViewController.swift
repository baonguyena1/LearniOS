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
    @IBOutlet weak var bottomCameraImageView: GPUImageView!
    
    fileprivate var stillCamera: GPUImageStillCamera?
    fileprivate var grayscaleFilter: GPUImageGrayscaleFilter?
    fileprivate var amatorkaFilter: GPUImageAmatorkaFilter?
//    fileprivate var maskLayer: CALayer?
    fileprivate var maskLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        configureCamera()
        configureFilter()
        configureImageView()
        initMask()
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
        amatorkaFilter = GPUImageAmatorkaFilter()
    }
    
    fileprivate func configureImageView() {
        stillCamera?.addTarget(grayscaleFilter)
        grayscaleFilter?.addTarget(topCameraImageView)
        
        stillCamera?.addTarget(amatorkaFilter)
        amatorkaFilter?.addTarget(bottomCameraImageView)
    }
    
    fileprivate func initMask() {
        if maskLayer == nil {
//            maskLayer = CALayer()
//            maskLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height)
//            maskLayer?.backgroundColor = UIColor.white.cgColor
//            topCameraImageView.layer.mask = maskLayer
//            topCameraImageView.layer.masksToBounds = true
            
            let width = view.bounds.width
            let height = view.bounds.height
            maskLayer = CAShapeLayer()
            maskLayer?.frame = CGRect(x: 0, y: 0, width: width * 2, height: height)
            maskLayer?.backgroundColor = UIColor.clear.cgColor
            
            let triagle = UIBezierPath()
            triagle.move(to: .zero)
            triagle.addLine(to: CGPoint(x: width, y: 0))
            triagle.addLine(to: CGPoint(x: width * 2, y: height))
            triagle.addLine(to: CGPoint(x: 0, y: height))
            triagle.addLine(to: .zero)
            
            maskLayer?.path = triagle.cgPath
            maskLayer?.fillColor = UIColor.white.cgColor
            
            maskLayer?.anchorPoint = .zero
            maskLayer?.position = CGPoint(x: -width, y: 0)
            
            topCameraImageView.layer.mask = maskLayer
            topCameraImageView.layer.masksToBounds = true
        }
    }

}

