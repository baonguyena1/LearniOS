//
//  TabSwipeNavigation.swift
//  TabSwipeControl
//
//  Created by Bao Nguyen on 7/26/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

@objc public protocol TabSwipeNagivationDelegate: class {
    
    @objc func tabSwipeNavigation(_ tabSwipeNagivation: TabSwipeNavigation, controllerAt index: Int) -> UIViewController
}

open class TabSwipeNavigation: UIViewController {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    fileprivate var selectedIndex: Int!
    fileprivate var currentTabIndex: Int!
    fileprivate var toolbarHight: NSLayoutConstraint!
    fileprivate var toolbar: UIToolbar!
    fileprivate var tabSwipeScrollView: TabSwipeScrollView!

    // PageViewControler
    fileprivate var pageViewControler: UIPageViewController!
    fileprivate var viewControlers: [Int: UIViewController]!
    fileprivate var pageScrollView: UIScrollView!

    // Delegate
    fileprivate weak var delegete: TabSwipeNagivationDelegate?
    
    // MARK: - Computed properties
    fileprivate var tabSwipeSegmentControl: TabSwipeSegmentControl! {
        return self.tabSwipeScrollView.tabSwipeSegmentControl
    }
    
    fileprivate var isRTL: Bool {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.view.semanticContentAttribute) == .rightToLeft
        }
        return false
    }
    
    fileprivate var directionAnimation: UIPageViewControllerNavigationDirection {
        if self.isRTL {
            return .reverse
        }
        return .forward
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageViewControler.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.pageViewControler.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pageViewControler.viewWillDisappear(animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pageViewControler.viewDidDisappear(animated)
    }
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience public init(_ items: [Any]?, delegate target: TabSwipeNagivationDelegate?) {
        self.init()
        self.selectedIndex = 0
        self.delegete = target
        self.viewControlers = [:]
        
        self.createSegmentedToolbar()
        self.createTabSwipeScrollView(with: items)
        self.addToolbarIntoSupperView()
        self.createPageViewControler()
        
        self.loadFirstViewControler()
    }
    
    // MARK: - Public function
    
    open func insertIntoRootViewController(_ rootViewController: UIViewController) {
        self.willMove(toParentViewController: rootViewController)
        rootViewController.addChildViewController(self)
        rootViewController.view.addSubview(self.view)
        self.didMove(toParentViewController: rootViewController)
        
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        var topLayoutGuide: CGFloat = 0.0
        var bottomLayoutGuide: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            topLayoutGuide = self.view.safeAreaInsets.top
            bottomLayoutGuide = self.view.safeAreaInsets.bottom
        } else {
            topLayoutGuide = self.topLayoutGuide.length
            bottomLayoutGuide = self.bottomLayoutGuide.length
        }
        
        let metrics: [String: Any] = [
            "topLayoutGuide": topLayoutGuide,
            "bottomLayoutGuide": bottomLayoutGuide
        ]
        
        let views: [String: Any] = [
            "tapSwipeNavigation": self.view
        ]
        
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topLayoutGuide-[tapSwipeNavigation]-bottomLayoutGuide-|",
                                                                              options: .init(rawValue: 0),
                                                                              metrics: metrics,
                                                                              views: views))
        rootViewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tapSwipeNavigation]|",
                                                                              options: .init(rawValue: 0),
                                                                              metrics: metrics,
                                                                              views: views))
    }

    // MARK: Private function
    
    fileprivate func createSegmentedToolbar() {
        self.setToolbar(UIToolbar())
    }
    
    fileprivate func setToolbar(_ toolbar: UIToolbar) {
        self.toolbar = toolbar
        self.toolbar.delegate = self
    }

    fileprivate func createTabSwipeScrollView(with items: [Any]?) {
        self.tabSwipeScrollView = TabSwipeScrollView(items)
        self.tabSwipeScrollView.clipsToBounds = false
        self.toolbar.addSubview(self.tabSwipeScrollView)
        
        self.tabSwipeSegmentControl.addTarget(self, action: #selector(segmentTapped(_:)), for: .valueChanged)
        
        let position: UIBarPosition = .bottom
        if position == .top || position == .topAttached {
            self.tabSwipeSegmentControl.indicatorPosition = .top
        } else {
            self.tabSwipeSegmentControl.indicatorPosition = .bottom
        }
        
        self.tabSwipeScrollView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = [
            "tabSwipeScrollView": self.tabSwipeScrollView
        ]
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tabSwipeScrollView]|",
                                                                   options: .init(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views))
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabSwipeScrollView]|",
                                                                   options: .init(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views))

    }
    
    fileprivate func addToolbarIntoSupperView() {
        self.view.addSubview(self.toolbar)
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = [
            "toolbar": self.toolbar
        ]
        let position: UIBarPosition = .top
        var verticalFormat = "V:[toolbar]|"
        if position == .top || position == .topAttached {
            verticalFormat = "V:|[toolbar]"
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalFormat,
                                                                options: .init(rawValue: 0),
                                                                metrics: nil,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolbar]|",
                                                                   options: .init(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views))
        self.toolbarHight = NSLayoutConstraint.init(item: self.toolbar,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 44)
        self.view.addConstraint(self.toolbarHight)
    }
    
    fileprivate func createPageViewControler() {
        self.pageViewControler = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        self.pageViewControler.dataSource = self
        
        for subview in self.pageViewControler.view.subviews {
            if subview is UIScrollView {
                self.pageScrollView = subview as! UIScrollView
                self.pageScrollView.delegate = self
                self.pageScrollView.panGestureRecognizer.maximumNumberOfTouches = 1
            }
        }
        
        let isToolbarChildView = self.view.subviews.contains(self.toolbar)
        self.pageViewControler.willMove(toParentViewController: self)
        self.addChildViewController(self.pageViewControler)
        if isToolbarChildView {
            self.view.insertSubview(self.pageViewControler.view, belowSubview: self.toolbar)
        } else {
            self.view.addSubview(self.pageViewControler.view)
        }
        self.pageViewControler.didMove(toParentViewController: self)
        
        self.pageViewControler.view.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = [
            "pageViewControler": self.pageViewControler.view,
            "toolbar": self.toolbar
        ]
        let position: UIBarPosition = .top
        var verticalFormatConstraint = "V:|[pageViewControler]|"
        if isToolbarChildView {
            if position == .top || position == .topAttached {
                verticalFormatConstraint = "V:[toolbar][pageViewControler]|"
            } else if position == .bottom {
                verticalFormatConstraint = "V:|[pageViewControler][toolbar]"
            }
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalFormatConstraint,
                                                                options: .init(rawValue: 0),
                                                                metrics: nil,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageViewControler]|",
                                                                options: .init(rawValue: 0),
                                                                metrics: nil,
                                                                views: views))
        
    }
    
    fileprivate func loadFirstViewControler() {
        let viewControler = self.viewControler(at: self.selectedIndex)
        
        let completionBlock: ((Bool) -> Void)? = { (finish: Bool) in
            print("completion")
        }
        self.pageViewControler.setViewControllers([viewControler],
                                                  direction: self.directionAnimation,
                                                  animated: true,
                                                  completion: completionBlock)
    }
    
    fileprivate func viewControler(at index: Int) -> UIViewController {
        var viewController = self.viewControlers[index]
        if viewController == nil {
            viewController = self.delegete?.tabSwipeNavigation(self, controllerAt: index)
            self.viewControlers[index] = viewController!
        }
        return viewController!
    }
    
    fileprivate func move(to index: Int, animation: Bool) {
        let viewController = self.viewControler(at: index)
        var animateDirection: UIPageViewControllerNavigationDirection = index > self.selectedIndex ? .forward : .reverse
        if self.isRTL {
            if animateDirection == .forward {
                animateDirection = .reverse
            } else {
                animateDirection = .forward
            }
        }
        
        self.tabSwipeSegmentControl.isUserInteractionEnabled = false
        self.pageViewControler.view.isUserInteractionEnabled = false
        let animateCompletionBlock: ((Bool) -> Void)? = { [unowned self] finish in
            self.selectedIndex = index
            self.tabSwipeSegmentControl.isUserInteractionEnabled = true
            self.pageViewControler.view.isUserInteractionEnabled = true
        }
        self.pageViewControler.setViewControllers([viewController],
                                                  direction: animateDirection,
                                                  animated: true,
                                                  completion: animateCompletionBlock)
    }
    
    // MARK: - Actions
    @objc fileprivate func segmentTapped(_ segment: UISegmentedControl) {
        self.move(to: segment.selectedSegmentIndex, animation: true)
    }
    
}

extension TabSwipeNavigation: UIToolbarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .bottom
    }
}

extension TabSwipeNavigation: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index: Int = (self.viewControlers as NSDictionary).allKeys(for: viewController).first as! Int
        index = index + 1
        if index < self.tabSwipeSegmentControl.numberOfSegments {
            return self.viewControler(at: index)
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = (self.viewControlers as NSDictionary).allKeys(for: viewController).first as! Int
        index = index - 1
        if index >= 0 {
            return self.viewControler(at: index)
        }
        return nil
    }
    
    
}

extension TabSwipeNavigation: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tabSwipeSegmentControl.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tabSwipeSegmentControl.isUserInteractionEnabled = true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
