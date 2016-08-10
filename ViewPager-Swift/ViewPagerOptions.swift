//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import Foundation
import UIKit


class ViewPagerOptions
{
    // MARK: Private Properties
    private var viewPagerHeight:CGFloat!
    private var viewPagerWidth:CGFloat!
    
    var anchorView:UIView
    
    //MARK: Booleans 
    
    var isTabViewHighlightAvailable:Bool!
    var isTabIndicatorViewAvailable:Bool!
    var isEachTabEvenlyDistributed: Bool!
    var fitAllTabsInView:Bool!                              /* Overrides isEachTabEvenlyDistributed */
    
    //MARK: Tab View Properties
    
    var tabViewHeight:CGFloat!
    var tabViewWidth:CGFloat!
    var tabViewBackgroundDefaultColor:UIColor!
    var tabViewBackgroundHighlightColor:UIColor!
    var tabViewTextDefaultColor:UIColor!
    var tabViewTextHighlightColor:UIColor!
    var tabLabelPaddingLeft:CGFloat!
    var tabLabelPaddingRight:CGFloat!
    
    
    //MARK: Tab Indicator Properties
    
    var tabIndicatorViewHeight:CGFloat!
    var tabIndicatorViewBackgroundColor:UIColor!
    
    //MARK: View Pager Properties
    var viewPagerTransitionStyle:UIPageViewControllerTransitionStyle!
    
    
    /**
     Initializes Options for ViewPager. The frame of the supplied UIView in view parameter is used as reference for
     ViewPager width and height.
     */
    init(inView view:UIView)
    {
        self.anchorView = view
        
        initDefaults()
    }
   
    /**
     Initializes various properties to its default values
    */
    private func initDefaults()
    {
        //Tab View Defaults
        self.tabViewHeight = 50
        self.tabViewWidth = self.anchorView.bounds.size.width
        
        //View Pager
        self.viewPagerWidth = self.anchorView.bounds.size.width
        self.viewPagerHeight = self.anchorView.bounds.size.height - tabViewHeight
        
        self.tabViewBackgroundDefaultColor = UIColor(red: CGFloat(63.0/255.0), green: CGFloat(81.0/255), blue: CGFloat(181.0/255), alpha: 1.0)
        self.tabViewBackgroundHighlightColor = UIColor(red: CGFloat(92.0/255.0), green: CGFloat(107.0/255.0), blue: CGFloat(192.0/255.0), alpha: 1.0)
        self.tabViewTextDefaultColor = UIColor(red: CGFloat(197.0/255.0), green: CGFloat(202.0/255.0), blue: CGFloat(233.0/255.0), alpha: 1.0)
        self.tabViewTextHighlightColor = UIColor.whiteColor()        
        
        self.isTabViewHighlightAvailable = false
        self.isEachTabEvenlyDistributed = false
        self.isTabIndicatorViewAvailable = true
        self.fitAllTabsInView = false
        
        //Tab Indicator View Defaults
        self.tabIndicatorViewHeight = 3
        self.tabIndicatorViewBackgroundColor = UIColor(red: CGFloat(239.0/255.0), green: CGFloat(83.0/255.0), blue: CGFloat(80.0/255.0), alpha: 1.0)
        
        
        // Tab Label Defaults
        self.tabLabelPaddingLeft = 10
        self.tabLabelPaddingRight = 10
        
        //View Pager Defaults
        self.viewPagerTransitionStyle = UIPageViewControllerTransitionStyle.Scroll
        
    }
    
    // Getters
    
    func getViewPagerHeight() -> CGFloat
    {
        return self.viewPagerHeight
    }
    
    func getViewPagerWidth() -> CGFloat
    {
        return self.viewPagerWidth
    }
    
    
}