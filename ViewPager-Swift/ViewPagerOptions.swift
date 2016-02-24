//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import Foundation
import UIKit

protocol ViewPagerOptionsDataSource
{
    func viewHeight() -> CGFloat
    func viewWidth() -> CGFloat
}

class ViewPagerOptions
{
    var dataSource:ViewPagerOptionsDataSource!
    
    //MARK: Booleans 
    
    var isTabViewHighlightAvailable:Bool!
    var isTabIndicatorViewAvailable:Bool!
    var isEachTabEvenlyDistributed: Bool!
    var fitAllTabsInView:Bool!
    
    //MARK: Tab View Properties
    
    var tabViewHeight:CGFloat!
    var tabViewWidth:CGFloat?
    var tabViewBackgroundColor:UIColor!
    var tabViewHighlightColor:UIColor!
    var tabViewTextColor:UIColor!
    var tabViewTextHighlightColor:UIColor!
    var tabLabelPaddingLeft:CGFloat!
    var tabLabelPaddingRight:CGFloat!
    
    
    //MARK: Tab Indicator Properties
    
    var tabIndicatorViewHeight:CGFloat!
    var tabIndicatorViewBackgroundColor:UIColor!
    
    //MARK: View Pager Properties
    var viewPagerTransitionStyle:UIPageViewControllerTransitionStyle!
    
    
    //MARK: View Pager Internal Methods
    
    init()
    {
        setDefaults()
    }
   
    /*
    Sets defaults values for viewpager and view pager tabs during initialization of options.
    These values can be overridden after initialization through respective properties
    */
    private func setDefaults()
    {
        //Tab View Defaults
        tabViewHeight = 50
        
        tabViewBackgroundColor = UIColor(red: CGFloat(63.0/255.0), green: CGFloat(81.0/255), blue: CGFloat(181.0/255), alpha: 1.0)
        tabViewTextColor = UIColor(red: CGFloat(197.0/255.0), green: CGFloat(202.0/255.0), blue: CGFloat(233.0/255.0), alpha: 1.0)
        tabViewHighlightColor = UIColor(red: CGFloat(92.0/255.0), green: CGFloat(107.0/255.0), blue: CGFloat(192.0/255.0), alpha: 1.0)
        
        tabViewTextHighlightColor = UIColor.whiteColor()
        isEachTabEvenlyDistributed = false
        isTabViewHighlightAvailable = false
        fitAllTabsInView = false
        
        //Tab Indicator View Defaults
        tabIndicatorViewBackgroundColor = UIColor(red: CGFloat(239.0/255.0), green: CGFloat(83.0/255.0), blue: CGFloat(80.0/255.0), alpha: 1.0)
        tabIndicatorViewHeight = 3
        isTabIndicatorViewAvailable = true
        
        // Tab Label Defaults
        tabLabelPaddingLeft = 10
        tabLabelPaddingRight = 10
        
        //View Pager Defaults
        viewPagerTransitionStyle = UIPageViewControllerTransitionStyle.Scroll
        
    }
    
    
    /*
    Sets remiaining extra defaults from ViewPager Controller
    */
    func setExtraDefaults()
    {
        //width of tabView is automatically width of view pager
        tabViewWidth = dataSource.viewWidth()
    }
    
    /*
    Calculate height of viewpager pages from the given frame
    
    - returns: Height of viewpager in CGFloat
    */
    func getViewPagerHeight() -> CGFloat
    {
        return dataSource!.viewHeight() - tabViewHeight!
    }
    
    /*
    Calculate width of viewpager pages from the given frame
    
    - returns: Width of viewpager in CGFloat
    */
    func getViewPagerWidth() -> CGFloat
    {
        return dataSource!.viewWidth()
    }
    
    
}