//
//  ViewPager.swift
//  ViewPager-Swift
//
//  Created by Nishan Niraula on 4/11/19.
//  Copyright © 2019 Nishan. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewPagerDataSource {
    
    /// Number of pages to be displayed
    func numberOfPages() -> Int
    
    /// ViewController for required page position
    func viewControllerAtPosition(position:Int) -> UIViewController
    
    /// Tab structure of the pages
    func tabsForPages() -> [ViewPagerTab]
    
    /// UIViewController which is to be displayed at first. Default is 0
    func startViewPagerAtIndex()->Int
}

public protocol ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int)
    func didMoveToControllerAtIndex(index:Int)
}

class ViewPager {
    
    public weak var dataSource:ViewPagerControllerDataSource?
    public weak var delegate:ViewPagerControllerDelegate?
    
    private var options = ViewPagerOptions()
    private weak var view: UIView?
    
    init(inView containerView: UIView) {
        self.view = containerView
    }
    
    func setOptions(options: ViewPagerOptions) {
        self.options = options
    }
    
    func setup() {
        
    }
    
}

// let viewPager = ViewPager()
// viewPager.setup()
