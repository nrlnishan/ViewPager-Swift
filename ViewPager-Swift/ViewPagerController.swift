//
//  ViewPagerController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

@objc protocol ViewPagerControllerDelegate
{
    optional func willMoveToViewControllerAtIndex(index:Int)
    optional func didMoveToViewControllerAtIndex(index:Int)
}

@objc protocol ViewPagerControllerDataSource
{
    //Total number of pages required
    func numberOfPages() -> Int
    
    //View Controller for required page at index
    func viewControllerAtPosition(position:Int) -> UIViewController
    
    //list of page titles
    func pageTitles() -> [String]
    
    //Index of page which is to be displayed at first
    optional func startViewPagerAtIndex()->Int
    
    
}

class ViewPagerController: UIViewController {
    
    var dataSource : ViewPagerControllerDataSource!
    var delegate : ViewPagerControllerDelegate?
    var options: ViewPagerOptions!
   
    private var pageViewController: UIPageViewController?
    private var tabView:UIScrollView?
    private var tabIndicatorView:UIView?
    
    private var titleLabelArr = [UILabel]()
    private var titleLabelWidthArr = [CGFloat]()
    
    var currentPageIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up View Pager Options
        options.dataSource = self
        options.setExtraDefaults()
        
        //Creating Tab View
        tabView = UIScrollView(frame: CGRect(x: 0, y: 0, width: options.tabViewWidth!, height: options.tabViewHeight))
        
