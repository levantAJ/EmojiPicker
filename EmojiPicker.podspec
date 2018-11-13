Pod::Spec.new do |s|
  s.name = 'EmojiPicker'
  s.version = '1.0'
  s.summary = 'Emoji Picker'
  s.description = <<-DESC
Emoji picker written on Swift 4.2 by levantAJ
                       DESC
  s.homepage = 'https://github.com/levantAJ/EmojiPicker'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Tai Le' => 'sirlevantai@gmail.com' }
  s.source = { :git => 'https://github.com/levantAJ/EmojiPicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'EmojiPicker/**/*.{swift}'
  s.resources = "EmojiPicker/**/*.{storyboard,xib,json,xcassets,lproj}"
  
end