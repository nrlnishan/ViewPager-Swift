//
//  ItemViewController.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    
    @IBOutlet weak var itemLabel: UILabel!
    var itemText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemLabel.text = itemText!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
