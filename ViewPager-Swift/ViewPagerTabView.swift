//
//  ViewPagerTabView.swift
//  ViewPager-Swift
//
//  Created by AndMine on 1/9/17.
//  Copyright © 2017 Nishan. All rights reserved.
//

import UIKit


class ViewPagerTabView: UIView {
    
    enum SetupCondition {
        case fitAllTabs
        case distributeNormally
    }
    
    var titleLabel:UILabel?
    var imageView:UIImageView?
    
    let r = arc4random_uniform(2) + 1
    /*
     self.backgroundColor = (r == 1) ? UIColor.white : options.tabViewBackgroundDefaultColor
     
     print("LOG: TabViewFrame: \(self.frame)")
     print("LOG: ImageViewFrame: \(imageView?.frame)")
     print("\n")
     */
    
    /*--------------------------
     MARK:- Initialization
     ---------------------------*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     Sets up tabview for ViewPager. The type of tabview is automatically obtained from
     the options passed in this function.
     */
    func setup(tab:ViewPagerTab, options:ViewPagerOptions , condition:SetupCondition) {
        
        switch options.tabType! {
            
        case ViewPagerTabType.basic:
            setupBasicTab(condition: condition, options: options, tab: tab)
            
        case ViewPagerTabType.image:
            setupImageTab(condition: condition, withText: false,options: options, tab:tab)
            
        case ViewPagerTabType.imageWithText:
            setupImageTab(condition: condition, withText: true, options: options, tab:tab)
        }
    }
    
    
    /**
     * Creates tab containing only one label with provided options and add it as subview to this view.
     *
     * Case FitAllTabs: Creates a tabview of provided width. Do not consider the padding provided from options.
     *
     * Case DistributeNormally: Creates a tabview. Width is calculated from title intrinsic size. Considers the padding
     * provided from options too.
     */
    fileprivate func setupBasicTab(condition:SetupCondition, options:ViewPagerOptions, tab:ViewPagerTab) {
        
        switch condition {
            
        case .fitAllTabs:
            
            buildTitleLabel(withOptions: options, text: tab.title)
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            
        case .distributeNormally:
            
            buildTitleLabel(withOptions: options, text: tab.title)
            
            // Resetting TabView frame again with the new width
            var labelWidth = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
            
            let currentFrame = self.frame
            let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: labelWidth, height: currentFrame.height)
            self.frame = newFrame
            
            // Setting TitleLabel frame
            titleLabel?.frame = CGRect(x: 0, y: 0, width: labelWidth, height: currentFrame.height)
            
        }
        
