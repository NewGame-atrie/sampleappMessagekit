# Uncomment this line to define a global platform for your project
# platform :ios, "11.0"
# Uncomment this line if you're using Swift
use_frameworks!

target 'sampleappMessageKit' do
	pod 'MessageKit'
	pod 'Firebase/Core'
  	pod 'Firebase/Auth'
  	pod 'Firebase/Storage'
  	pod 'Firebase/Firestore'
	pod 'Firebase/Analytics'

	post_install do |installer|
   	 installer.pods_project.targets.each do |target|
        	if target.name == "MessageKit"
            	target.build_configurations.each do |config|
                	config.build_settings['SWIFT_VERSION'] = '4.0'
            			end
        		end 
    		end
	end  

  target 'sampleappMessageKitTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'sampleappMessageKitUITests' do
    # Pods for testing
  end

end
