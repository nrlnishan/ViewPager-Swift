//
//  MainViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let tabs1 = [
        ViewPagerTab(title: "Apple", image: UIImage(named: "apple")),
        ViewPagerTab(title: "Carrot", image: UIImage(named: "carrot")),
        ViewPagerTab(title: "Grapes", image: UIImage(named: "grapes")),
        ViewPagerTab(title: "Lemon", image: UIImage(named: "lemon")),
        ViewPagerTab(title: "Orange", image: UIImage(named: "orange")),
        ViewPagerTab(title: "Strawberry", image: UIImage(named: "strawberry")),
        ViewPagerTab(title: "Watermelon", image: UIImage(named: "watermelon"))
    ]
    
    let tabs2 = [
        ViewPagerTab(title: "Cheese", image: UIImage(named: "cheese")),
        ViewPagerTab(title: "Cupcake", image: UIImage(named: "cupcake")),
        ViewPagerTab(title: "Doughnut", image: UIImage(named: "doughnut")),
        ViewPagerTab(title: "Fish", image: UIImage(named: "fish")),
        ViewPagerTab(title: "Meat", image: UIImage(named: "meat")),
        ViewPagerTab(title: "Milk", image: UIImage(named: "milk")),
        ViewPagerTab(title: "Water", image: UIImage(named: "water"))
    ]
    
    var tabs = [
        ViewPagerTab(title: "Fries", image: UIImage(named: "fries")),
        ViewPagerTab(title: "Hamburger", image: UIImage(named: "hamburger")),
        ViewPagerTab(title: "Beer", image: UIImage(named: "pint")),
        ViewPagerTab(title: "Pizza", image: UIImage(named: "pizza")),
        ViewPagerTab(title: "Orange", image: UIImage(named: "orange")),
        ViewPagerTab(title: "Sandwich", image: UIImage(named: "sandwich"))
    ]
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.title = "Awesome View pager"
        
        options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.imageWithText
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        options.viewPagerFrame = self.view.bounds
    }    
}


extension MainViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        vc.itemText = "\(tabs[position].title)"
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension MainViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
