

Pod::Spec.new do |s|
    s.name         = "ottu_checkout_sdk"
    s.version      = "1.0.14"
    s.summary      = "The ottu_checkout_sdk iOS SDK makes it quick and easy to build an excellent payment experience in your iOS app."
    s.description  = <<-DESC
**Simplified security**: We make it simple for you to collect sensitive data such as credit card numbers and remain PCI compliant.
**Apple Pay**: We provide a [seamless integration with Apple Pay]().
    DESC
    s.homepage     = "https://github.com/ottuco/ottu-ios.git"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2024
                   Permission is granted to Ottu
                  LICENSE
                }
    s.author = { "ottuco" => "ottuco@ottuco.com" }
    s.source = { :git => "https://github.com/ottuco/ottu-ios.git", :tag => "#{s.version}" }
    s.vendored_frameworks = "Sources/ottu_checkout_sdk.xcframework"
    s.dependency 'Sentry', '~> 8.31.1'

    s.platform = :ios
    s.swift_version = "5.0"

    s.ios.deployment_target  = '13.0'
    s.static_framework = true
    s.user_target_xcconfig = {
      'SWIFT_INCLUDE_PATHS' => '"\$(PODS_ROOT)/ottu_checkout_sdk/ottu_checkout_sdk.xcframework"'
    }
end
