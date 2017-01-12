//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit
import Foundation

class ViewPagerOptions {
    
    fileprivate var viewPagerHeight:CGFloat!
    fileprivate var viewPagerWidth:CGFloat!
    fileprivate let viewPagerFrame:CGRect!
    
    // Tabs Customization
    var tabType:ViewPagerTabType!
    var isTabHighlightAvailable:Bool!
    var isTabIndicatorAvailable:Bool!
    var tabViewBackgroundDefaultColor:UIColor!
    var tabViewBackgroundHighlightColor:UIColor!
    var tabViewTextDefaultColor:UIColor!
    var tabViewTextHighlightColor:UIColor!
    
    // Booleans
    var isEachTabEvenlyDistributed:Bool!
    var fitAllTabsInView:Bool!                  /* Overrides isEachTabEvenlyDistributed */
    
    // Tab Properties
    var tabViewHeight:CGFloat!
    var tabViewWidth:CGFloat!
    var tabViewPaddingLeft:CGFloat!
    var tabViewPaddingRight:CGFloat!
    var tabViewTextFont:UIFont!
    var tabViewImageSize:CGSize!
    var tabViewImageMarginTop:CGFloat!
    var tabViewImageMarginBottom:CGFloat!
    
    // Tab Indicator
    var tabIndicatorViewHeight:CGFloat!
    var tabIndicatorViewBackgroundColor:UIColor!
    
    // ViewPager
    var viewPagerTransitionStyle:UIPageViewControllerTransitionStyle!
    var viewPagerPosition:CGPoint!
    
    /**
     * Initializes Options for ViewPager. The frame of the supplied UIView in view parameter is
     * used as reference for ViewPager width and height.
     */
    init(viewPagerWithFrame frame:CGRect) {
        self.viewPagerFrame = frame
        initDefaults()
    }
    
    fileprivate func initDefaults() {
        
        // TabView
        tabType = ViewPagerTabType.basic
        
        self.tabViewHeight = 50
        self.tabViewWidth = viewPagerFrame.size.width
        
        self.tabViewBackgroundDefaultColor = Color.tabViewBackground
        self.tabViewBackgroundHighlightColor = Color.tabViewHighlight
        self.tabViewTextDefaultColor = Color.textDefault
        self.tabViewTextHighlightColor = Color.textHighlight
        
        self.tabViewPaddingLeft = 10
        self.tabViewPaddingRight = 10
        
        self.isEachTabEvenlyDistributed = false
        self.isTabHighlightAvailable = false
        self.isTabIndicatorAvailable = true
        self.fitAllTabsInView = false
        
        self.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        self.tabViewImageSize = CGSize(width: 25, height: 25)
        self.tabViewImageMarginTop = 5                                          // used incase of imageWithText
        self.tabViewImageMarginBottom = 5                                       // used incase of imageWithText
        
        // ViewPager
        self.viewPagerWidth = viewPagerFrame.size.width
        self.viewPagerHeight = viewPagerFrame.size.height - tabViewHeight
        self.viewPagerPosition = viewPagerFrame.origin
        self.viewPagerTransitionStyle = UIPageViewControllerTransitionStyle.scroll
        
        // Tab Indicator
        self.tabIndicatorViewHeight = 3
        self.tabIndicatorViewBackgroundColor = Color.tabIndicator
    }
    
    /*--------------------------
     MARK:- Helper Getters
     ---------------------------*/
    
    func getViewPagerHeight() -> CGFloat {
        return self.viewPagerHeight
    }
    
    func getViewPagerWidth() -> CGFloat {
        return self.viewPagerWidth
    }
    
    fileprivate struct Color {
        
        static let tabViewBackground = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        static let tabViewHighlight = UIColor(colorLiteralRed: 129.0/255.0, green: 165.0/255.0, blue: 148.0/255.0, alpha: 1.0)
        static let textDefault = UIColor.black
        static let textHighlight = UIColor.white
        static let tabIndicator = UIColor(colorLiteralRed: 255.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
}

