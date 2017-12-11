//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit
import Foundation

public class ViewPagerOptions {
    
    internal var viewPagerFrame:CGRect = CGRect.zero
    
    // Tabs Customization
    var tabType:ViewPagerTabType = .basic
    var isTabHighlightAvailable:Bool = false
    var isTabIndicatorAvailable:Bool = true
    var tabViewBackgroundDefaultColor:UIColor = Color.tabViewBackground
    var tabViewBackgroundHighlightColor:UIColor = Color.tabViewHighlight
    var tabViewTextDefaultColor:UIColor = Color.textDefault
    var tabViewTextHighlightColor:UIColor = Color.textHighlight
    
    // Booleans
    
    /// Width of each tab is equal to the width of the largest tab. Tabs are laid out from Left - Right and are scrollable
    var isEachTabEvenlyDistributed:Bool = false
    /// All the tabs are squeezed to fit inside the screen width. Tabs are not scrollable. Also it overrides isEachTabEvenlyDistributed
    var fitAllTabsInView:Bool = false
    
    // Tab Properties
    var tabViewHeight:CGFloat = 50.0
    var tabViewPaddingLeft:CGFloat = 10.0
    var tabViewPaddingRight:CGFloat = 10.0
    var tabViewTextFont:UIFont = UIFont.systemFont(ofSize: 16)
    var tabViewImageSize:CGSize = CGSize(width: 25, height: 25)
    var tabViewImageMarginTop:CGFloat = 5
    var tabViewImageMarginBottom:CGFloat = 5
    
    // Tab Indicator
    var tabIndicatorViewHeight:CGFloat = 3
    var tabIndicatorViewBackgroundColor:UIColor = Color.tabIndicator
    
    // ViewPager
    var viewPagerTransitionStyle:UIPageViewControllerTransitionStyle = .scroll
    
    /**
     * Initializes Options for ViewPager. The frame of the supplied UIView in view parameter is
     * used as reference for ViewPager width and height.
     */
    init(viewPagerWithFrame frame:CGRect) {
        self.viewPagerFrame = frame
    }
    
    fileprivate struct Color {
        
        static let tabViewBackground = UIColor.from(r: 230.0, g: 230, b: 220)
        static let tabViewHighlight = UIColor.from(r: 129, g: 165, b: 148)
        static let textDefault = UIColor.black
        static let textHighlight = UIColor.white
        static let tabIndicator = UIColor.from(r: 255, g: 102, b: 0)
    }
}

fileprivate extension UIColor {
    
    class func from(r: CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
