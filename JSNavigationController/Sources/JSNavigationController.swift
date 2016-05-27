//
//  JSNavigationController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

public class JSNavigationController: JSViewControllersStackManager {
	private weak var contentView: NSView?
	public var containerView: NSView? {
		return contentView
	}
	public var viewControllers: [NSViewController] = []
	public let navigationBarController: JSNavigationBarController
	public weak var delegate: JSNavigationControllerDelegate?

	// MARK: - Creating Navigation Controllers
	public init(rootViewController: NSViewController, contentView: NSView, navigationBarView: NSView) {
		self.contentView = contentView
		navigationBarController = JSNavigationBarController(view: navigationBarView)
		push(viewController: rootViewController, animated: false)
	}

	public init(viewControllers: [NSViewController], contentView: NSView, navigationBarView: NSView) {
		self.contentView = contentView
		navigationBarController = JSNavigationBarController(view: navigationBarView)
		set(viewControllers: viewControllers, animated: false)
	}

	// MARK: - Pushing
	public func push(viewController viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard !Set(viewControllers).contains(viewController) else { return }

		viewControllers.append(viewController)
		delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))

		// Remove old view
		if let previousViewController = previousViewController where contentAnimation == nil {
			previousViewController.view.removeFromSuperview()
		}

		// Add the new view
		containerView?.addSubview(viewController.view, positioned: .Above, relativeTo: previousViewController?.view)

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider {
			vc.navigationController = self
			navigationBarController.push(viewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		} else {
			navigationBarController.push(viewController: EmptyViewController(), animation: navigationBarAnimation)
		}

		if let contentAnimation = contentAnimation {
			CATransaction.begin()
			CATransaction.setCompletionBlock { [weak self] in
				self?.previousViewController?.view.removeFromSuperview()
				self?.previousViewController?.view.layer?.removeAllAnimations()
				self?.delegate?.navigationController(self!, didShowViewController: viewController, animated: true)
			}
			animatePush(contentAnimation)
			CATransaction.commit()
		} else {
			delegate?.navigationController(self, didShowViewController: viewController, animated: false)
		}
	}

	public func push(viewController viewController: NSViewController, animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController.defaultPushAnimation() : nil
		push(viewController: viewController, contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	public func push(viewController viewController: NSViewController, animated: Bool) {
		if animated {
			push(viewController: viewController, animation: defaultPushAnimation())
		} else {
			push(viewController: viewController, animation: nil)
		}
	}

	// MARK: - Popping
	public func pop(toViewController viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard Set(viewControllers).contains(viewController) else { return }
		guard let rootViewController = viewControllers.first else { return }
		guard let topViewController = topViewController else { return }
		guard topViewController != rootViewController else { return }

		delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))
		
		let viewControllerPosition = viewControllers.indexOf(viewController)

		// Add the new view
		containerView?.addSubview(viewController.view, positioned: .Below, relativeTo: topViewController.view)

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider {
			navigationBarController.pop(toViewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		}

		if let contentAnimation = contentAnimation {
			CATransaction.begin()
			CATransaction.setCompletionBlock { [unowned self] in
				self.topViewController?.view.removeFromSuperview()
				self.topViewController?.view.layer?.removeAllAnimations()
				let range = (viewControllerPosition! + 1)..<self.viewControllers.count
				self.viewControllers.removeRange(range)
				self.delegate?.navigationController(self, didShowViewController: viewController, animated: true)
			}
			animatePop(toView: viewController.view, animation: contentAnimation)
			CATransaction.commit()
		} else {
			topViewController.view.removeFromSuperview()
			let range = (viewControllerPosition! + 1)..<self.viewControllers.count
			viewControllers.removeRange(range)
			delegate?.navigationController(self, didShowViewController: viewController, animated: false)
		}
	}

	public func pop(toViewController viewController: NSViewController, animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController.defaultPopAnimation() : nil
		pop(toViewController: viewController, contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	public func pop(toViewController viewController: NSViewController, animated: Bool) {
		if animated {
			pop(toViewController: viewController, animation: defaultPopAnimation())
		} else {
			pop(toViewController: viewController, animation: nil)
		}
	}

	public func popViewController(contentAnimation contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard let previousViewController = previousViewController else { return }
		pop(toViewController: previousViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	public func popViewController(animation animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController.defaultPopAnimation() : nil
		popViewController(contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	public func popViewController(animated animated: Bool) {
		if animated {
			popViewController(animation: defaultPopAnimation())
		} else {
			popViewController(animation: nil)
		}
	}

	public func popToRootViewController(contentAnimation contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard let rootViewController = viewControllers.first else { return }
		guard let topViewController = topViewController else { return }
		guard topViewController != rootViewController else { return }

		pop(toViewController: rootViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	public func popToRootViewController(animation animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController.defaultPopAnimation() : nil
		popToRootViewController(contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	public func popToRootViewController(animated animated: Bool) {
		if animated {
			popToRootViewController(animation: defaultPopAnimation())
		} else {
			popToRootViewController(animation: nil)
		}
	}

	// MARK: - Animations
	public func defaultPushAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.containerView?.bounds ?? .zero

			let slideToLeftTransform = CATransform3DMakeTranslation(-NSWidth(containerViewBounds) / 2, 0, 0)
			let slideToLeftAnimation = CABasicAnimation(keyPath: "transform")
			slideToLeftAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToLeftAnimation.toValue = NSValue(CATransform3D: slideToLeftTransform)
			slideToLeftAnimation.duration = 0.25
			slideToLeftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToLeftAnimation.fillMode = kCAFillModeForwards
			slideToLeftAnimation.removedOnCompletion = false

			let slideFromRightTransform = CATransform3DMakeTranslation(NSWidth(containerViewBounds), 0, 0)
			let slideFromRightAnimation = CABasicAnimation(keyPath: "transform")
			slideFromRightAnimation.fromValue = NSValue(CATransform3D: slideFromRightTransform)
			slideFromRightAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromRightAnimation.duration = 0.25
			slideFromRightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromRightAnimation.fillMode = kCAFillModeForwards
			slideFromRightAnimation.removedOnCompletion = false

			return ([slideToLeftAnimation], [slideFromRightAnimation])
		}
	}

	public func defaultPopAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.containerView?.bounds ?? .zero

			let slideToRightTransform = CATransform3DMakeTranslation(-NSWidth(containerViewBounds) / 2, 0, 0)
			let slideToRightAnimation = CABasicAnimation(keyPath: "transform")
			slideToRightAnimation.fromValue = NSValue(CATransform3D: slideToRightTransform)
			slideToRightAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToRightAnimation.duration = 0.25
			slideToRightAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToRightAnimation.fillMode = kCAFillModeForwards
			slideToRightAnimation.removedOnCompletion = false

			let slideToRightFromCenterTransform = CATransform3DMakeTranslation(NSWidth(containerViewBounds), 0, 0)
			let slideToRightFromCenterAnimation = CABasicAnimation(keyPath: "transform")
			slideToRightFromCenterAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToRightFromCenterAnimation.toValue = NSValue(CATransform3D: slideToRightFromCenterTransform)
			slideToRightFromCenterAnimation.duration = 0.25
			slideToRightFromCenterAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToRightFromCenterAnimation.fillMode = kCAFillModeForwards
			slideToRightFromCenterAnimation.removedOnCompletion = false

			return ([slideToRightFromCenterAnimation], [slideToRightAnimation])
		}
	}
}

private class EmptyViewController: NSViewController {
	init() {
		super.init(nibName: nil, bundle: nil)!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private override func loadView() {
		view = NSView(frame: .zero)
	}
}
