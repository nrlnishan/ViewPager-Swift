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

public class ViewPager: NSObject {
    
    fileprivate weak var dataSource:ViewPagerDataSource?
    fileprivate weak var delegate:ViewPagerDelegate?
    fileprivate weak var controller: UIViewController?
    fileprivate var view: UIView
    
    fileprivate var tabContainer = UIScrollView()
    fileprivate var pageController: UIPageViewController?
    
    fileprivate var tabIndicator = UIView()
    fileprivate var tabIndicatorLeadingConstraint: NSLayoutConstraint?
    fileprivate var tabIndicatorWidthConstraint: NSLayoutConstraint?
    
    fileprivate var tabsList = [ViewPagerTab]()
    fileprivate var tabsViewList = [ViewPagerTabView]()
    
    fileprivate var options = ViewPagerOptions()
    fileprivate var currentPageIndex = 0
    
    
    
    /// Initializes the ViewPager class.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController in which this view pager is to be initialized
    ///   - containerView: Container view on which viewpager is to be shown. If its nil, default view of UIViewController is used
    public init(viewController: UIViewController, containerView: UIView? = nil) {
        self.controller = viewController
        self.view = containerView ?? viewController.view
    }
    
    
    /// Sets the customization options for ViewPager. This should be called before the build method.
    /// Setting of options is mandatory.
    ///
    /// - Parameter options: Customization options instance
    public func setOptions(options: ViewPagerOptions) {
        self.options = options
    }
    
    
    /// Sets the datasource of the viewpager. This should be called before the build method.
    /// Setting of data source is mandatory.
    ///
    /// - Parameter dataSource: DataSource for this viewpager
    public func setDataSource(dataSource: ViewPagerDataSource) {
        self.dataSource = dataSource
    }
    
    
    /// Sets the delegates of the viewpager. This method is optional
    ///
    /// - Parameter delegate: Delegate for this viewpager.
    public func setDelegate(delegate: ViewPagerDelegate?) {
        self.delegate = delegate
    }
    
    
    /// Initiates the ViewPager creation process. It creates tabs, viewController pages, and tab indicator
    /// Make sure Options & ViewPagerDataSource is set before calling this method.
    public func build() {
        setupTabContainerView()
        setupPageViewController()
        setupTabAndIndicator()
    }
    
    // MARK:- Private Helpers
    
    fileprivate func setupTabContainerView() {
        
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabContainer)
        
        tabContainer.backgroundColor = options.tabViewBackgroundDefaultColor
        tabContainer.isScrollEnabled = true
        tabContainer.showsVerticalScrollIndicator = false
        tabContainer.showsHorizontalScrollIndicator = false
        
