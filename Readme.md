# JSNavigationController
>A highly customizable UINavigationController suited for macOS.

[![MIT License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE.md)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform OSX](https://img.shields.io/badge/platform-osx-lightgrey.svg)


![](Presentation.gif)

## Table of Contents  
* [Usage](#usage)  
	* [Creating the navigation controller](#creatingNavigationController)    
	* [Pushing view controllers](#pushingViewControllers)
	* [Popping view controllers](#poppingViewControllers)
	* [Custom animations](#customAnimations)
	* [Delegate](#delegate)
	* [Storyboard](#storyboard)
* [Examples](#examples)
* [Requirements](#requirements)    
* [Integration](#integration)
	* [Carthage](#carthageIntegration)
	* [CocoaPods](#cocoapodsIntegration)
	* [Manually](#manualIntegration)

## <a name="usage"></a>Usage
If you're familiar with `UINavigationController` API, you won't be lost, it's quite the same.

### <a name="creatingNavigationController"></a>Creating the navigation controller
Creating a navigation controller is easy, here is the constructor signature:

```swift
init(rootViewController: NSViewController, contentView: NSView, navigationBarView: NSView)
```
It takes 3 arguments:

1. `rootViewController`: the controller you want to be at the bottom of the navigation stack.
2. `contentView `: the view you want to be used as the container of pushed views.
3. `navigationBarView `: the view you want to be used as the container of pushed views in the navigation bar.

**_Note_**: `JSNavigationController` **does not hold reference** to the views you pass as `contentView`.

### <a name="pushingViewControllers"></a>Pushing view controllers
```swift
func push(viewController: NSViewController, animated: Bool)
func push(viewController: NSViewController, animation: AnimationBlock?)
func push(viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
```

**_Note_**: pushing a view controller that is already in the navigation stack will have no effect.

In order to push a view in the navigation bar as well, the pushed view controller must conform to the `JSNavigationBarViewControllerProvider` protocol, which is defined as follow:

```swift
public protocol JSNavigationBarViewControllerProvider: class {
	weak var navigationController: JSNavigationController? { get set }
	func navigationBarViewController() -> NSViewController
}
```

---

### <a name="poppingViewControllers"></a>Popping view controllers
#### • Popping to the previous view controller
```swift
func popViewController(animated: Bool)
func popViewController(animation: AnimationBlock?)
func popViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
```
#### • Popping to the root view controller
```swift
func popToRootViewController(animated: Bool)
func popToRootViewController(animation: AnimationBlock?)
func popToRootViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
```
#### • Popping to a specific view controller
```swift
func pop(toViewController viewController: NSViewController, animated: Bool)
func pop(toViewController viewController: NSViewController, animation: AnimationBlock?)
func pop(toViewController viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
```
**_Note_**: do nothing if the specified view controller is not in the navigation stack or is the top view controller.

---

### <a name="customAnimations"></a>Custom animations
How does AnimationBlock works? Let's take a look at its declaration:

```swift
typealias AnimationBlock = (_ fromView: NSView?, _ toView: NSView?) -> (fromViewAnimations: [CAAnimation], toViewAnimations: [CAAnimation])
```
* `fromView`: it's the view currently on screen (**the view to hide**).
* `toView`: the view that will be on screen after the animation completed (**the view to show**).

The block must return a tuple which contains animations for corresponding views.

**_Note_**: at the end of animations, `fromView` is removed from its superview and all animations attached to its layer are also removed. It means that you can't have an animation where both `fromView` and `toView` are visible at the end.

#### Example
A simple crossfade animation:

```swift
let animation: AnimationBlock = { (_, _) in
	let fadeInAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
	fadeInAnimation.fromValue = 0.0
	fadeInAnimation.toValue = 1.0
	fadeInAnimation.duration = 0.25
	fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
	fadeInAnimation.fillMode = kCAFillModeForwards
	fadeInAnimation.removedOnCompletion = false

	let fadeOutAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
	fadeOutAnimation.fromValue = 1.0
	fadeOutAnimation.toValue = 0.0
	fadeOutAnimation.duration = 0.25
	fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
	fadeOutAnimation.fillMode = kCAFillModeForwards
	fadeOutAnimation.removedOnCompletion = false

	return ([fadeOutAnimation], [fadeInAnimation])
}
```

---

### <a name="delegate"></a>Delegate
```swift
public protocol JSNavigationControllerDelegate: class {
	func navigationController(_ navigationController: JSNavigationController, willShowViewController viewController: NSViewController, animated: Bool)
	func navigationController(_ navigationController: JSNavigationController, didShowViewController viewController: NSViewController, animated: Bool)
}
```

### <a name="storyboard"></a>Storyboard

You should only push `JSViewController` subclasses, that way you'll have access to `destinationViewController` and `destinationViewControllers` properties.

Use `JSNavigationControllerSegue` for segues class.

#### Segues identifiers

* `rootViewController` to set the root view controller of the navigation controller.
* `navigationBarViewController` to set the navigation bar view controller of a view controller.
* `navigationControllerPush` to set the destination view controller of a view controller.

If your view controller can push multiple view controllers, use `navigationControllerPush#NameOfYourViewController` pattern.

That way, you can retrieve a specific view controller and push it like this:

```swift
let myViewController = destinationViewControllers["NameOfYourViewController"]
navigationController?.push(viewController: myViewController, animated: true)
```

See the `ExampleStoryboard` project for an example of implementation.

## Examples
See the `Example` and `ExampleStoryboard` projects in the .zip file.

## <a name="requirements"></a>Requirements
* Xcode 7
* OS X 10.11

## <a name="integration"></a>Integration
### <a name="carthageIntegration"></a>Carthage
Add `github "juliensagot/JSNavigationController"` to your Cartfile.

### <a name="cocoapodsIntegration"></a>Cocoapods
Add `pod 'JSNavigationController', :git => 'https://github.com/juliensagot/JSNavigationController.git'` to your Podfile.

### <a name="manualIntegration"></a>Manually
Download the .zip file and add the content of `JSNavigationController/Sources` folder to your project.
