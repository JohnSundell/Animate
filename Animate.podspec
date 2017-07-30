Pod::Spec.new do |s|
  s.name         = "Animate"
  s.version      = "1.0"
  s.summary      = "Declarative UIView animations without nested closures"
  s.description  = <<-DESC
    Animate is a small framework that enables you to define UIView animations using a declarative API
  DESC
  s.homepage     = "https://github.com/JohnSundell/Animate"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "John Sundell" => "john@sundell.co" }
  s.social_media_url   = "https://twitter.com/johnsundell"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/JohnSundell/Animate.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
