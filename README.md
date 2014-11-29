#SwiftPasscodeLock
An iOS passcode lock with Touch ID authentication written in Swift. 

<img src="https://raw.githubusercontent.com/yankodimitrov/SwiftPasscodeLock/master/swift-passcode-lock-cover.jpg" height="386">
<img src="https://raw.githubusercontent.com/yankodimitrov/SwiftPasscodeLock/master/swift-passcode-lock.gif" height="386">

At its core the *SwiftPasscodeLock* represents a form of the *State Design Pattern*. It also uses autolayout, is localization ready and works on both iPhone and iPad. The best part is that it's highly customizable. Go ahead and take a look at the UML class diagram on Figure 1:

![SwiftPasscodeLock class diagram](https://raw.githubusercontent.com/yankodimitrov/SwiftPasscodeLock/master/class-diagram.jpg "Figure 1. SwiftPasscodeLock class diagram")

*Figure 1: SwiftPasscodeLock class diagram*

##Installation
- Copy the core PasscodeLock components from the <code>SwiftPasscodeLock/PasscodeLock</code> folder to your project:
    - <code>PasscodeLock.swift</code>
    - <code>PasscodeLockPresenter.swift</code>
    - <code>GenericPasscodeLock.swift</code>
    - <code>ChangePasscodeState.swift.swift</code>
    - <code>ConfirmPasscodeState.swift</code>
    - <code>EnterPasscodeState.swift</code>
    - <code>PasscodesMismatchState.swift</code>
    - <code>SetPasscodeState.swift</code>

- Copy the <code>en.lproj</code> folder with <code>PasscodeLock.strings</code> localization file to your project;
- If you want to use the demo app <code>PasscodeViewController</code> copy the following files to your project:
    - <code>ViewControllers/PasscodeViewController.swift</code>
    - <code>Views/PasscodeButton.swift</code>
    - <code>Views/PasscodePlaceholderView.swift</code>
    - <code>Views/LockSplashView.swift</code>
    - <code>Views/PasscodeView.xib</code>
    - The <code>LockSplashView</code> will look for a resource image called <code>lock</code> that you can find in the demo app image assets;
    - Add the <code>**LocalAuthentication.framework**</code> to your project target as it's required for the **Touch ID** authentication.

#### SwiftKeychain
The demo app uses the Keychain API to store the app passcode. The included concrete implementation of the <code>PasscodeRepository</code> protocol the <code>PasscodeKeychainRepository</code> uses my **SwiftKeychain** wrapper that you can find here: [https://github.com/yankodimitrov/SwiftKeychain](https://github.com/yankodimitrov/SwiftKeychain).

- Include the contents of the <code>Keychain</code> folder to your project;
- Include the <code>/Models/PasscodeKeychainRepository.swift</code> to your project; 
- Add the <code>**Security.framework**</code> to your target;

##### Keychain Note:
The items stored in the **Keychain** will not be removed after your app is deleted, so make sure to implement a way to determine if your app is launched for the first time and if so, delete the stored passcode from the Keychain.

For example if your user forget your app passcode and decide to delete your app and then to install it again, your app should not ask the user to enter the previously stored passcode.

To delete the stored passcode from the Keychain, create an instance of the <code>PasscodeKeychainRepository</code> and call its <code>deletePasscode()</code> method.

##Usage

#### PasscodeRepository
The <code>PasscodeRepository</code> protocol defines a way for you to implement a custom passcode CRUD operations. For example you may want to save the passcode in your custom database. 

#### GenericPasscodeLock
The <code>GenericPasscodeLock</code> conforms both to <code>PasscodeLock</code> and <code>PasscodeLockStateFactory</code> protocols. You can instantiate it with a custom passcode length and repository or using the convenience initializer with only an instance of <code>PasscodeRepository</code>. The latter sets the passcode length to 4.

#### PasscodeLockViewController
The <code>PasscodeLockViewController</code> conforms to <code>PasscodeLockPresentable</code> and <code>PasscodeLockDelegate</code> protocols. It loads the <code>PasscodeView.xib</code> nib file as its view and uses **Auto Layout** to layout its view elements. The custom <code>PasscodeButton</code> and <code>PasscodePlaceholderView</code> that are used inside the nib are both **@IBDesignable** and **@IBInspectable**, so you can customize them directly from the interface builder (Figure 2).

![PasscodeView.xib](https://raw.githubusercontent.com/yankodimitrov/SwiftPasscodeLock/master/passcode-view.jpg "Figure 2. PasscodeView.xib")

*Figure 2: PasscodeView.xib*

Instead of creating a separate *UIViewController* for entering a passcode, changing the passcode and etc. we are reusing the <code>PasscodeLockViewController</code> but with different initial <code>PasscodeLockState</code>. The <code>PasscodeLockViewController</code> updates its view to represent the current state of its <code>PasscodeLock</code> instance.

Here is an example of presenting the <code>PasscodeLockViewController</code> with option for the user to set a passcode:

```swift
let passcodeRepository = PasscodeKeychainRepository()
let passcodeLock = GenericPasscodeLock(repository: passcodeRepository)
    
    // set the initial state to SetPasscodeState
    passcodeLock.state = passcodeLock.makeSetPasscodeState()
        
let controller = PasscodeViewController(passcodeLock: passcodeLock)
    
    controller.onCorrectPasscode = {
            
        // the user has successfully added a passcode
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
presentViewController(controller, animated: true, completion: nil)
```

By default the <code>PasscodeLockViewController</code> will display a *Cancel* button that user can use to dismiss the passcode view. You can hide the button by setting the <code>hideCancelButton</code> to true.

Here is an example of prompting the user to enter its passcode:

```swift
let passcodeRepository = PasscodeKeychainRepository()
let passcodeLock = GenericPasscodeLock(repository: passcodeRepository)
    
    passcodeLock.state = passcodeLock.makeEnterPasscodeState()
        
let controller = PasscodeViewController(passcodeLock: passcodeLock)
    
    controller.hideCancelButton = true
    
    controller.onCorrectPasscode = {
            
        // the user has successfully entered the passcode
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
        
presentViewController(controller, animated: true, completion: nil)
```

####Touch ID

When the <code>PasscodeLock</code> state inside the <code>PasscodeViewController</code> enters the <code>EnterPasscodeState</code> state, the user will be asked to use the *Touch ID* sensor on its device to authenticate (if the device has one). Upon successful authentication with Touch ID the <code>onCorrectPasscode</code> closure will be called.

At the same time the user may cancel the Touch ID prompt and enter the passcode manually.

### Using a custom passcode UIViewController
You can use your own *UIViewController* just make sure to conform to <code>PasscodeLockPresentable</code> and <code>PasscodeLockDelegate</code> protocols.

###Localization
The included <code>PasscodeLockState</code> protocol implementations are using the <code>en.lproj/PasscodeLock.strings</code> file for their title and description properties values. Also in the same *strings* file you can find the localized Touch ID authentication reason string.

###Interface Orientations
The <code>PasscodeLockViewController</code> is displayed only in portrait on iPhone and in any orientation on iPad.

###PasscodeLockPresenter
Now that our app has a passcode lock set up, it will be nice if we could implement a way to hide the possibly sensitive app data from the app snapshot that is taken when our app enters in background state.

#####LockSplashView
During my testing I found that if we present the <code>PasscodeLockViewController</code>, even without animation, the created by the iOS app snapshot will still contain the last seen view in our app, so I decided to use a splash view to hide it.

The splash view is added as a subview to the main *UIWindow* when our app enters the background state and then it is removed. Because we are adding a subview directly to the *UIWindow* without a *UIViewController* we have to manage the splash view rotation by ourselves, fortunately the <code>PasscodeLockPresenter</code> will take care for that.

At the same time when we are adding the splash view we are also presenting the <code>PasscodeViewController</code> on the most top *UIViewController* in the *rootViewController*'s hierarchy. This way when the app becomes active again the user will have to enter its passcode.

<code>PasscodeLockPresenter</code> will also detect when our app is launched and in case that we have a passcode stored in the provided <code>PasscodeRepository</code>, will present the <code>PasscodeViewController</code>. The user will have first to enter its passcode or touch for Touch ID in order to use the app.

Here is an example usage of the <code>PasscodeLockPresenter</code>:

```swift
// AppDelegate.swift
...
var window: UIWindow?
    
lazy var passcodePresenter: PasscodeLockPresenter = {
        
    let splash = LockSplashView()
    let repository = PasscodeKeychainRepository()
        
    let passcodeLock = GenericPasscodeLock(repository: repository)
        passcodeLock.state = passcodeLock.makeEnterPasscodeState()
        
    let passcodeController = PasscodeViewController(passcodeLock: passcodeLock)
        passcodeController.hideCancelButton = true
        
    let presenter = PasscodeLockPresenter(
        passcodeViewController: passcodeController,
        repository: repository,
        splashView: splash
    )
        
    presenter.window = self.window
        
    return presenter
}()
    
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let passcodeLockPresenter = passcodePresenter
        
    return true
}
...
```
##Demo App
The project contains a demo app with options to set, remove, update and change the passcode.

##Tests
You can find the tests inside the <code>SwiftPasscodeTests</code> folder.

##License
SwiftPasscodeLock is released under the MIT license. See the LICENSE.txt file for more info.