//
//  TestViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan Niraula on 4/13/19.
//  Copyright © 2019 Nishan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var tabs = [ViewPagerTab]()
    
    var options: ViewPagerOptions?
    var pager:ViewPager?
    
    override func loadView() {
        
        let newView = UIView()
        newView.backgroundColor = UIColor.groupTableViewBackground
        
        view = newView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let options = self.options else { return }
        
        pager = ViewPager(viewController: self)
        pager?.setOptions(options: options)
        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)
        pager?.build()
    }
}

extension TestViewController: ViewPagerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        let vc = ItemViewController()
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

extension TestViewController: ViewPagerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
