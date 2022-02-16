platform :ios, '13.0'

def common_pods

#pod 'DTTJailbreakDetection', '~> 0.4'
#pod 'SwiftLint', '~> 0.43'

#plugin 'cocoapods-keys', {
#  :project => "binkapp",
#  :keys => [
#  ]
#}

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
