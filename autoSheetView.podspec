Pod::Spec.new do |s|

s.name              = "autoSheetView"     # 工程名
s.version           = "0.0.5"           # 版本号
s.module_name = 'autoSheetView'                #模块名称
s.summary           = "Swift commonly"   # 描述
s.description           = "Swift commonly 0.0.5"            # 详细描述
s.author            = { "rui" => "782924665@qq.com" }       # 作者信息
s.platform          = :ios, "8.0"                   # 最低支持的iOS版本
s.license           = { :type => 'MIT', :file => 'LICENSE' }    # 证书信息
s.homepage          = "https://github.com/rui2356894/autoSheetView.git" # 主页信息
s.source            = { :git => "https://github.com/rui2356894/autoSheetView.git", :tag => "#{s.version}" } # 下载地址
s.requires_arc          = true          # 是否是自动引用计数ARC
s.frameworks            = 'UIKit'       # 引入基础库
s.swift_version = "5.0"                 #使用的swift版本
s.source_files = "source/*.swift"
end
