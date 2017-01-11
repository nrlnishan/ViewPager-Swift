//
//  MainViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    //var titles = ["COFFEE", "DONUT"]
    var titles = ["COFFEE","DONUT","PIZZA","FISH AND CHIPS","FRENCH FRIES"]
    
    let tabs = [
        ViewPagerTab(title: "COFFEE", image: UIImage(named: "tree1")),
        ViewPagerTab(title: "DONUT", image: UIImage(named: "tree2")),
        ViewPagerTab(title: "PIZZA", image: UIImage(named: "tree3")),
        ViewPagerTab(title: "FISH AND CHIPS", image: UIImage(named: "tree1")),
        ViewPagerTab(title: "FRENCH FRIES", image: UIImage(named: "tree2"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        self.title = "Awesome View pager"
        
        let options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.imageWithText
        options.isEachTabEvenlyDistributed = true
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14)
        
        /*
         3 CASE
         
         1. distributeNormally
         2. distributeEvenly 
         3. FitAllTabs
         */
        
        
        
        let viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }
    
}


extension MainViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(_ position:Int) -> UIViewController {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        vc.itemText = "Page \(titles[position])"
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
}

extension MainViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(_ index:Int) {
        print("Will Move To VC: \(index)")
    }
    
    func didMoveToControllerAtIndex(_ index: Int) {
        print("Did Move to VC: \(index) ")
    }
    
}
