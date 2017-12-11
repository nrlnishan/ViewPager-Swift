//
//  ViewPagerController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

@objc public protocol ViewPagerControllerDelegate {
    
    @objc optional func willMoveToControllerAtIndex(index:Int)
    @objc optional func didMoveToControllerAtIndex(index:Int)
}

public protocol ViewPagerControllerDataSource: class {
    
    /// Number of pages to be displayed
    func numberOfPages() -> Int
    
    /// ViewController for required page position
    func viewControllerAtPosition(position:Int) -> UIViewController
    
    /// Tab structure of the pages
    func tabsForPages() -> [ViewPagerTab]
    
    /// UIViewController which is to be displayed at first. Default is 0
    func startViewPagerAtIndex()->Int
}

public extension ViewPagerControllerDataSource {
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

public class ViewPagerController:UIViewController {
    
    public weak var dataSource:ViewPagerControllerDataSource!
    public weak var delegate:ViewPagerControllerDelegate?
    
    fileprivate var tabContainer:UIScrollView!
    
    fileprivate var pageViewController:UIPageViewController!
    fileprivate lazy var tabIndicator = UIView()
    
    fileprivate var tabsList = [ViewPagerTab]()
    fileprivate var tabsViewList = [ViewPagerTabView]()
    
    fileprivate var isIndicatorAdded = false
    fileprivate var currentPageIndex = 0
    
    public var options:ViewPagerOptions!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = options.viewPagerFrame
        
        setupTabContainerView()
        setupTabs()
        createPageViewController()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.frame = options.viewPagerFrame
        setupPageControllerFrame()
    }
    
    /*--------------------------
     MARK:- Viewpager tab setup
     ---------------------------*/
    
