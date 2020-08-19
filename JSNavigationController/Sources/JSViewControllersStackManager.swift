//
//  JSViewControllersStackController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 17/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public typealias AnimationBlock = (_ fromView: NSView?, _ toView: NSView?) -> (fromViewAnimations: [CAAnimation], toViewAnimations: [CAAnimation])

public protocol JSViewControllersStackManager: class {
	/// The view in which views will be pushed.
	var contentView: NSView? { get set }
	/// The view controllers currently on the navigation stack.
	var viewControllers: [NSViewController] { get set }
	/// The view controller at the top of the navigation stack.
	var topViewController: NSViewController? { get }
		/// The view controller above the top view controller. Nil if the top view controller is the root view controller.
	var previousViewController: NSViewController? { get }
	/**
	Replaces the view controllers currently managed by the navigation controller with the specified items.
	
	- parameter viewControllers: The view controllers to place in the stack.
	The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack. 
	Thus, the last item added to the array becomes the top item of the navigation stack.
	- parameter animated: If true, animate the pushing or popping of the top view controller. If false, replace the view controllers without any animations.
	*/
	func set(viewControllers: [NSViewController], animated: Bool)
	// MARK: - Pushing
	/**
	Pushes a view controller onto the receiver’s stack and updates the display.
	
	- parameter viewController:	The view controller to push onto the stack.
	If the view controller is already on the navigation stack, this method does nothing.
	- parameter animation: The animation block to apply during the transition. Specify nil if you do not want the transition to be animated.
	*/
	func push(viewController: NSViewController, animation: AnimationBlock?)
	/**
	Pushes a view controller onto the receiver’s stack and updates the display.
	
	- parameter viewController:	The view controller to push onto the stack.
	If the view controller is already on the navigation stack, this method does nothing.
	- parameter animated: Specify true to animate the transition or false if you do not want the transition to be animated.
	You might specify false if you are setting up the navigation controller at launch time..
	*/
	func push(viewController: NSViewController, animated: Bool)
	// MARK: - Popping
	/**
	Pops the top view controller from the navigation stack and updates the display.
	
	- parameter animation: The animation block to apply during the transition. Specify nil if you do not want the transition to be animated.
	*/
	func popViewController(animation: AnimationBlock?)
	/**
	Pops the top view controller from the navigation stack and updates the display.
	
	- parameter animated: Specify true to animate the transition or false if you do not want the transition to be animated.
	*/
	func popViewController(animated: Bool)
	/**
	Pops view controllers until the specified view controller is at the top of the navigation stack.
	
	- parameter viewController:	The view controller that you want to be at the top of the stack. 
	Does nothing if this view controller is not on the navigation stack.
	- parameter animation: The animation block to apply during the transition. Specify nil if you do not want the transition to be animated.
	*/
	func pop(toViewController viewController: NSViewController, animation: AnimationBlock?)
	/**
	Pops view controllers until the specified view controller is at the top of the navigation stack.
	
	- parameter viewController:	The view controller that you want to be at the top of the stack.
	- parameter animated: Specify true to animate the transition or false if you do not want the transition to be animated.
	*/
	func pop(toViewController viewController: NSViewController, animated: Bool)
	/**
	Pops all the view controllers on the stack except the root view controller and updates the display.
	
	- parameter animation: The animation block to apply during the transition. Specify nil if you do not want the transition to be animated.
	*/
	func popToRootViewController(animation: AnimationBlock?)
	/**
	Pops all the view controllers on the stack except the root view controller and updates the display.
	
	- parameter animated: Specify true to animate the transition or false if you do not want the transition to be animated.
	*/
	func popToRootViewController(animated: Bool)

	// MARK: - Animating
	func animatePush(_ animation: AnimationBlock)
	func animatePop(toView view: NSView?, animation: AnimationBlock)
	func defaultPushAnimation() -> AnimationBlock
	func defaultPopAnimation() -> AnimationBlock
}

// MARK: -
public extension JSViewControllersStackManager
{
	// MARK: - Properties
	
    var topViewController: NSViewController?
	{
		return self.viewControllers.last
	}
    var previousViewController: NSViewController?
	{
		guard self.viewControllers.count > 1 else { return nil }
		return self.viewControllers[self.viewControllers.count - 2]
	}
	
	var animationDuration: TimeInterval
	{
		return 0.25
	}
	
	// MARK: - Methods
	
