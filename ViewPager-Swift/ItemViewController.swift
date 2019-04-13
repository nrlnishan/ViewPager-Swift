//
//  ItemViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    override func loadView() {
        
        let newView = UIView()
        newView.backgroundColor = UIColor.orange
        
        view = newView
    }

    var itemText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let itemLabel = UILabel()
        itemLabel.setupForAutolayout(inView: self.view)
        itemLabel.textAlignment = .center
        itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        itemLabel.text = itemText
    }
}

