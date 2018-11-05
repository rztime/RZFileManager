Pod::Spec.new do |s|
  s.name         = "RZFileManager"
  s.version      = "0.0.5"
  s.summary      = "文件下载及缓存数据到数据库和本地的管理"

  s.description  = <<-DESC
                   对文件的下载及数据库保存 
                   DESC
  s.homepage     = "https://github.com/rztime/RZFileManager"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "rztime" => "rztime@vip.qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/rztime/RZFileManager.git", :tag => "#{s.version}" }


  s.source_files  = "RZFileManager/RZFileManager/**/*.{h,m}"
  s.resources = "RZFileManager/RZFileManager/**/*.{bundle}"
  s.dependency 'AFNetworking'
  s.dependency 'RZFMDB'
  
  s.prefix_header_contents = <<-EOS
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
EOS
  
end
