
Pod::Spec.new do |s|
  s.name                      = 'Popup'
  s.version                   = '1.0.0'
  s.summary                   = 'A multi-directional card swiping library inspired by Tinder and TanTan.'
  s.homepage                  = 'https://github.com/liujunliuhong/DragCardContainer'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source                    = { :git => 'https://github.com/liujunliuhong/DragCardContainer.git', :tag => s.version.to_s }
  s.module_name               = 'Popup'
  s.swift_version             = '5.0'
  s.platform                  = :ios, '11.0'
  s.ios.deployment_target     = '11.0'
  s.requires_arc              = true
  s.source_files              = 'Popup/Sources/*.swift'
end
