//
//  CustomHeaderView.swift
//  StickyHeaderView
//
//  Created by Bao Nguyen on 8/20/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var imageView: UIImageView!
    var colorView: UIView!
    var bgColor = UIColor(red: 235/255.0, green: 96/255.0, blue: 91/255.0, alpha: 1.0)
    var titleLabel = UILabel()
    var articleIcon: UIImageView!
    
    init(frame: CGRect, title: String) {
        self.titleLabel.text = title.uppercased()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorView)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        imageView.image = UIImage(named: "testBackground")
        imageView.contentMode = .scaleAspectFill
        
        colorView.backgroundColor = bgColor
        colorView.alpha = 0.6
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let titlesConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28)
        ]
        NSLayoutConstraint.activate(titlesConstraints)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
        
        articleIcon = UIImageView()
        articleIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(articleIcon)
        
        let imageConstraints = [
            articleIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            articleIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 6),
            articleIcon.widthAnchor.constraint(equalToConstant: 40),
            articleIcon.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        articleIcon.image = UIImage(named: "article")
    }
    
    func decrementColorAlpha(_ offset: CGFloat) {
        if colorView.alpha <= 1 {
            let alphaOffset = (offset/500)/85
            colorView.alpha = colorView.alpha + alphaOffset
        }
    }
    
    func decrementArticleAlpha(_ offset: CGFloat) {
        if articleIcon.alpha >= 0 {
            let alphaOffset = max((offset - 65)/85.0, 0)
            articleIcon.alpha = alphaOffset
        }
    }
    
    func incrementColorAlpha(_ offset: CGFloat) {
        if colorView.alpha >= 0.6 {
            let alphaOffset = (offset/200)/85
            self.colorView.alpha -= alphaOffset
        }
    }
    
    func incrementArticleAlpha(_ offset: CGFloat) {
        if articleIcon.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            self.articleIcon.alpha = alphaOffset
        }
    }
}
