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
    
    func numberOfPages() -> Int             // Number of pages to be displayed
    
    func viewControllerAtPosition(_ position:Int) -> UIViewController    // ViewController for required page position
    
    func tabsForPages() -> [ViewPagerTab]    // Tab structure of the pages
    
    @objc optional func startViewPagerAtIndex()->Int        //ViewController to start from
}

class ViewPagerController:UIViewController {
    
    fileprivate var pageViewController:UIPageViewController!
    fileprivate var tabContainer:UIScrollView!
    fileprivate var tabIndicator:UIView?
    
    fileprivate var tabsList = [ViewPagerTab]()
    fileprivate var tabsViewList = [ViewPagerTabView]()
    
    var dataSource:ViewPagerControllerDataSource!
    var delegate:ViewPagerControllerDelegate?
    var options:ViewPagerOptions!
    
    var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabContainerView()
        setupTabs()
        createPageViewController()
    }
    
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
        let metrics:[String:CGFloat] = ["tabViewHeight":options.tabViewHeight, "tabContainerYPosition":options.viewPagerPosition.y]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(tabContainerYPosition)-[v0(tabViewHeight)]", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
    }
    
    
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
                
                tabsViewList.append(tabView)
                tabContainer.addSubview(tabView)
            }
            
            print("LOG: fitAllTabsInView: TRUE")
        }
        else
        {
            var maxWidth:CGFloat = 0
            
            for eachTab in tabsList {
                
                let tabView = ViewPagerTabView()
                let dummyFrame = CGRect(x: totalWidth, y: 0, width: 0, height: options.tabViewHeight)
                tabView.frame = dummyFrame
                
                // Creating tabs using their intrinsic content size.
                tabView.setup(tab: eachTab, options: options, condition: ViewPagerTabView.SetupCondition.distributeNormally)
                
                if !options.isEachTabEvenlyDistributed! {
                    
                    tabContainer.addSubview(tabView)
                }
                
                tabsViewList.append(tabView)
                totalWidth += tabView.frame.width
                maxWidth = getMaximumWidth(maxWidth: maxWidth, withWidth: tabView.frame.width)
            }
            
            
            // Incase each tabs are evenly distributed, width is the maximum width among view tabs
            if options.isEachTabEvenlyDistributed! {
                
                print("LOG: isEachTabEvenlyDistributed: TRUE ")
                
                for (index,eachTabView) in tabsViewList.enumerated() {
                    
                    eachTabView.updateFrame(atIndex: index, withWidth: maxWidth, options: options)
                    tabContainer.addSubview(eachTabView)
                }
                
                totalWidth = maxWidth * CGFloat(tabsViewList.count)
            }
            
            tabContainer.contentSize = CGSize(width: totalWidth, height: options.tabViewHeight)
            
        } // Else end here
        
    }
    
    
    fileprivate func getMaximumWidth(maxWidth:CGFloat, withWidth currentWidth:CGFloat) -> CGFloat {
        
        return (maxWidth > currentWidth) ? maxWidth : currentWidth
    }
    
    
    
    func tabContainerTapped(_ recognizer:UITapGestureRecognizer) {
        
        
    }
    
    
    
    /*-------------------------------
     MARK:- PageViewController Setup
     -------------------------------*/
    
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
        
    }
    
    /**
     Returns UIViewController for page at provided index.
     */
    fileprivate func getPageItemViewController(atIndex index:Int) -> UIViewController? {
        
        if index < dataSource.numberOfPages() {
            
            let pageItemViewController = dataSource.viewControllerAtPosition(index)
            pageItemViewController.view.tag = index
            return pageItemViewController
        }
        
        return nil
    }
    
    
    
    
    
    
    
}

extension ViewPagerController: UIPageViewControllerDelegate {
    
}

extension ViewPagerController:UIPageViewControllerDataSource {
    
    /**
     ViewController the suer will navigate to in backward direction
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.view.tag > 0 {
            return getPageItemViewController(atIndex: viewController.view.tag - 1)
        }
        return nil
    }
    
    /**
     ViewController the user will navigate to in forward direction
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.view.tag + 1 < dataSource.numberOfPages() {
            return getPageItemViewController(atIndex: viewController.view.tag + 1)
        }
        return nil
    }
    
}