        self.addSubview(titleLabel!)
    }
    
    
    fileprivate func setupImageTab(condition:SetupCondition, withText:Bool, options:ViewPagerOptions, tab:ViewPagerTab) {
        
        
        let imageSize = options.tabViewImageSize!
        
        switch condition {
            
        case .fitAllTabs:
            
            let tabHeight = options.tabViewHeight!
            let tabWidth = self.frame.size.width
            
            if withText {
                
                // Calculate image position
                let xImagePosition:CGFloat = (tabWidth - imageSize.width) / 2
                let yImagePosition:CGFloat = options.tabViewImageMarginTop
                
                // calculating text position
                let xTextPosition:CGFloat = 0
                let yTextPosition:CGFloat = yImagePosition + options.tabViewImageMarginBottom + imageSize.height
                let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
                
                // Creating image view
                imageView = UIImageView()
                imageView?.contentMode = .scaleAspectFit
                imageView?.image = tab.image
                imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition, width: imageSize.width, height: imageSize.height)
                
                // Creating text label
                titleLabel = UILabel()
                titleLabel?.textAlignment = .center
                titleLabel?.textColor = options.tabViewTextDefaultColor
                titleLabel?.font = options.tabViewTextFont
                titleLabel?.text = tab.title
                titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: frame.size.width, height: textHeight)
              
                
                self.addSubview(imageView!)
                self.addSubview(titleLabel!)
                
            } else {
                
                // Calculate image position
                let xPosition = ( tabWidth - imageSize.width ) / 2
                let yPosition = ( tabHeight - imageSize.height ) / 2
                
                // Creating imageview
                imageView = UIImageView()
                imageView?.contentMode = .scaleAspectFit
                imageView?.image = tab.image
                imageView?.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
                
                
                
                self.addSubview(imageView!)
            }
            
            
        case .distributeNormally:
            
            if withText {
                
                /* Width depends upon the size of imageView or the title label, whichever is larger. */
                
                // Creating image view
                imageView = UIImageView()
                imageView?.contentMode = .scaleAspectFit
                imageView?.image = tab.image
                
                // Creating text label
                titleLabel = UILabel()
                titleLabel?.textAlignment = .center
                titleLabel?.textColor = options.tabViewTextDefaultColor
                titleLabel?.font = options.tabViewTextFont
                titleLabel?.text = tab.title
                
                // Resetting tabview frame again with the new width
                let widthFromImage = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                let widthFromText = titleLabel!.intrinsicContentSize.width + options.tabViewPaddingLeft + options.tabViewPaddingRight
                let tabWidth = (widthFromImage > widthFromText ) ? widthFromImage : widthFromText
                let currentFrame = self.frame
                let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: tabWidth, height: currentFrame.height)
                self.frame = newFrame
                
                // Setting imageview frame
                let xImagePosition:CGFloat  = (tabWidth - imageSize.width) / 2
                let yImagePosition:CGFloat = options.tabViewImageMarginTop
                imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition , width: imageSize.width, height: imageSize.height)
                
                // Setting titleLabel frame
                let xTextPosition:CGFloat = 0
                let yTextPosition = yImagePosition + options.tabViewImageMarginBottom + imageSize.height
                let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
                titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: tabWidth, height: textHeight)
                
               
                
                self.addSubview(imageView!)
                self.addSubview(titleLabel!)
                
            } else {
                
                // Creating imageview
                imageView = UIImageView()
                imageView?.contentMode = .scaleAspectFit
                imageView?.image = tab.image
                
                // Resetting TabView frame again with the new width
                let tabWidth = imageSize.width + options.tabViewPaddingRight + options.tabViewPaddingLeft
                
                let currentFrame = self.frame
                let newFrame = CGRect(x: currentFrame.origin.x, y: currentFrame.origin.y, width: tabWidth, height: currentFrame.height)
                self.frame = newFrame
                
                // Setting ImageView Frame
                let xPosition = ( tabWidth - imageSize.width ) / 2
                let yPosition = (options.tabViewHeight - imageSize.height ) / 2
                
                imageView?.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
                
                self.addSubview(imageView!)
            }
        }
        
    }
    
    /**
     Updates the frame of the current tab view incase of EvenlyDistributedCondition. Also propagates those
     changes to titleLabel and imageView based on ViewPagerTabType.
     */
    func updateFrame(atIndex index:Int, withWidth width:CGFloat, options:ViewPagerOptions) {
        
        // Updating frame of the TabView
        let tabViewCurrentFrame = self.frame
        let tabViewXPosition = CGFloat(index) * width
        let tabViewNewFrame = CGRect(x: tabViewXPosition, y: tabViewCurrentFrame.origin.y, width: width, height: tabViewCurrentFrame.height)
        self.frame = tabViewNewFrame
        
        switch options.tabType! {
            
        case .basic:
            
            // Updating frame for titleLabel
            titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.setNeedsUpdateConstraints()
            
        case .image:
            
            // Updating frame for ImageView
            let xPosition = ( width - options.tabViewImageSize.width ) / 2
            let yPosition = (options.tabViewHeight - options.tabViewImageSize.height ) / 2
            imageView?.frame = CGRect(x: xPosition, y: yPosition, width: options.tabViewImageSize.width, height: options.tabViewImageSize.height)
            
            self.setNeedsUpdateConstraints()
            
        case .imageWithText:
            
            // Setting imageview frame
            let xImagePosition:CGFloat  = (width - options.tabViewImageSize.width) / 2
            let yImagePosition:CGFloat = options.tabViewImageMarginTop
            imageView?.frame = CGRect(x: xImagePosition, y: yImagePosition , width: options.tabViewImageSize.width, height: options.tabViewImageSize.height)
            
            // Setting titleLabel frame
            let xTextPosition:CGFloat = 0
            let yTextPosition = yImagePosition + options.tabViewImageMarginBottom + options.tabViewImageSize.height
            let textHeight:CGFloat = options.tabViewHeight - yTextPosition - options.tabIndicatorViewHeight
            titleLabel?.frame = CGRect(x: xTextPosition, y: yTextPosition, width: width, height: textHeight)
            

            self.setNeedsUpdateConstraints()
        }
        
    }
    
    /*--------------------------
     MARK:- Helper Methods
     ---------------------------*/
    
    func buildTitleLabel(withOptions options:ViewPagerOptions, text:String) {
        
        titleLabel = UILabel()
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = options.tabViewTextDefaultColor
        titleLabel?.font = options.tabViewTextFont
        titleLabel?.text = text
    }
    
    func buildImageView(withOptions options:ViewPagerOptions, image:UIImage) {
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.image = image
    }
    
    
}
