//
//  MainViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var titles = ["COFFEE","DONUT","PIZZA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.None
        self.title = "Awesome View pager"
        
        
        let options = ViewPagerOptions()
        options.isTabViewHighlightAvailable = false
        options.fitAllTabsInView = true
        options.isTabViewHighlightAvailable = true
        
        let viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        viewPager.view.frame = self.view.frame
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMoveToParentViewController(self)
        
   }
    
}


extension MainViewController: ViewPagerControllerDataSource
{
    
    func numberOfPages() -> Int
    {
        return titles.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController
    {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ItemViewController") as! ItemViewController
        vc.itemText = "Page \(titles[position])"
        return vc
    }
    
    func pageTitles() -> [String]
    {
        return titles
    }
    
}

extension MainViewController: ViewPagerControllerDelegate
{
    func willMoveToViewControllerAtIndex(index:Int)
    {
        print("Will Move To VC: \(index)")
    }
    
    func didMoveToViewControllerAtIndex(index:Int)
    {
        print("Did Move To VC: \(index)")
    }
    
    

}