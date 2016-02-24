<h1 id="viewpager-swift">ViewPager-Swift</h1>

<p>An easy to use view pager library for iOS in Swift based on UIPageViewController and Scroll View along with multiple customization options and tap as well as swipe gesture for changing between pages.</p>



<h2 id="installation">Installation</h2>

<p>Just add ViewPagerController.swift and ViewPagerOptions.swift file to your project.Both files are present inside ViewPager-Swift directory.</p>

<h2 id="how-to-use">How to use</h2>

<ol>
<li>Customize your View Pager with the help of ViewPagerOptions class</li>
<li>Pass that options to ViewPagerController and set its frame and datasource</li>
<li>That’s it</li>
</ol>

<blockquote>
  <p>1. <br>
  // During its initialization, default options are set for view pager. So just this single line is enough if you want to use default configuration <br>
  <em>let myOptions= ViewPagerOptions()</em></p>
  
  <p>//For customization,</p>
  
  <p>//If I want my tabs to be of equal width <br>
  <em>myOptions.isEachTabEvenlyDistributed = true</em></p>
  
  <p>//If I don’t want my tab to get highlighted for page <br>
  <em>myOptions.isTabViewHighlightAvailable = false</em></p>
  
  <p>//If I want indicator bar to show below current page tab <br>
  <em>myOptions.isTabIndicatorViewAvailable= true</em></p>
  
  <p>//Oh! and let’s change color of tab to red <br>
  <em>myOptions.tabViewBackgroundColor = UIColor.redColor()</em> <br>
  //and many more customization…</p>
  
  <p>2. <br>
  <em>let viewPager = ViewPagerController()</em> <br>
  <em>viewPager.options = myOptions</em> <br>
  <em>viewPager.dataSource = self</em> <br>
  //and let its frame be <br>
  <em>viewPager.view.frame = self.view.frame</em>   </p>
  
  <p>//Now let me add this to my viewcontroller <br>
  <em>self.addChildViewController(viewPager)</em> <br>
  <em>self.view.addSubView(viewPager.view)</em> <br>
  <em>viewPager.didMoveToParentViewController(self)</em></p>
  
  <p>That’s it.  Conform to <strong>ViewPagerControllerDataSource</strong> and you are good to go. If you want you can conform to <strong>ViewPagerDelegate</strong> to receive additional feedbacks.</p>
</blockquote>

<p><strong>DataSource</strong></p>

<blockquote>
  <p>//let’s set datasource <br>
  <em>viewPager.dataSource= self</em></p>
  
  <p>//Okay let me provide it with number of pages required <br>
  <em>func numberOfPages()-&gt;Int</em></p>
  
  <p>//Yayy! I can provide different view controller for different page  <br>
  <em>func viewControllerAtPosition(position:Int)-&gt;UIViewController</em></p>
  
  <p>//let me provide titles for all page <br>
  <em>func pageTitles() -&gt; [String]</em></p>
  
  <p>//Yayy! I can start from any page <br>
  <em>optional func startViewPagerAtIndex()-&gt;Int</em></p>
</blockquote>

<p><strong>Delegate</strong></p>

<blockquote>
  <p>//Let’s set delegate <br>
  <em>viewPager.delegate = self</em></p>
  
  <p>//Called when transition to another view controller starts but is not completed <br>
  <em>optional func willMoveToViewControllerAtIndex(index:Int)</em></p>
  
  <p>//called when transiton to another view controller is completed <br>
  <em>optional func didMoveToViewControllerAtIndex(index:Int)</em></p>
</blockquote>

<h2 id="customization">Customization</h2>

<p>You can perform lots of customization. If you want to look under the hoods, all the <strong>public variables</strong> inside ViewPagerOptions.swift file is customizable.</p>

<blockquote>
  <p><strong>Tab Indicator:</strong> Horizontal bar of small thickness which is displayed under tab for current page</p>
  
  <p><strong>TabView:</strong> Horizontal bar which contains names of pages.</p>
  
  <p><strong>TabLabel:</strong> Each individual tab containing page name</p>
</blockquote>

<p><strong>Booleans:</strong></p>

<p>Whether to highlight tab for current page or not, Default is false</p>

<blockquote>
  <p>isTabViewHighlightAvailable:Bool</p>
</blockquote>

<p>Whether to display tab indicator or not, Default is true</p>

<blockquote>
  <p>isTabIndicatorViewAvailable:Bool</p>
</blockquote>

<p>Whether to distribute tabs of even width, If set to true, each tabs width will be equal to largest tab. Default is false.</p>

<blockquote>
  <p>isEachTabEvenlyDistributed:Bool</p>
</blockquote>

<p>Whether to fit all tabs in Screen or not. If set to true, all tabs are squeezed to fit inside frame of view pager.Default is false</p>

<blockquote>
  <p>fitAllTabsInView:Bool</p>
</blockquote>

<p><strong>Tab View and Tab Indicator</strong> <br>
Height for tab, Default is 50</p>

<blockquote>
  <p>tabViewHeight:CGFloat</p>
</blockquote>

<p>Width for whole tab View, Default is size of viewpager frame</p>

<blockquote>
  <p>tabViewWidth:CGFloat</p>
</blockquote>

<p>Background Color for whole tab View</p>

<blockquote>
  <p>tabViewBackgroundColor:UIColor</p>
</blockquote>

<p>Background Color for current tab. Only displays if isTabViewHighlightAvailable is set to true</p>

<blockquote>
  <p>tabViewHighlightColor:UIColor</p>
</blockquote>

<p>Color for each page title </p>

<blockquote>
  <p>tabViewTextColor:UIColor</p>
</blockquote>

<p>Color for text for current tab</p>

<blockquote>
  <p>tabViewTextHighlightColor:UIColor</p>
</blockquote>

<p>Padding for each tab, Default is 10</p>

<blockquote>
  <p>tabLabelPaddingLeft:CGFloat <br>
  tabLabelPaddingRight:CGFloat</p>
</blockquote>

<p>Height of tab indicator, Default is 3</p>

<blockquote>
  <p>tabIndicatorViewHeight:CGFloat</p>
</blockquote>

<p>Background Color for tab Indicator</p>

<blockquote>
  <p>tabIndicatorViewBackgroundColor:UIColor</p>
</blockquote>

<p><strong>View Pager</strong></p>

<p>Transition style for each page, Default is scroll</p>

<blockquote>
  <p>viewPagerTransitionStyle:UIPageViewControllerTransitionStyle</p>
</blockquote>

<h2 id="license">License</h2>

<p>The MIT License (MIT)</p>

<p>Copyright (c) 2016 nrlnishan</p>

<p>Permission is hereby granted, free of charge, to any person obtaining a copy <br>
of this software and associated documentation files (the “Software”), to deal <br>
in the Software without restriction, including without limitation the rights <br>
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell <br>
copies of the Software, and to permit persons to whom the Software is <br>
furnished to do so, subject to the following conditions:</p>

<p>The above copyright notice and this permission notice shall be included in all <br>
copies or substantial portions of the Software.</p>

<p>THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR <br>
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, <br>
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE <br>
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER <br>
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, <br>
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE <br>
SOFTWARE.</p>