        tabContainer.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
        tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            let safeArea = view.safeAreaLayoutGuide
            tabContainer.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        } else {
            let marginGuide = view.layoutMarginsGuide
            tabContainer.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        }
        
        // Adding Gesture
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tabContainerTapped(_:)))
        tabContainer.addGestureRecognizer(tabViewTapGesture)
    }
    
    fileprivate func setupPageViewController() {
        
        let pageController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: .horizontal, options: nil)
        
        self.controller?.addChild(pageController)
        setupForAutolayout(view: pageController.view, inView: view)
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
    
    // MARK:- ViewPager Tab Setup
    
    fileprivate func setupTabAndIndicator() {
        
        guard let tabs = dataSource?.tabsForPages() else { return }
        self.tabsList = tabs
        
        switch options.distribution {
        case .segmented:
            setupTabsForSegmentedDistribution()
            
        case .normal:
            setupTabsForNormalAndEqualDistribution(distribution: .normal)
            
        case .equal:
            setupTabsForNormalAndEqualDistribution(distribution: .equal)
        }
        
        if options.isTabIndicatorAvailable {
            
            setupForAutolayout(view: tabIndicator, inView: tabContainer)
            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
            tabIndicator.heightAnchor.constraint(equalToConstant: options.tabIndicatorViewHeight).isActive = true
            tabIndicator.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            
            let activeTab = self.tabsViewList[currentPageIndex]
            
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            tabIndicatorLeadingConstraint?.isActive = true
            tabIndicatorWidthConstraint?.isActive = true
        }
        
        if options.isTabHighlightAvailable {
            self.tabsViewList[currentPageIndex].addHighlight(options: self.options)
        }
        
        if options.isTabBarShadowAvailable {
            
            tabContainer.layer.masksToBounds = false
            tabContainer.layer.shadowColor = options.shadowColor.cgColor
            tabContainer.layer.shadowOpacity = options.shadowOpacity
            tabContainer.layer.shadowOffset = options.shadowOffset
            tabContainer.layer.shadowRadius = options.shadowRadius
            
            view.bringSubviewToFront(tabContainer)
        }
    }
    
    fileprivate func setupTabsForNormalAndEqualDistribution(distribution: ViewPagerOptions.Distribution) {
        
        var maxWidth: CGFloat = 0
        
        var lastTab: ViewPagerTabView?
        
        for (index, eachTab) in tabsList.enumerated() {
            
            let tabView = ViewPagerTabView()
            setupForAutolayout(view: tabView, inView: tabContainer)
            
            tabView.backgroundColor = options.tabViewBackgroundDefaultColor
            tabView.setup(tab: eachTab, options: options)
            
            if let previousTab = lastTab {
                tabView.leadingAnchor.constraint(equalTo: previousTab.trailingAnchor).isActive = true
            } else {
                tabView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor).isActive = true
            }
            
            tabView.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
            
            tabView.tag = index
            tabsViewList.append(tabView)
            
            maxWidth = max(maxWidth, tabView.width)
            lastTab = tabView
        }
        
        lastTab?.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor).isActive = true
        
        // Second pass to set Width for all tabs
        tabsViewList.forEach { tabView in
            
            switch distribution {
                
            case .normal:
                tabView.widthAnchor.constraint(equalToConstant: tabView.width).isActive = true
            case .equal:
                tabView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
            default:
                break
            }
        }
    }
    
    
    fileprivate func setupTabsForSegmentedDistribution() {
        
        var lastTab: ViewPagerTabView?
        
        let tabCount = CGFloat(self.tabsList.count)
        let distribution = CGFloat(1.0 / tabCount)
        
        for (index, eachTab) in self.tabsList.enumerated() {
            
            let tabView = ViewPagerTabView()
            setupForAutolayout(view: tabView, inView: tabContainer)
            tabView.backgroundColor = options.tabViewBackgroundDefaultColor
            
            if let previousTab = lastTab {
                tabView.leadingAnchor.constraint(equalTo: previousTab.trailingAnchor).isActive = true
            } else {
                tabView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor).isActive = true
            }
            
            tabView.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalToConstant: options.tabViewHeight).isActive = true
            tabView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: distribution).isActive = true
            
            tabView.setup(tab: eachTab, options: options)
            
            tabView.tag = index
            tabsViewList.append(tabView)
            
            lastTab = tabView
        }
        
        lastTab?.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor).isActive = true
    }
    
    /// Sets up indicator for the page if enabled in ViewPagerOption. This method shows either tabIndicator or Highlights current tab or both.
    fileprivate func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
        
        self.currentPageIndex = currentIndex
        
        let activeTab = tabsViewList[currentIndex]
        let activeFrame = activeTab.frame
        
        // Setup Tab Highlight
        if options.isTabHighlightAvailable {
            
            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.tabsViewList[currentIndex].addHighlight(options: self.options)
            })
        }
        
        if options.isTabIndicatorAvailable {
            
            // Deactivate previous contstraint
            tabIndicatorLeadingConstraint?.isActive = false
            tabIndicatorWidthConstraint?.isActive = false
            
            // Create new ones to activate within animation block
            tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
            tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
            
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                
                self.tabIndicatorWidthConstraint?.isActive = true
                self.tabIndicatorLeadingConstraint?.isActive = true
                
                self.tabContainer.scrollRectToVisible(activeFrame, animated: false)
                self.tabContainer.layoutIfNeeded()
            }
            
            return
        }
        
        self.tabContainer.scrollRectToVisible(activeFrame, animated: true)
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
    
    
    /// Displays the UIViewController provided at given index in datasource.
    ///
    /// - Parameter index: position of the view controller to be displayed. 0 is first UIViewController
    public func displayViewController(atIndex index:Int) {
        
        guard let chosenViewController = getPageItemViewController(atIndex: index) else {
            fatalError("There is no view controller for tab at index: \(index)")
        }
        
        let previousIndex = currentPageIndex
        let direction:UIPageViewController.NavigationDirection = (index > previousIndex ) ? .forward : .reverse
        
        
        delegate?.willMoveToControllerAtIndex(index: index)
        setupCurrentPageIndicator(currentIndex: index, previousIndex: currentPageIndex)
        
        /* Wierd bug in UIPageViewController. Due to caching, in scroll transition mode,
         wrong cached view controller is shown. This is the common workaround */
        pageController?.setViewControllers([chosenViewController], direction: direction, animated: true, completion: { (isCompleted) in
            
            DispatchQueue.main.async { [unowned self] in
                
                self.pageController?.setViewControllers([chosenViewController], direction: direction, animated: false, completion: { (isComplete) in
                    
                    guard isComplete else { return }
                    
                    self.delegate?.didMoveToControllerAtIndex(index: index)
                    
                })
            }
        })
    }
    
    /// Invalidate the current tab layout and causes the layout to be drawn again.
    public func invalidateCurrentTabs() {
        
        // Removing all the tabs from tabContainer
        _ = tabsViewList.map({ $0.removeFromSuperview() })
        
        tabIndicator = UIView()
        tabIndicatorLeadingConstraint?.isActive = false
        tabIndicatorWidthConstraint?.isActive = false
        
        tabsList.removeAll()
        tabsViewList.removeAll()
        
        setupTabAndIndicator()
    }
    
    
    // MARK:- Actions
    @objc func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tabContainer)
        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
        
        if let tabIndex = tabViewTapped?.tag, tabIndex != currentPageIndex {
            displayViewController(atIndex: tabIndex)
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
        
        guard let pageIndex = pageViewController.viewControllers?.first?.view.tag else { return }
        
        if completed && finished {
            
            setupCurrentPageIndicator(currentIndex: pageIndex, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex(index: pageIndex)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex(index: pageIndex!)
    }
    
    
    internal func setupForAutolayout(view: UIView?, inView parentView: UIView) {
        
        guard let v = view else { return }
        
        v.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(v)
    }
}
