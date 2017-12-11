ViewPager-Swift
===================
 
An easy to use view pager library for iOS in Swift based on UIPageViewController and Scroll View along with multiple customization options and tap as well as swipe gesture for changing between pages.

## Installation ##

>**NOTE:** **Master** branch contains project support for Swift 4. If you are looking for Swift 3.* version, Please use release version 1.1.1. Also support for Swift 2.2 is removed.

Add 

1. ViewPagerController.swift
2. ViewPagerOptions.swift 
3. ViewPagerTab.swift
4. ViewPagerTabView.swift 

files in your project.All files are present inside ViewPager-Swift/Core directory.

## Screenshots ##

![Screenshot-without-basic-tab-view](/Screenshots/Screenshot-1-new.png?raw=true)
![Screenshot-with-image-tab-view](/Screenshots/Screenshot-2-new.png?raw=true)
![Screenshot-with-image-with-text-tab-view](/Screenshots/Screenshot-3-new.png?raw=true)
![Screenshot-without-tab-highlight](/Screenshots/screenshot-4-new.png?raw=true)

## How to use ##

>1. Customize your View Pager with the help of ViewPagerOptions class
>2. Pass that options to ViewPagerController and set its datasource
>3. That's it

1. 
During its initialization, default options are set for view pager. So just this single line is enough if you want to use default configuration.
```
let myOptions= ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
```

For further customization,
```
// Let's show image with text
myOptions.tabType = ViewPagerTabType.imageWithText

// If I want all my tabs to be of equal width
myOptions.isEachTabEvenlyDistributed = true

// If I don't want my tab to get highlighted for page
myOptions.isTabHighlightAvailable = false

// If I want indicator bar to show below current page tab
myOptions.isTabIndicatorAvailable= true

// Oh! and let's change color of tab to red
myOptions.tabViewBackgroundDefaultColor = UIColor.redColor()

// and many more...
```

2.
```
let viewPager = ViewPagerController()
viewPager.options = myOptions
viewPager.dataSource = self

//Now let me add this to my viewcontroller
self.addChildViewController(viewPager)
self.view.addSubView(viewPager.view)
viewPager.didMove(ToParentViewController: self)
```
That's it.  Conform to **ViewPagerControllerDataSource** and you are good to go. If you want, you can conform to **ViewPagerControllerDelegate** to receive additional feedbacks.

**DataSource**

let's set datasource
```
viewPager.dataSource= self

// Okay let me provide it with number of pages required

func numberOfPages() -> Int

// I can provide different view controller for different page 

func viewControllerAtPosition(position:Int) -> UIViewController

// let me provide tabs info for all page

func tabsForPages() -> [ViewPagerTab]

// Yayy! I can start from any page

optional func startViewPagerAtIndex()->Int
```

**Delegate**

Let's set delegate
```
viewPager.delegate = self
```
Called when transition to another view controller starts but is not completed
```
optional func willMoveToControllerAtIndex(index:Int)
```
called when transiton to another view controller is completed
```
optional func didMoveToControllerAtIndex(index:Int)
```

**Additional**

You can also change the page programatically. Suppose you want to display 3rd page.

```
viewpager.displayViewController(atIndex: 2)	// Since index starts from 0
```

Note: If you want the viewpager to show specific page when it loads, use ``` func startViewPagerAtIndex()->Int ``` method from datasource.


Also, you can update any of the viewpager tab. Just update the ViewPagerTab array which you are providing through the datasource. and then call
```
viewpager.invalidateTabs()
```


## Customization ##
You can perform lots of customization. If you want to look under the hoods, all the **public variables** inside ViewPagerOptions.swift file is customizable.

>**Tab Indicator:** Horizontal bar of small thickness which is displayed under tab for current page

>**TabView:** Horizontal bar shown above viewpager which displays image or name of page.


**Booleans:**

Which type of tabs to display
```
tabType:ViewPagerTabType
```
>**basic:** Tab containing only name of the page

>**image:** Tab containing only image for the page

>**imageWithText:** Tab showing image and name (below image) for the page

Whether to highlight tab for current page or not, Default is false
```
isTabHighlightAvailable:Bool
```
Whether to display tab indicator or not, Default is true
```
isTabIndicatorAvailable:Bool
```
Whether to distribute tabs of even width, If set to true, each tabs width will be equal to largest tab. Default is false.
```
isEachTabEvenlyDistributed:Bool
```
Whether to fit all tabs in Screen or not. If set to true, all tabs are squeezed to fit inside frame of view pager.Default is false
```
fitAllTabsInView:Bool
```
**Tab View and Tab Indicator:**

Height for tab, Default is 50
```
tabViewHeight:CGFloat
```
Background Color for whole tab View
```
tabViewBackgroundDefaultColor:UIColor
```
Background Color for current tab. Only displays if isTabViewHighlightAvailable is set to true
```
tabViewBackgroundHighlightColor:UIColor
```
Color for each page title 
```
tabViewTextDefaultColor:UIColor
```
Color for text for current tab
```
tabViewTextHighlightColor:UIColor
```
Padding for each tab, Default is 10
```
tabViewPaddingLeft:CGFloat
tabViewPaddingRight:CGFloat
```
Height of tab indicator, Default is 3
```
tabIndicatorViewHeight:CGFloat
```
Background Color for tab Indicator
```
tabIndicatorViewBackgroundColor:UIColor
```
Font for the text inside tab
```
tabViewTextFont: UIFont
```
Size of the image inside tab. Used incase tabtype is image or imageWithText.
```
tabViewImageSize:CGSize
```
Top and Bottom margin for the image inside tab. Used incase tabtype is imageWithText. Else image is automatically centered inside tab.
```
tabViewImageMarginTop:CGFloat
tabViewImageMarginBottom:CGFloat
```
**View Pager**

Transition style for each page, Default is scroll
```
viewPagerTransitionStyle:UIPageViewControllerTransitionStyle
```


## License ##
The MIT License (MIT)

Copyright (c) 2016 nrlnishan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