    /// Prepares the container for holding all the tabviews.
    fileprivate func setupTabContainerView() {
        
        let viewPagerFrame = options.viewPagerFrame
        
        // Creating container for Tab View
        tabContainer = UIScrollView()
        tabContainer = UIScrollView(frame: CGRect(x: 0, y:0, width: viewPagerFrame.width, height: options.tabViewHeight))
        tabContainer.backgroundColor = options.tabViewBackgroundDefaultColor
        tabContainer.isScrollEnabled = true
        tabContainer.showsVerticalScrollIndicator = false
        tabContainer.showsHorizontalScrollIndicator = false
        
        // Adding Gesture
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewPagerController.tabContainerTapped(_:)))
        tabContainer.addGestureRecognizer(tabViewTapGesture)
        
        // For Landscape mode, Setting up VFL
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabContainer)
        
        let viewDict:[String:UIView] = ["v0":self.tabContainer]
        let metrics:[String:CGFloat] = ["tabViewHeight":options.tabViewHeight]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(tabViewHeight)]", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
    }
    
    
    ///Creates and adds each tabs according to the options provided in tabcontainer.
    fileprivate func setupTabs() {
        
        var totalWidth:CGFloat = 0
        self.tabsList = dataSource.tabsForPages()
        
        if options.fitAllTabsInView {
            
            let viewPagerFrame = options.viewPagerFrame
            
            // Calculating width for each tab
            let eachLabelWidth = viewPagerFrame.width / CGFloat (tabsList.count)
            totalWidth = viewPagerFrame.width * CGFloat(tabsList.count)
            
            // Creating view for each tab. Width for each tab is provided.
            for (index,eachTab) in tabsList.enumerated() {
                
                let xPosition = CGFloat(index) * eachLabelWidth
                let tabView = ViewPagerTabView()
                tabView.frame = CGRect(x: xPosition, y: 0, width: eachLabelWidth, height: options.tabViewHeight)
                tabView.setup(tab: eachTab, options: options, condition: ViewPagerTabView.SetupCondition.fitAllTabs)
                
                tabView.tag = index
                tabsViewList.append(tabView)
                tabContainer.addSubview(tabView)
            }
            
        } else {
            
            var maxWidth:CGFloat = 0
            
            for (index,eachTab) in tabsList.enumerated() {
                
                let tabView = ViewPagerTabView()
                let dummyFrame = CGRect(x: totalWidth, y: 0, width: 0, height: options.tabViewHeight)
                tabView.frame = dummyFrame
                
                // Creating tabs using their intrinsic content size.
                tabView.setup(tab: eachTab, options: options, condition: ViewPagerTabView.SetupCondition.distributeNormally)
                
                if !options.isEachTabEvenlyDistributed {
                    
                    tabContainer.addSubview(tabView)
                }
                
                tabView.tag = index
                tabsViewList.append(tabView)
                totalWidth += tabView.frame.width
                maxWidth = getMaximumWidth(maxWidth: maxWidth, withWidth: tabView.frame.width)
            }
            
            // Incase each tabs are evenly distributed, width is the maximum width among view tabs
            if options.isEachTabEvenlyDistributed {
                
                for (index,eachTabView) in tabsViewList.enumerated() {
                    
                    eachTabView.updateFrame(atIndex: index, withWidth: maxWidth, options: options)
                    tabContainer.addSubview(eachTabView)
                }
                
                totalWidth = maxWidth * CGFloat(tabsViewList.count)
            }
            
            tabContainer.contentSize = CGSize(width: totalWidth, height: options.tabViewHeight)
        }
    }
    
    
    /// Sets up indicator for the page if enabled in ViewPagerOption. This method shows either tabIndicator or Highlights current tab or both.
    fileprivate func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
        
        if options.isTabHighlightAvailable {
            
            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
            
            UIView.animate(withDuration: 0.8, animations: {
                
                self.tabsViewList[currentIndex].addHighlight(options: self.options)
            })
        }
        
        self.currentPageIndex = currentIndex
        
        let currentTabFrame = tabsViewList[currentIndex].frame
        var tabIndicatorFrame:CGRect!
        
        if options.isTabIndicatorAvailable {
            
            let indicatorWidth = currentTabFrame.width
            let indicatorHeight = options.tabIndicatorViewHeight
            let xPosition:CGFloat = currentTabFrame.origin.x
            let yPosition = options.tabViewHeight - options.tabIndicatorViewHeight
            
            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
            
            let dummyFrame = CGRect(x: xPosition, y: yPosition, width: 0, height: indicatorHeight)  // for animating purpose
            tabIndicatorFrame = CGRect(x: xPosition, y: yPosition, width: indicatorWidth, height: indicatorHeight)
            
            if !isIndicatorAdded {
                
                tabIndicator.frame = dummyFrame
                tabContainer.addSubview(tabIndicator)
                isIndicatorAdded = true
            }
            
            self.tabContainer.bringSubview(toFront: tabIndicator)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.tabContainer.scrollRectToVisible(tabIndicatorFrame, animated: false)
                self.tabIndicator.frame = tabIndicatorFrame
                self.tabIndicator.layoutIfNeeded()
            })
            
            return
        }
        
        // Just animate the scrolling if indicator is not available
        UIView.animate(withDuration: 0.5) { 
            
            self.tabContainer.scrollRectToVisible(currentTabFrame, animated: false)
        }
        
    }
    
    /*--------------------------
     MARK:- Tab setup helpers
     ---------------------------*/
    
    /// Gesture recognizer for determining which tabview was tapped
    @objc func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tabContainer)
        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
        
        let tabViewIndex = tabViewTapped?.tag
        
        if tabViewIndex != currentPageIndex {
            
            displayViewController(atIndex: tabViewIndex ?? 0)
        }
    }
    
    /// Determines the orientation change and sets up the tab size and its indicator size accordingly.
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        DispatchQueue.main.async {
            
            if self.options.fitAllTabsInView {
                
                let tabContainerWidth = self.tabContainer.frame.size.width
                let tabViewWidth = tabContainerWidth / CGFloat (self.tabsList.count)
                
                if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isPortrait {
                    
                    for (index,eachTab ) in self.tabsViewList.enumerated() {
                        
                        eachTab.updateFrame(atIndex: index, withWidth: tabViewWidth, options: self.options)
                    }
                    
                    self.tabContainer.contentSize = CGSize(width: tabContainerWidth, height: self.options.tabViewHeight)
                }
                
                self.setupCurrentPageIndicator(currentIndex: self.currentPageIndex, previousIndex: self.currentPageIndex)
            }
        }
    }
    
    /// Determines maximum width between two provided value and returns it
    fileprivate func getMaximumWidth(maxWidth:CGFloat, withWidth currentWidth:CGFloat) -> CGFloat {
        
        return (maxWidth > currentWidth) ? maxWidth : currentWidth
    }
    
    
    /*--------------------------------
     MARK:- PageViewController Helpers
     --------------------------------*/
    
    fileprivate func createPageViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        setupPageControllerFrame()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if dataSource.numberOfPages() > 0 {
            
            currentPageIndex = dataSource.startViewPagerAtIndex()
            let firstController = getPageItemViewController(atIndex: currentPageIndex)!
            pageViewController.setViewControllers([firstController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
       
        setupCurrentPageIndicator(currentIndex: currentPageIndex, previousIndex: currentPageIndex)
    }
    
    // PageViewController Frame Setup
    
    fileprivate func setupPageControllerFrame() {
        
        let viewPagerFrame = options.viewPagerFrame
        let viewPagerHeight = options.viewPagerFrame.height - options.tabViewHeight - options.viewPagerFrame.origin.y
        
        let pageControllerFrame = CGRect(x: viewPagerFrame.origin.x, y: options.tabViewHeight, width: viewPagerFrame.width, height: viewPagerHeight)
        pageViewController.view.frame = pageControllerFrame
    }
    
    /// Returns UIViewController for page at provided index.
    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
        
        if index >= 0 && index < dataSource.numberOfPages() {
            
            let pageItemViewController = dataSource.viewControllerAtPosition(position: index)
            pageItemViewController.view.tag = index
            
            return pageItemViewController
        }
        
        return nil
    }
    
    
    /// Displays the UIViewController provided at given index in datasource.
    ///
    /// - Parameter index: position of the view controller to be displayed. 0 is first UIViewController
    public func displayViewController(atIndex index:Int) {
        
        let chosenViewController = getPageItemViewController(atIndex: index)!
        delegate?.willMoveToControllerAtIndex?(index: index)
        
        let previousIndex = currentPageIndex
        let direction:UIPageViewControllerNavigationDirection = (index > previousIndex ) ? .forward : .reverse
        setupCurrentPageIndicator(currentIndex: index, previousIndex: currentPageIndex)
        
        /* Wierd bug in UIPageViewController. Due to caching, in scroll transition mode, 
         wrong cached view controller is shown. This is the common workaround */
        
        pageViewController.setViewControllers([chosenViewController], direction: direction, animated: true, completion: { (isCompleted) in
            
            DispatchQueue.main.async { [unowned self] in
                self.pageViewController.setViewControllers([chosenViewController], direction: direction, animated: false, completion: { (isCompleted) in
                    
                    if isCompleted {
                        self.delegate?.didMoveToControllerAtIndex?(index: index)
                    }
                })
            }
            
        })
    }
    
    /// Invalidate the current tabs shown and reloads the new tabs provided in datasource.
    public func invalidateTabs() {
        
        // Removing all the tabs from tabContainer
        _ = tabsViewList.map({ $0.removeFromSuperview() })
        
        tabsList.removeAll()
        tabsViewList.removeAll()
        
        setupTabs()
        setupCurrentPageIndicator(currentIndex: currentPageIndex, previousIndex: currentPageIndex)
    }
    
}

// MARK:- UIPageViewController Delegates

extension ViewPagerController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed && finished {
            
            let pageIndex = pageViewController.viewControllers?.first?.view.tag
            setupCurrentPageIndicator(currentIndex: pageIndex!, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex?(index: pageIndex!)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex?(index: pageIndex!)
    }    
}

// MARK:- UIPageViewController Datasource

extension ViewPagerController:UIPageViewControllerDataSource {
    
    /* ViewController the user will navigate to in backward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return getPageItemViewController(atIndex: viewController.view.tag - 1)
    }
    
    /* ViewController the user will navigate to in forward direction */
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return getPageItemViewController(atIndex: viewController.view.tag + 1)
    }
    
}