        tabView!.backgroundColor = options.tabViewBackgroundColor
        tabView!.scrollEnabled = true
        tabView!.pagingEnabled = true
        tabView!.showsHorizontalScrollIndicator = false
        tabView!.showsVerticalScrollIndicator = false
        
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: "tabViewTapped:")
        tabViewTapGesture.numberOfTapsRequired = 1
        tabViewTapGesture.numberOfTouchesRequired = 1
        tabView!.addGestureRecognizer(tabViewTapGesture)
        
        self.view.addSubview(tabView!)
        
        setupPageTitle()
        createPageViewController()
        
    }
    
    
    //MARK: Tab View Setup
    
    /*
    Calculates each label sizes, Checks for isEachTabEvenlyDistributed boolean value
    If true, lays out each labels of equal width else lays out each label width left
    and right padding
    */
    private func setupPageTitle()
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
                label.textColor = options.tabViewTextColor
                label.text = eachTitle
                label.textAlignment = .Center
                label.frame = CGRectMake(totalWidth, 0, eachLabelWidth, labelHeight)
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
            label.textColor = options.tabViewTextColor
            label.text = eachTitle
            var labelWidth = label.intrinsicContentSize().width
            labelWidth += leftPadding + rightPadding
            label.textAlignment = .Center
            
            if !isEvenlyDistributed
            {
                label.frame = CGRectMake(totalWidth, 0, labelWidth, labelHeight)
                tabView!.addSubview(label)
                
            }
            
            titleLabelWidthArr.append(labelWidth)
            titleLabelArr.append(label)
            totalWidth += labelWidth
            
        }
        
        //In case tabs are evenly distributed
        if isEvenlyDistributed
        {
            let labelWidth = getMaximumWidth(titleLabelWidthArr)
            
            
            for var i = 0; i < titleLabelArr.count; i++
            {
                titleLabelArr[i].frame = CGRectMake(CGFloat(i) * labelWidth, 0, labelWidth, labelHeight)
                tabView!.addSubview(titleLabelArr[i])
                
            }
            totalWidth = labelWidth * CGFloat(titleLabelArr.count)
        }
        
        tabView!.contentSize = CGSize(width: totalWidth, height: labelHeight)
        
        }
        
    }
    
    
    
    private func getMaximumWidth(widthData:[CGFloat]) -> CGFloat
    {
        var maxmData = widthData[0]
        
        for data in widthData
        {
            if data > maxmData
            {
                maxmData = data
            }
        }
        
        return maxmData
    }
    
    
    //MARK: PageViewController Setup
    
    private func createPageViewController()
    {
        pageViewController = UIPageViewController(transitionStyle: options.viewPagerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController!.dataSource = self
        pageViewController!.delegate = self
        
        pageViewController!.view.frame = CGRectMake(0, options.tabViewHeight, options.getViewPagerWidth(), options.getViewPagerHeight())
        
        if dataSource!.numberOfPages() > 0
        {
            if let startPage =  dataSource?.startViewPagerAtIndex?()
            {
                currentPageIndex = startPage
            }
            
            let firstController = getPageItemViewController(currentPageIndex)!
            let startingViewControllers = [firstController]
            pageViewController!.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
         }
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        
       setupPageIndicator(currentPageIndex, previousIndex: currentPageIndex)
        
    }
    
    
    private func getPageItemViewController(index: Int) -> UIViewController?
    {
        if index < dataSource!.numberOfPages()
        {
            let pageItemViewController = dataSource!.viewControllerAtPosition(index)
            pageItemViewController.view.tag = index
            return pageItemViewController
            
        }
        return nil
    }
    
    
    private func setupPageIndicator(currentIndex:Int,previousIndex:Int)
    {
        
        if previousIndex != currentIndex
        {
            tabIndicatorView?.removeFromSuperview()
        }
        
        if options.isTabViewHighlightAvailable!
        {
            titleLabelArr[previousIndex].backgroundColor = options.tabViewBackgroundColor
            titleLabelArr[currentIndex].backgroundColor = options.tabViewHighlightColor
        }
        
        titleLabelArr[previousIndex].textColor = options.tabViewTextColor
        titleLabelArr[currentIndex].textColor = options.tabViewTextHighlightColor
        currentPageIndex = currentIndex
        
        var width = CGFloat(0)
        let height = options.tabIndicatorViewHeight
        
        //If tabs are evenly distributed
        if options.isEachTabEvenlyDistributed!
        {
            width = getMaximumWidth(titleLabelWidthArr)
            
        }
        else
        {
            width = titleLabelWidthArr[currentIndex]
        }
        
        let yPosition = options.tabViewHeight - options.tabIndicatorViewHeight
        var xPosition = CGFloat(0)
        
        for var i = 0; i < currentIndex; i++
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
            tabIndicatorView!.frame = CGRectMake(xPosition, yPosition, width, height)
            tabIndicatorView!.backgroundColor = options.tabIndicatorViewBackgroundColor
            tabView!.addSubview(tabIndicatorView!)
        }
        
        tabView!.scrollRectToVisible(CGRect(x: xPosition, y: yPosition, width: width, height: height), animated: true)
    }
    
    
    func tabViewTapped(sender: UITapGestureRecognizer)
    {
        let tapLocation = sender.locationInView(self.tabView!)
        
        let labelViews = tabView!.subviews
        
        for var i = 0; i < labelViews.count; i++
        {
            if CGRectContainsPoint(labelViews[i].frame, tapLocation)
            {
                setupPageIndicator(i, previousIndex: currentPageIndex)
                displayChoosenViewController(i)
                break;
            }
        }
    }
    
    
    private func displayChoosenViewController(index:Int)
    {
        let chosenViewController = getPageItemViewController(index)!
        pageViewController!.setViewControllers([chosenViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    }
    
    
}

//MARK: PageViewController Delegates

extension ViewPagerController: UIPageViewControllerDelegate
{
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed
        {
            let pageIndex = pageViewController.viewControllers!.first!.view.tag
            delegate?.didMoveToViewControllerAtIndex?(pageIndex)
            setupPageIndicator(pageIndex, previousIndex: currentPageIndex)
            
        }
        return
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        let pageIndex = pendingViewControllers.first!.view.tag
        delegate?.willMoveToViewControllerAtIndex?(pageIndex)
        
    }
    
    
    
    
    
}

//MARK: PageViewController Datasource

extension ViewPagerController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.view.tag > 0
        {
            return getPageItemViewController(viewController.view.tag - 1)
        }
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.view.tag + 1 < dataSource!.numberOfPages()
        {
            
            return getPageItemViewController(viewController.view.tag + 1)
        }
        return nil
        
    }

}


extension ViewPagerController: ViewPagerOptionsDataSource
{
    func viewHeight() -> CGFloat
    {
        return self.view.bounds.size.height
    }
    
    func viewWidth() -> CGFloat
    {
        return self.view.bounds.size.width
    }
}
