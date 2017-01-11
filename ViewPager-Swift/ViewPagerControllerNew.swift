//
//  ViewPagerControllerNew.swift
//  ViewPager-Swift
//
//  Created by AndMine on 1/9/17.
//  Copyright © 2017 Nishan. All rights reserved.
//

import Foundation
import UIKit

/*
 
 
 class ViewPagerController: UIViewController {
 
 var dataSource : ViewPagerControllerDataSource!
 var delegate : ViewPagerControllerDelegate?
 var options: ViewPagerOptions!
 
 fileprivate var pageViewController: UIPageViewController?
 fileprivate var tabView:UIScrollView!
 fileprivate var tabIndicatorView:UIView?
 
 fileprivate var titleLabelArr = [UILabel]()
 fileprivate var titleLabelWidthArr = [CGFloat]()
 
 var currentPageIndex = 0
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 setupTabView()
 setupPageTitle()
 createPageViewController()
 }
 
 
 
 //MARK: Tab View Setup
 
 /*
 Calculates each label sizes, Checks for isEachTabEvenlyDistributed boolean value
 If true, lays out each labels of equal width else lays out each label width left
 and right padding
 */
 
 
 fileprivate func setupPageTitle()
 {
 let titles = dataSource!.pageTitles()
 let labelHeight = options.tabViewHeight
 
 if options.fitAllTabsInView!
 {
 let viewWidth = self.view.bounds.width
 let eachLabelWidth = viewWidth / CGFloat(titles.count)
 var totalWidth:CGFloat = 0.0
 
 for eachTitle in titles
 {
 let label = UILabel()
 label.textColor = options.tabViewTextDefaultColor
 label.text = eachTitle
 label.textAlignment = .center
 label.frame = CGRect(x: totalWidth, y: 0, width: eachLabelWidth, height: labelHeight!)
 totalWidth += eachLabelWidth
 tabView!.addSubview(label)
 titleLabelWidthArr.append(eachLabelWidth)
 titleLabelArr.append(label)
 }
 }
 else
 {
 
 let leftPadding = options.tabLabelPaddingLeft
 let rightPadding = options.tabLabelPaddingRight
 
 let isEvenlyDistributed = options.isEachTabEvenlyDistributed!
 
 var totalWidth:CGFloat = 0.0
 
 
 
 for eachTitle in titles
 {
 let label = UILabel()
 label.textColor = options.tabViewTextDefaultColor
 label.text = eachTitle
 var labelWidth = label.intrinsicContentSize.width
 labelWidth += leftPadding! + rightPadding!
 label.textAlignment = .center
 
 if !isEvenlyDistributed
 {
 label.frame = CGRect(x: totalWidth, y: 0, width: labelWidth, height: labelHeight!)
 tabView!.addSubview(label)
 }
 
 titleLabelWidthArr.append(labelWidth)
 titleLabelArr.append(label)
 totalWidth += labelWidth
 }
 
 
 
 //In case tabs are evenly distributed, takes the width as the maximum width among view tabs
 if isEvenlyDistributed
 {
 let labelWidth = titleLabelWidthArr.max()!
 
 
 for i in 0 ..< titleLabelArr.count
 {
 titleLabelArr[i].frame = CGRect(x: CGFloat(i) * labelWidth, y: 0, width: labelWidth, height: labelHeight!)
 tabView!.addSubview(titleLabelArr[i])
 
 }
 
 totalWidth = labelWidth * CGFloat(titleLabelArr.count)
 }
 
 tabView!.contentSize = CGSize(width: totalWidth, height: labelHeight!)
 }
 
 }
 
 ******
 
 
 //MARK: PageViewController Setup
 
 fileprivate func createPageViewController()
 {
 pageViewController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
 pageViewController!.dataSource = self
 pageViewController!.delegate = self
 
 pageViewController!.view.frame = CGRect(x: 0, y: options.tabViewHeight, width: options.getViewPagerWidth(), height: options.getViewPagerHeight())
 
 if dataSource!.numberOfPages() > 0
 {
 if let startPage =  dataSource?.startViewPagerAtIndex?()
 {
 currentPageIndex = startPage
 }
 
 let firstController = getPageItemViewController(currentPageIndex)!
 let startingViewControllers = [firstController]
 pageViewController!.setViewControllers(startingViewControllers, direction: .forward, animated: false, completion: nil)
 }
 
 self.addChildViewController(pageViewController!)
 self.view.addSubview(pageViewController!.view)
 self.pageViewController!.didMove(toParentViewController: self)
 
 setupPageIndicator(currentPageIndex, previousIndex: currentPageIndex)
 
 }
 
 /**
 Returns ViewController for each page for given index.
 */
 fileprivate func getPageItemViewController(_ index: Int) -> UIViewController?
 {
 if index < dataSource!.numberOfPages()
 {
 let pageItemViewController = dataSource!.viewControllerAtPosition(index)
 pageItemViewController.view.tag = index
 return pageItemViewController
 
 }
 return nil
 }
 
 
 /**
 Sets up tab highlight as well as tab indicator if available
 */
 fileprivate func setupPageIndicator(_ currentIndex:Int,previousIndex:Int)
 {
     print("Current Index: \(currentIndex)  Previous Index: \(previousIndex)")
 
     tabIndicatorView?.removeFromSuperview()
     
     if options.isTabViewHighlightAvailable!
     {
         titleLabelArr[previousIndex].backgroundColor = options.tabViewBackgroundDefaultColor
         titleLabelArr[currentIndex].backgroundColor = options.tabViewBackgroundHighlightColor
     }
     
     titleLabelArr[previousIndex].textColor = options.tabViewTextDefaultColor
     titleLabelArr[currentIndex].textColor = options.tabViewTextHighlightColor
     currentPageIndex = currentIndex
     
     var width = CGFloat(0)
     let height = options.tabIndicatorViewHeight
     
     //If tabs are evenly distributed
     if options.isEachTabEvenlyDistributed!
     {
         width = titleLabelWidthArr.max()!
     }
     else
     {
         width = titleLabelWidthArr[currentIndex]
     }
     
     let yPosition = options.tabViewHeight - options.tabIndicatorViewHeight
     var xPosition = CGFloat(0)
     
     for i in 0 ..< currentIndex
     {
         if !options.isEachTabEvenlyDistributed!
         {
             xPosition += titleLabelWidthArr[i]
         }
         else
         {
             xPosition += width
         }
     }
     
     if options.isTabIndicatorViewAvailable!
     {
         tabIndicatorView = UIView()
         tabIndicatorView?.backgroundColor = options.tabIndicatorViewBackgroundColor
         tabIndicatorView!.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height!)
         tabIndicatorView!.backgroundColor = options.tabIndicatorViewBackgroundColor
         tabView!.addSubview(tabIndicatorView!)
     }
     
     tabView!.scrollRectToVisible(CGRect(x: xPosition, y: yPosition, width: width, height: height!), animated: true)
 }
 
 
 func tabViewTapped(_ sender: UITapGestureRecognizer)
 {
     let tapLocation = sender.location(in: self.tabView!)
     
     let labelViews = tabView!.subviews
     
     for i in 0 ..< labelViews.count
     {
         if labelViews[i].frame.contains(tapLocation) && i != currentPageIndex
         {
             setupPageIndicator(i, previousIndex: currentPageIndex)
             displayChoosenViewController(i)
             break;
         }
     }
 }
 
 /**
 Displays ViewController of provided index
 */
 fileprivate func displayChoosenViewController(_ index:Int)
 {
 let chosenViewController = getPageItemViewController(index)!
 pageViewController!.setViewControllers([chosenViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
 }
 
 
 }
 
 /*----------------------------------
 MARK:- PageViewController Delegates
 -----------------------------------*/
 
 extension ViewPagerController: UIPageViewControllerDelegate
 {
 func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
 
 if completed
 {
 let pageIndex = pageViewController.viewControllers!.first!.view.tag
 delegate?.didMoveToViewControllerAtIndex?(pageIndex)
 setupPageIndicator(pageIndex, previousIndex: currentPageIndex)
 
 }
 return
 }
 
 func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
 
 let pageIndex = pendingViewControllers.first!.view.tag
 delegate?.willMoveToViewControllerAtIndex?(pageIndex)
 
 }
 
 }
 
 /*----------------------------------
 MARK:- PageViewController Datasource
 -----------------------------------*/
 
 extension ViewPagerController: UIPageViewControllerDataSource
 {
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
 {
 if viewController.view.tag > 0
 {
 return getPageItemViewController(viewController.view.tag - 1)
 }
 return nil
 
 }
 
 func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
 {
 if viewController.view.tag + 1 < dataSource!.numberOfPages()
 {
 
 return getPageItemViewController(viewController.view.tag + 1)
 }
 return nil
 
 }
 
 }
 
 fileprivate func setupTabView()
 {
 // Creating TabView
 tabView = UIScrollView(frame: CGRect(x: 0, y: 0, width: options.tabViewWidth!, height: options.tabViewHeight))
 tabView.backgroundColor = options.tabViewBackgroundDefaultColor
 tabView.isScrollEnabled = true
 tabView.isPagingEnabled = true
 tabView.showsHorizontalScrollIndicator = false
 tabView.showsVerticalScrollIndicator = false
 
 // Adding tapGesture
 let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewPagerController.tabViewTapped(_:)))
 tabViewTapGesture.numberOfTapsRequired = 1
 tabViewTapGesture.numberOfTouchesRequired = 1
 tabView.addGestureRecognizer(tabViewTapGesture)
 
 // Setting up VFL for orientation change
 tabView.translatesAutoresizingMaskIntoConstraints = false
 self.view.addSubview(tabView)
 
 let viewDict:[String:UIView] = ["v0":self.tabView!]
 let metrics:[String:CGFloat] = ["tabViewHeight":options.tabViewHeight]
 self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
 self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(tabViewHeight)]", options: NSLayoutFormatOptions(), metrics: metrics, views: viewDict))
 }
 
 
 */
