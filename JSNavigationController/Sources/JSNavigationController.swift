//
//  JSNavigationController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSNavigationController: NSViewController, JSViewControllersStackManager
{
	// MARK: - IB Outlets
	@IBOutlet weak open var contentView: NSView?
	@IBOutlet open var navigationBarView: NSView?
	
	// MARK: - Properties
	static let RootViewControllerSegueIdentifier = NSStoryboardSegue.Identifier("Root View Controller")
	open var viewControllers: [NSViewController] = []
	open var navigationBarController: JSNavigationBarController?
	open weak var delegate: JSNavigationControllerDelegate?

	// MARK: - Initializers
	
	public init(rootViewController: NSViewController, contentView: NSView, navigationBarView: NSView)
	{
		self.contentView = contentView
		self.navigationBarController = JSNavigationBarController(view: navigationBarView)
		super.init(nibName: nil, bundle: nil)
		self.push(viewController: rootViewController, animated: false)
	}

	public init(viewControllers: [NSViewController], contentView: NSView, navigationBarView: NSView)
	{
		self.contentView = contentView
		self.navigationBarController = JSNavigationBarController(view: navigationBarView)
		super.init(nibName: nil, bundle: nil)
		self.set(viewControllers: viewControllers, animated: false)
	}
	
	required public init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	// MARK: - Methods
	
	// MARK: Animations
	
	open func defaultPushAnimation() -> AnimationBlock
	{
		return
			{
				[unowned self] (_, _) in
				
				let containerViewBounds = self.contentView?.bounds ?? .zero
				let slideToLeftAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DIdentity, to: CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0))
				let slideFromRightAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DMakeTranslation(containerViewBounds.width, 0, 0), to: CATransform3DIdentity)
				return ([slideToLeftAnimation], [slideFromRightAnimation])
			}
	}
	
	open func defaultPopAnimation() -> AnimationBlock
	{
		return
			{
				[unowned self] (_, _) in
				
				let containerViewBounds = self.contentView?.bounds ?? .zero
				let slideToRightAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0), to: CATransform3DIdentity)
				let slideToRightFromCenterAnimation = self.animation(for: #keyPath(CALayer.transform), from: CATransform3DIdentity, to: CATransform3DMakeTranslation(containerViewBounds.width, 0, 0))
				
				return ([slideToRightFromCenterAnimation], [slideToRightAnimation])
			}
	}
	
	
	// MARK: View Lifecycle
	
	open override func loadView()
	{
		if let _ = self.nibName
		{
			super.loadView()
		}
		else
		{
			self.view = NSView(frame: .zero)
		}
	}

	open override func viewDidAppear()
	{
		super.viewDidAppear()
		guard let _ = nibName else { return }

		if let navigationBarView = self.navigationBarView
		{
			self.navigationBarController = JSNavigationBarController(view: navigationBarView)
		}
		self.performSegue(withIdentifier: type(of: self).RootViewControllerSegueIdentifier, sender: nil)
	}

	// MARK: Pushing
	
	open func push(viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
	{
		guard !self.viewControllers.contains(viewController) else { return }
		self.viewControllers.append(viewController)
		self.delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))

		// Remove old view
		if let previousViewController = self.previousViewController, contentAnimation == nil
		{
			previousViewController.view.removeFromSuperview()
		}

		// Add the new view
		self.contentView?.addSubview(viewController.view, positioned: .above, relativeTo: self.previousViewController?.view)
		self.clampContentView(to: viewController.view)

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider
		{
			vc.navigationController = self
			self.navigationBarController?.push(viewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		}
		else
		{
			self.navigationBarController?.push(viewController: EmptyViewController(), animation: navigationBarAnimation)
		}

		if let contentAnimation = contentAnimation
		{
			CATransaction.begin()
			CATransaction.setCompletionBlock
			{
				[unowned self] in
				self.previousViewController?.view.removeFromSuperview()
				self.previousViewController?.view.layer?.removeAllAnimations()
				self.delegate?.navigationController(self, didShowViewController: viewController, animated: true)
			}
			self.animatePush(contentAnimation)
			CATransaction.commit()
		}
		else
		{
			self.delegate?.navigationController(self, didShowViewController: viewController, animated: false)
		}
	}

	open func push(viewController: NSViewController, animated: Bool = true)
	{
		let contentAnimation = animated ? self.defaultPushAnimation() : nil
		let navigationBarAnimation = animated ? self.navigationBarController?.defaultPushAnimation() : nil
		self.push(viewController: viewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	// MARK: Popping
	
	open func pop(toViewController viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
	{
		guard self.viewControllers.contains(viewController) else { return }
		guard let rootViewController = self.viewControllers.first else { return }
		guard let topViewController = self.topViewController else { return }
		guard topViewController != rootViewController,
			topViewController != viewController else { return }

		self.delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))
		
		let viewControllerPosition = self.viewControllers.firstIndex(of: viewController)

		// Add the new view
		self.contentView?.addSubview(viewController.view, positioned: .below, relativeTo: topViewController.view)
		self.clampContentView(to: viewController.view)

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider
		{
			self.navigationBarController?.pop(toViewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		}

		if let contentAnimation = contentAnimation
		{
			CATransaction.begin()
			CATransaction.setCompletionBlock
			{
				[unowned self] in
				self.topViewController?.view.removeFromSuperview()
				self.topViewController?.view.layer?.removeAllAnimations()
				let range = (viewControllerPosition! + 1)..<self.viewControllers.count
				self.viewControllers.removeSubrange(range)
				self.delegate?.navigationController(self, didShowViewController: viewController, animated: true)
			}
			self.animatePop(toView: viewController.view, animation: contentAnimation)
			CATransaction.commit()
		}
		else
		{
			topViewController.view.removeFromSuperview()
			let range = (viewControllerPosition! + 1)..<self.viewControllers.count
			self.viewControllers.removeSubrange(range)
			self.delegate?.navigationController(self, didShowViewController: viewController, animated: false)
		}
	}

	open func pop(toViewController viewController: NSViewController, animated: Bool = true)
	{
		let contentAnimation = animated ? self.defaultPopAnimation() : nil
		let navigationBarAnimation = animated ? self.navigationBarController?.defaultPopAnimation() : nil
		self.pop(toViewController: viewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
	{
		guard let previousViewController = self.previousViewController else { return }
		self.pop(toViewController: previousViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popViewController(animated: Bool = true)
	{
		let contentAnimation = animated ? self.defaultPopAnimation() : nil
		let navigationBarAnimation = animated ? self.navigationBarController?.defaultPopAnimation() : nil
		self.popViewController(contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popToRootViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?)
	{
		guard let rootViewController = self.viewControllers.first,
			let topViewController = self.topViewController else { return }
		guard topViewController != rootViewController else { return }
		self.pop(toViewController: rootViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popToRootViewController(animated: Bool)
	{
		let contentAnimation = animated ? self.defaultPopAnimation() : nil
		let navigationBarAnimation = animated ? self.navigationBarController?.defaultPopAnimation() : nil
		self.popToRootViewController(contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}
}

// MARK: -
private class EmptyViewController: NSViewController
{
	init()
	{
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder)
	{
		fatalError("\(#function) has not been implemented")
	}

	fileprivate override func loadView()
	{
		self.view = NSView(frame: .zero)
	}
}
