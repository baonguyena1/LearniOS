//
//  CircleViewController.swift
//  RX
//
//  Created by Bao Nguyen on 8/23/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ChameleonFramework

class CircleViewController: UIViewController {
    
    var circleView: UIView!
    var circleViewModel: CircleViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.circleView = UIView(frame: CGRect(x: view.frame.width/2 - 50, y: view.frame.height/2 - 50, width: 100, height: 100))
        self.circleView.backgroundColor = .green
        self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
        self.circleView.layer.masksToBounds = true
        view.addSubview(self.circleView)
        
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        self.circleView.addGestureRecognizer(panGuesture)
        
        self.circleViewModel = CircleViewModel()
        self.circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: self.circleViewModel.centerVariable)
            .disposed(by: disposeBag)
        
        self.circleViewModel.backgroundColorObservable
            .subscribe(onNext: { [weak self] (color) in
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self?.circleView.backgroundColor = color
                    
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: color)
                    if viewBackgroundColor != color {
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                })
        })
        .disposed(by: disposeBag)
    }

    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self.view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}
