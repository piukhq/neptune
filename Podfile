platform :ios, '13.0'

def common_pods

#pod 'DTTJailbreakDetection', '~> 0.4'
#pod 'SwiftLint', '~> 0.43'
pod 'SwiftGen', '~> 6.5.1'
pod 'SwiftyRSA', :git => 'git@github.com:binkhq/SwiftyRSA.git'

plugin 'cocoapods-keys', {
  :project => "localHero",
  :keys => [
  "spreedlyEnvironmentKey",
  "binkTestAuthHeaderToken"
  ]
}

end

target 'LocalHero' do
  use_frameworks!

  # Pods for LocalHero
  common_pods

  target 'LocalHeroTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
  end

  target 'LocalHeroUITests' do
    # Pods for testing
    common_pods
  end

end
