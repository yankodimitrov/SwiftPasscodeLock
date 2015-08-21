Pod::Spec.new do |s|
s.name = 'SwiftPasscodeLock'
s.version = '0.1'
s.license = { :type => "MIT", :file => 'LICENSE.txt' }
s.summary = 'An iOS passcode lock with Touch ID authentication written in Swift.'
s.homepage = 'https://github.com/yankodimitrov/SwiftPasscodeLock'
s.authors = { 'Yanko Dimitrov' => '' }
s.source = { :git => 'https://github.com/yankodimitrov/SwiftPasscodeLock.git' }

s.ios.deployment_target = '8.0'

s.source_files = 'SwiftPasscodeLock/PasscodeLock/*.{swift}',
				 'SwiftPasscodeLock/PasscodeLock/*/*.{swift}',
				 'SwiftPasscodeLock/ViewControllers/PasscodeViewController.swift',
				 'SwiftPasscodeLock/Views/*.{swift,xib}',
				 'SwiftPasscodeLock/en.lproj/*'

s.resources = [
				'SwiftPasscodeLock/Views/PasscodeView.xib',
				'SwiftPasscodeLock/en.lproj/*'
			  ]

s.requires_arc = true
end
