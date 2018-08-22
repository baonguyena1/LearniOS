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
    fileprivate var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
        configureCamera()
        configureFilter()
        configureImageView()
        initMask()
        initGesture()
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
//            maskLayer?.position = CGPoint(x: -width, y: 0)
            maskLayer?.position = CGPoint(x: -width * 2, y: 0)
            
            topCameraImageView.layer.mask = maskLayer
            topCameraImageView.layer.masksToBounds = true
        }
    }
    
    fileprivate func initGesture() {
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        view.addGestureRecognizer(panGesture)
        self.topCameraImageView.isUserInteractionEnabled = true
        self.bottomCameraImageView.isUserInteractionEnabled = true
    }

    @objc fileprivate func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        switch gesture.state {
        case .began, .changed:
            
            let percent = location.x / self.view.bounds.width
            self.setPositionWithoutImplitcitAnimationAtTransfrom(transform: CATransform3DMakeTranslation(self.view.bounds.width * 2 * percent, 0, 0))
        case .cancelled, .failed, .ended:
            
            let transform = maskLayer?.transform
            if transform!.m41 > self.view.bounds.width {
                self.aminationMaskLayerToTransfrom(finalTransfrom: CATransform3DMakeTranslation(self.view.bounds.width * 2, 0, 0))
            } else {
                self.aminationMaskLayerToTransfrom(finalTransfrom: CATransform3DMakeTranslation(0, 0, 0))
            }
        default:
            break
        }
    }
    
    fileprivate func aminationMaskLayerToTransfrom(finalTransfrom: CATransform3D) {
        let transtaleAnimation = CABasicAnimation(keyPath: "transform")
        transtaleAnimation.toValue = NSValue(caTransform3D: finalTransfrom)
        transtaleAnimation.duration = 0.3
        transtaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let blockDelegate = FeBasicAnimationBlock()
        transtaleAnimation.delegate = blockDelegate as CAAnimationDelegate
        blockDelegate.blockDidStart = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.panGesture.isEnabled = false
        }
        
        blockDelegate.blockDidStop = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.panGesture.isEnabled = true
            self.maskLayer?.removeAllAnimations()
            self.setPositionWithoutImplitcitAnimationAtTransfrom(transform: finalTransfrom)
        }
        maskLayer?.add(transtaleAnimation, forKey: "animation")
    }
    
    fileprivate func setPositionWithoutImplitcitAnimationAtTransfrom(transform: CATransform3D) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer?.transform = transform
        CATransaction.commit()
    }
}

