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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.None
        self.title = "Awesome View pager"
        
        let options = ViewPagerOptions(inView: self.view)
        options.isEachTabEvenlyDistributed = true
        options.isTabViewHighlightAvailable = true
        
        let viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
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