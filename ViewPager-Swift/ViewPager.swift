//
//  ViewPager.swift
//  ViewPager-Swift
//
//  Created by Nishan Niraula on 4/11/19.
//  Copyright © 2019 Nishan. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewPagerDataSource: class {
    
    /// Number of pages to be displayed
    func numberOfPages() -> Int
    
    /// ViewController for required page position
    func viewControllerAtPosition(position:Int) -> UIViewController
    
    /// Tab structure of the pages
    func tabsForPages() -> [ViewPagerTab]
    
    /// UIViewController which is to be displayed at first. Default is 0
    func startViewPagerAtIndex()->Int
}

public protocol ViewPagerDelegate: class {
    
    func willMoveToControllerAtIndex(index:Int)
    func didMoveToControllerAtIndex(index:Int)
}

class ViewPager: NSObject {
    
    public weak var dataSource:ViewPagerDataSource?
    public weak var delegate:ViewPagerDelegate?
    
    fileprivate var controller: UIViewController
    fileprivate var view: UIView
    
    fileprivate var tabContainer = UIScrollView()
    fileprivate var tabIndicator = UIView()
    fileprivate var pageController: UIPageViewController?
    
    fileprivate var tabsList = [ViewPagerTab]()
    fileprivate var tabsViewList = [ViewPagerTabView]()
    
    fileprivate var options = ViewPagerOptions()
    fileprivate var currentPageIndex = 0
    fileprivate var isIndicatorAdded = false
    
    
    // MARK:- Public Helpers
    init(viewController: UIViewController, containerView: UIView? = nil) {
        self.controller = viewController
        self.view = containerView ?? viewController.view
    }
    
    public func setOptions(options: ViewPagerOptions) {
        self.options = options
    }
    
    public func setDataSource(dataSource: ViewPagerDataSource) {
        self.dataSource = dataSource
    }
    
    public func setDelegate(delegate: ViewPagerDelegate?) {
        self.delegate = delegate
    }
    
    public func build() {
        setupTabContainerView()
        setupPageViewController()
    }
    
    // MARK:- Private Helpers
    fileprivate func setupTabContainerView() {
        
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabContainer)
        
        tabContainer.backgroundColor = UIColor.groupTableViewBackground
        tabContainer.isScrollEnabled = true
        tabContainer.showsVerticalScrollIndicator = false
        tabContainer.showsHorizontalScrollIndicator = false
        
        // Constraint
        tabContainer.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
        tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            tabContainer.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        } else {
            let marginGuide = view.layoutMarginsGuide
            tabContainer.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        }
        
        // Adding Gesture
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewPagerController.tabContainerTapped(_:)))
        tabContainer.addGestureRecognizer(tabViewTapGesture)
    }
    
    func setupPageViewController() {
        
        let pageController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: .horizontal, options: nil)
        
        self.controller.addChild(pageController)
        pageController.view.setupForAutolayout(inView: view)
        pageController.didMove(toParent: controller)
        self.pageController = pageController
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        self.pageController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.pageController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.pageController?.view.topAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
        self.pageController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        guard let viewPagerDataSource = dataSource else {
            fatalError("ViewPagerDataSource not set")
        }
        
        self.currentPageIndex = viewPagerDataSource.startViewPagerAtIndex()
        if let firstPageController = getPageItemViewController(atIndex: self.currentPageIndex) {
            
            self.pageController?.setViewControllers([firstPageController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    /// Returns UIViewController for page at provided index.
    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
        
        guard let viewPagerSource = dataSource, index >= 0 && index < viewPagerSource.numberOfPages() else {
            return nil
        }
        
        let pageItemViewController = viewPagerSource.viewControllerAtPosition(position: index)
        pageItemViewController.view.tag = index
        
        return pageItemViewController
    }
    
    
    // MARK:- Actions
    @objc func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tabContainer)
        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
        
        let tabViewIndex = tabViewTapped?.tag
        
        if tabViewIndex != currentPageIndex {
            
            //displayViewController(atIndex: tabViewIndex ?? 0)
        }
    }
}

extension ViewPager: UIPageViewControllerDataSource {
    
    /* ViewController the user will navigate to in backward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let previousController = getPageItemViewController(atIndex: viewController.view.tag - 1)
        return previousController
    }
    
    /* ViewController the user will navigate to in forward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let nextController = getPageItemViewController(atIndex: viewController.view.tag + 1)
        return nextController
    }
}


extension ViewPager: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed && finished {
            
            let pageIndex = pageViewController.viewControllers?.first?.view.tag
            //setupCurrentPageIndicator(currentIndex: pageIndex!, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex(index: pageIndex!)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex(index: pageIndex!)
    }
}

extension UIView {
    
    func setupForAutolayout(inView v: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(self)
    }
}
