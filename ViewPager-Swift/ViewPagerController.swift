//
//  ViewPagerController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit


@objc protocol ViewPagerControllerDelegate {
    
    @objc optional func willMoveToControllerAtIndex(_ index:Int)
    @objc optional func didMoveToControllerAtIndex(_ index:Int)
}

@objc protocol ViewPagerControllerDataSource {
    
    // Number of pages to be displayed
    func numberOfPages() -> Int
    
    // ViewController for required page position
    func viewControllerAtPosition(_ position:Int) -> UIViewController
    
    // Tab structure of the pages
    func tabsForPages() -> [ViewPagerTab]
    
    //ViewController to start from
    @objc optional func startViewPagerAtIndex()->Int
}

class ViewPagerController:UIViewController {
    
    fileprivate var pageViewController:UIPageViewController!
    fileprivate var tabContainer:UIScrollView!
    fileprivate lazy var tabIndicator = UIView()
    
    fileprivate var tabsList = [ViewPagerTab]()
    fileprivate var tabsViewList = [ViewPagerTabView]()
    
    fileprivate var isIndicatorAdded = false
    fileprivate var currentPageIndex = 0
    
    var dataSource:ViewPagerControllerDataSource!
    var delegate:ViewPagerControllerDelegate?
    var options:ViewPagerOptions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabContainerView()
        setupTabs()
        createPageViewController()
    }
    
    
    /*--------------------------
     MARK:- Viewpager tab setup
     ---------------------------*/
    
    /**
     * Prepares the container for holding all the tabviews.
     */
    fileprivate func setupTabContainerView() {
        
        // Creating container for Tab View
        tabContainer = UIScrollView(frame: CGRect(x: 0, y: options.viewPagerPosition.y, width: options.tabViewWidth, height: options.tabViewHeight))
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
        
        let viewDict:[String:UIView] = ["v0":self.tabContainer!]
        let metrics:[String:CGFloat] = ["tabViewHeight":options.tabViewHeight, "tabContainerYPosition":options.viewPagerPosition.y,"tabViewWidth":options.tabViewWidth]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(tabViewWidth)]-(>=0)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(tabContainerYPosition)-[v0(tabViewHeight)]", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
    }
    
    
    /**
     * Creates and adds each tabs according to the options provided in tabcontainer.
     */
    fileprivate func setupTabs() {
        
        var totalWidth:CGFloat = 0
        self.tabsList = dataSource.tabsForPages()
        
        if options.fitAllTabsInView! {
            
            // Calculating width for each tab
            let eachLabelWidth = options.tabViewWidth / CGFloat (tabsList.count)
            totalWidth = options.tabViewWidth * CGFloat(tabsList.count)
            
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
                
                if !options.isEachTabEvenlyDistributed! {
                    
                    tabContainer.addSubview(tabView)
                }
                
                tabView.tag = index
                tabsViewList.append(tabView)
                totalWidth += tabView.frame.width
                maxWidth = getMaximumWidth(maxWidth: maxWidth, withWidth: tabView.frame.width)
            }
            
            // Incase each tabs are evenly distributed, width is the maximum width among view tabs
            if options.isEachTabEvenlyDistributed! {
                
                for (index,eachTabView) in tabsViewList.enumerated() {
                    
                    eachTabView.updateFrame(atIndex: index, withWidth: maxWidth, options: options)
                    tabContainer.addSubview(eachTabView)
                }
                
                totalWidth = maxWidth * CGFloat(tabsViewList.count)
            }
            
            tabContainer.contentSize = CGSize(width: totalWidth, height: options.tabViewHeight)
        }
    }
    
    /**
     * Sets up indicator for the page if enabled in ViewPagerOption. This method shows either tabIndicator
     * or Highlights current tab or both.
     */
    func setupCurrentPageIndicator(currentIndex: Int, previousIndex: Int) {
        
        if options.isTabHighlightAvailable! {
            
            self.tabsViewList[previousIndex].removeHighlight(options: self.options)
            UIView.animate(withDuration: 0.8, animations: {
                
                self.tabsViewList[currentIndex].addHighlight(options: self.options)
            })
        }
        
        self.currentPageIndex = currentIndex
        
        if options.isTabIndicatorAvailable! {
            
            let indicatorWidth = tabsViewList[currentIndex].frame.width
            let indicatorHeight = options.tabIndicatorViewHeight!
            let xPosition:CGFloat = tabsViewList[currentPageIndex].frame.origin.x
            let yPosition = options.tabViewHeight - options.tabIndicatorViewHeight
            
            tabIndicator.backgroundColor = options.tabIndicatorViewBackgroundColor
            
            let dummyFrame = CGRect(x: xPosition, y: yPosition, width: 0, height: indicatorHeight)
            let tabIndicatorFrame = CGRect(x: xPosition, y: yPosition, width: indicatorWidth, height: indicatorHeight)
            
            if !isIndicatorAdded {
                
                tabIndicator.frame = dummyFrame
                tabContainer.addSubview(tabIndicator)
                isIndicatorAdded = true
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.tabContainer.scrollRectToVisible(tabIndicatorFrame, animated: false)
                self.tabIndicator.frame = tabIndicatorFrame
                self.tabIndicator.layoutIfNeeded()
            })
        }
    }
    
    /*--------------------------
     MARK:- Tab setup helpers
     ---------------------------*/
    
    /**
     * Gesture recognizer for determining which tabview was tapped
     */
    func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tabContainer)
        let tabViewTapped =  tabContainer.hitTest(tapLocation, with: nil)
        
        let tabViewIndex = tabViewTapped?.tag
        
        if tabViewIndex != currentPageIndex {
            
            setupCurrentPageIndicator(currentIndex: tabViewIndex ?? 0, previousIndex: currentPageIndex)
            displayViewController(atIndex: tabViewIndex ?? 0)
        }
    }
    
    /**
     * Determines the orientation change and sets up the tab size and its indicator size accordingly.
     */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        DispatchQueue.main.async {
            
            if self.options.fitAllTabsInView! {
                
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
    
    /**
     * Determines maximum width between two provided value and returns it
     */
    fileprivate func getMaximumWidth(maxWidth:CGFloat, withWidth currentWidth:CGFloat) -> CGFloat {
        
        return (maxWidth > currentWidth) ? maxWidth : currentWidth
    }
    
    
    
    
    
    /*--------------------------------
     MARK:- PageViewController Helpers
     --------------------------------*/
    
    fileprivate func createPageViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageViewController?.view.frame = CGRect(x: options.viewPagerPosition.x, y: options.viewPagerPosition.y + options.tabViewHeight, width: options.getViewPagerWidth(), height: options.getViewPagerHeight())
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        if dataSource.numberOfPages() > 0 {
            
            if let startPageIndex = dataSource.startViewPagerAtIndex?() {
                currentPageIndex = startPageIndex
            }
            
            let firstController = getPageItemViewController(atIndex: currentPageIndex)!
            let startingViewControllers = [firstController]
            pageViewController?.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
        setupCurrentPageIndicator(currentIndex: currentPageIndex, previousIndex: currentPageIndex)
        
    }
    
    /**
     * Returns UIViewController for page at provided index.
     */
    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
        
        if index < dataSource.numberOfPages() {
            
            let pageItemViewController = dataSource.viewControllerAtPosition(index)
            pageItemViewController.view.tag = index
            return pageItemViewController
        }
        
        return nil
    }
    
    /**
     * Sets the visible view controller with the view controller at provided index.
     */
    fileprivate func displayViewController(atIndex index:Int) {
        
        let chosenViewController = getPageItemViewController(atIndex: index)!
        pageViewController!.setViewControllers([chosenViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    
}

extension ViewPagerController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            let pageIndex = pageViewController.viewControllers?.first?.view.tag
            setupCurrentPageIndicator(currentIndex: pageIndex!, previousIndex: currentPageIndex)
            delegate?.didMoveToControllerAtIndex?(pageIndex!)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first?.view.tag
        delegate?.willMoveToControllerAtIndex?(pageIndex!)
        
    }
    
    
}

extension ViewPagerController:UIPageViewControllerDataSource {
    
    /**
     * ViewController the user will navigate to in backward direction
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.view.tag > 0 {
            return getPageItemViewController(atIndex: viewController.view.tag - 1)
        }
        return nil
    }
    
    /**
     * ViewController the user will navigate to in forward direction
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.view.tag + 1 < dataSource.numberOfPages() {
            return getPageItemViewController(atIndex: viewController.view.tag + 1)
        }
        return nil
    }
    
}