	func clampContentView(to view: NSView)
	{
		guard view.superview == self.contentView else { return }
		view.translatesAutoresizingMaskIntoConstraints = false
		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllCenterX, metrics: nil, views: ["view" : view])
		let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllCenterY, metrics: nil, views: ["view" : view])
		NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
	}
	
	func animation(for keypath: String, from: Any, to: Any) -> CAAnimation
	{
		let animation = CABasicAnimation(keyPath: keypath)
		animation.fromValue = from
		animation.toValue = to
		animation.duration = self.animationDuration
		animation.timingFunction = .init(name: .easeOut)
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		return animation
	}

    func set(viewControllers: [NSViewController], animated: Bool)
	{
		guard !viewControllers.isEmpty else { return }

		if animated
		{
			if let lastViewController = viewControllers.last
			{
				if self.viewControllers.contains(lastViewController),
					lastViewController != self.topViewController
				{
					self.pop(toViewController: lastViewController, animated: true)
				}
				else
				{
					self.push(viewController: lastViewController, animated: true)
				}
			}
		}
		else
		{
			if let lastViewController = viewControllers.last
			{
				self.push(viewController: lastViewController, animated: false)
			}
			self.viewControllers = viewControllers
		}
	}

    func push(viewController: NSViewController, animation: AnimationBlock?)
	{
		guard !self.viewControllers.contains(viewController) else { return }
		self.viewControllers.append(viewController)

		// Remove old view
		if let previousViewController = self.previousViewController, animation == nil
		{
			previousViewController.view.removeFromSuperview()
		}

		// Add the new view
		self.contentView?.addSubview(viewController.view, positioned: .above, relativeTo: self.previousViewController?.view)
		self.clampContentView(to: viewController.view)

		if let animation = animation
		{
			CATransaction.begin()
			CATransaction.setCompletionBlock
			{
				[unowned self] in
				self.previousViewController?.view.removeFromSuperview()
				self.previousViewController?.view.layer?.removeAllAnimations()
			}
			self.animatePush(animation)
			CATransaction.commit()
		}
	}

    func push(viewController: NSViewController, animated: Bool)
	{
		self.push(viewController: viewController, animation: animated ? defaultPushAnimation() : nil)
	}

	// MARK: - Popping
    func popViewController(animation: AnimationBlock?)
	{
		guard let previousViewController = self.previousViewController else { return } // You can't pop the root view controller
		self.pop(toViewController: previousViewController, animation: animation)
	}

    func popViewController(animated: Bool)
	{
		self.popViewController(animation: animated ? self.defaultPopAnimation() : nil)
	}

    func pop(toViewController viewController: NSViewController, animation: AnimationBlock?)
	{
		guard self.viewControllers.contains(viewController) else { return }
		guard let rootViewController = self.viewControllers.first,
			let topViewController = self.topViewController else { return }
		guard topViewController != rootViewController else { return }

		let viewControllerPosition = self.viewControllers.firstIndex(of: viewController)

		// Add the new view
		self.contentView?.addSubview(viewController.view, positioned: .below, relativeTo: topViewController.view)
		self.clampContentView(to: viewController.view)

		if let animation = animation
		{
			CATransaction.begin()
			CATransaction.setCompletionBlock
			{
				[unowned self] in
				self.topViewController?.view.removeFromSuperview()
				self.topViewController?.view.layer?.removeAllAnimations()
				let range = (viewControllerPosition! + 1)..<self.viewControllers.count
				self.viewControllers.removeSubrange(range)
			}
			self.animatePop(toView: viewController.view, animation: animation)
			CATransaction.commit()
		}
		else
		{
			topViewController.view.removeFromSuperview()
			let range = (viewControllerPosition! + 1)..<self.viewControllers.count
			self.viewControllers.removeSubrange(range)
		}
	}

    func pop(toViewController viewController: NSViewController, animated: Bool)
	{
		self.pop(toViewController: viewController, animation: animated ? defaultPopAnimation() : nil)
	}

    func popToRootViewController(animation: AnimationBlock?)
	{
		guard let rootViewController = self.viewControllers.first,
			let topViewController = self.topViewController else { return }
		guard topViewController != rootViewController else { return }
		self.pop(toViewController: rootViewController, animation: animation)
	}

    func popToRootViewController(animated: Bool)
	{
		self.popToRootViewController(animation: animated ? self.defaultPopAnimation() : nil)
	}

	// MARK: - Animating
	private func animate(fromView: NSView?, toView: NSView?, animation: AnimationBlock)
	{
		fromView?.wantsLayer = true
		toView?.wantsLayer = true
		animation(fromView, toView).fromViewAnimations.forEach
		{
			fromView?.layer?.add($0, forKey: nil)
		}
		animation(fromView, toView).toViewAnimations.forEach
		{
			toView?.layer?.add($0, forKey: nil)
		}
	}

    func animatePush(_ animation: AnimationBlock)
	{
		self.animate(fromView: self.previousViewController?.view,
					 toView: self.topViewController?.view,
					 animation: animation)
	}

    func animatePop(toView view: NSView?, animation: AnimationBlock)
	{
		self.animate(fromView: self.topViewController?.view,
					 toView: view,
					 animation: animation)
	}
}
