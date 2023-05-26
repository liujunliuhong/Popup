
Pod::Spec.new do |s|
  s.name                      = 'Popup'
  s.version                   = '1.0.0'
  s.summary                   = 'A small and flexible custom pop-up view that can be used as a custom alertView, pop-up window, etc.'
  s.homepage                  = 'https://github.com/liujunliuhong/Popup'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source                    = { :git => 'https://github.com/liujunliuhong/Popup.git', :tag => s.version.to_s }
  s.module_name               = 'Popup'
  s.swift_version             = '5.0'
  s.platform                  = :ios, '11.0'
  s.ios.deployment_target     = '11.0'
  s.requires_arc              = true
  s.source_files              = 'Popup/Sources/*.swift'
end
