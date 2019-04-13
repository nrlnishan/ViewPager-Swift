//
//  MainViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections = ["Basic Tab","Image Tab","Image And Text Tab"]
    var distributions = ["Distribution: Normal","Distribution: Equal","Distribution: Segmented"]
    
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
    
    var tabs3 = [
        ViewPagerTab(title: "Fries", image: UIImage(named: "fries")),
        ViewPagerTab(title: "Hamburger", image: UIImage(named: "hamburger")),
        ViewPagerTab(title: "Beer", image: UIImage(named: "pint")),
        ViewPagerTab(title: "Pizza", image: UIImage(named: "pizza")),
        ViewPagerTab(title: "Orange", image: UIImage(named: "orange")),
        ViewPagerTab(title: "Sandwich", image: UIImage(named: "sandwich"))
    ]
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    var pager: ViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        tableView.dataSource = self
        tableView.delegate = self
       
        let options = ViewPagerOptions()
        options.tabType = .basic
        options.distribution = .normal
        
    }
    
    func displayViewPager(indexPath: IndexPath) {
        
        let options = ViewPagerOptions()
        var tabs = [ViewPagerTab]()
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            // Basic Tab
            
            tabs = tabs1
            options.tabType = .basic
            options.distribution = .normal
            
            
        case (0,1):
            
            tabs = tabs1
            options.tabType = .basic
            options.distribution = .equal
            
        case (0,2):
            
            tabs = tabs1
            options.tabType = .basic
            options.distribution = .segmented
            
        case (1,0):
            
            tabs = tabs2
            options.tabType = .image
            options.distribution = .normal
            
            
        case (1,1):
            
            tabs = tabs2
            options.tabType = .image
            options.distribution = .equal
            
        case (1,2):
            
            tabs = tabs2
            options.tabType = .image
            options.distribution = .segmented
        
        case (2,0):
            
            tabs = tabs3
            options.tabType = .imageWithText
            options.distribution = .normal
            
            
        case (2,1):
            
            tabs = tabs3
            options.tabType = .imageWithText
            options.distribution = .equal
            
        case (2,2):
            
            tabs = tabs3
            options.tabType = .imageWithText
            options.distribution = .segmented
            
        default:
            break
        }
        
        let controller = TestViewController()
        controller.options = options
        controller.tabs = tabs
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        cell.textLabel?.text = distributions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.displayViewPager(indexPath: indexPath)
    }
}

