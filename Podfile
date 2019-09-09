# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def rx_swift
	pod 'RxSwift', '~> 4.0'
end

def rx_cocoa
	pod 'RxCocoa', '~> 4.0'
end

target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'RxAlamofire'
pod 'ReachabilitySwift'
  # Pods for Domain

end

target 'Playor' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
	rx_cocoa
	rx_swift
	#UIPods
	pod 'RxDataSources'
	pod 'SABlurImageView'
	pod 'SDWebImage', '~> 5.0'
	pod 'Hero'
	pod 'Stellar', :git => 'https://github.com/AugustRush/Stellar.git'
	pod 'RAMAnimatedTabBarController'
  # Pods for Playor
end

target 'NetworkPlatform' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	rx_swift
	pod 'Alamofire'
	pod 'RxAlamofire'
#	pod 'RxStarscream'
	pod 'RxRealm'
	pod 'RealmSwift'
	pod 'Realm'
	# Pods for NetworkPlatform
	
end

target 'RealmPlatform' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	rx_swift
	pod 'RxRealm'
	pod 'RealmSwift'
	pod 'Realm'
end

target 'SoundsPlatform' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	rx_swift
	rx_cocoa
end

target 'SuggestionPlatform' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	rx_cocoa
	rx_swift

	# Pods for Playor
end

target 'AnalyticsPlatform' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	rx_cocoa
	rx_swift
	
	# Pods for Playor
end
