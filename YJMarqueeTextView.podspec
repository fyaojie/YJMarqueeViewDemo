
Pod::Spec.new do |spec|

  spec.name         = "YJMarqueeTextView"
  spec.version      = "0.0.1"
  spec.summary      = "基于swift 循环视图实现"

  spec.description  = "跑马灯,使用更方便, 支持自定义  目前主要是文字方面的跑马灯效果"

  spec.homepage     = "https://github.com/fyaojie"

  # s.license      = "MIT"
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  

  spec.author       = { "odreamboy" => "562925462@qq.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/fyaojie/YJMarqueeViewDemo.git", :tag => spec.version }

  spec.source_files  = "YJMarqueeTextView/*.swift"
  
  spec.swift_version= "5.0"
  spec.requires_arc = true
  spec.dependency 'Masonry', '1.1.0'
  spec.dependency 'YJCycleCollectionView', '0.0.1'
end
