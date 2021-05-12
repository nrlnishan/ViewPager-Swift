Pod::Spec.new do |s|
  s.name             = 'ViewPager-Swift'
  s.version          = '2.0.2'
  s.summary          = 'Simple View Pager library for swift using UIPageViewController and Scroll View.'
 
  s.description      = <<-DESC
  An easy to use view pager library for iOS in Swift based on UIPageViewController and Scroll View along with multiple customization options and tap as well as swipe gesture for changing between pages.This fantastic view changes its color gradually makes your app look fantastic!
                       DESC
 
  s.homepage         = 'https://github.com/nrlnishan/ViewPager-Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nishan Niraula' => 'githubnrlnishan@gmail.com' }
  s.source           = { :git => 'https://github.com/nrlnishan/ViewPager-Swift.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '12.0'
  s.source_files = 'ViewPager-Swift/Core/*.swift'
  s.swift_version = '5.4'
 
end
