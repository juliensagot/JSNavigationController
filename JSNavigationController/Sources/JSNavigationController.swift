//
//  JSNavigationController.swift
//  JSNavigationController
//
//  Created by Julien Sagot on 14/05/16.
//  Copyright © 2016 Julien Sagot. All rights reserved.
//

import AppKit

open class JSNavigationController: NSViewController, JSViewControllersStackManager {
	@IBOutlet weak open var contentView: NSView?
	@IBOutlet open var navigationBarView: NSView?
	open var viewControllers: [NSViewController] = []
	open var navigationBarController: JSNavigationBarController?
	open weak var delegate: JSNavigationControllerDelegate?

	// MARK: - Creating Navigation Controllers
	public init(rootViewController: NSViewController, contentView: NSView, navigationBarView: NSView) {
		self.contentView = contentView
		navigationBarController = JSNavigationBarController(view: navigationBarView)
		super.init(nibName: nil, bundle: nil)
		push(viewController: rootViewController, animated: false)
	}

	public init(viewControllers: [NSViewController], contentView: NSView, navigationBarView: NSView) {
		self.contentView = contentView
		navigationBarController = JSNavigationBarController(view: navigationBarView)
		super.init(nibName: nil, bundle: nil)
		set(viewControllers: viewControllers, animated: false)
	}
	
	required public init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	// MARK: - View Lifecycle
	open override func loadView() {
		if nibName != nil {
			super.loadView()
		} else {
			view = NSView(frame: .zero)
		}
	}

	open override func viewDidAppear() {
		super.viewDidAppear()
		guard nibName != nil else { return }
		guard let segues = value(forKey: "segueTemplates") as? [NSObject] else { return } // Undocumented

		if let navigationBarView = navigationBarView {
			navigationBarController = JSNavigationBarController(view: navigationBarView)
		}

		for segue in segues {
			if let id = segue.value(forKey: "identifier") as? String {
				performSegue(withIdentifier: id, sender: self)
			}
		}
	}

	// MARK: - Pushing
	open func push(viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard !Set(viewControllers).contains(viewController) else { return }

		viewControllers.append(viewController)
		delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))

		// Remove old view
		if let previousViewController = previousViewController , contentAnimation == nil {
			previousViewController.view.removeFromSuperview()
		}

		// Add the new view
		if let contentView = self.contentView
		{
			contentView.addSubview(viewController.view, positioned: .above, relativeTo: previousViewController?.view)
			viewController.view.translatesAutoresizingMaskIntoConstraints = false
			let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllCenterX, metrics: nil, views: ["view" : viewController.view])
			let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllCenterX, metrics: nil, views: ["view" : viewController.view])
			NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
		}

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider {
			vc.navigationController = self
			navigationBarController?.push(viewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		} else {
			navigationBarController?.push(viewController: EmptyViewController(), animation: navigationBarAnimation)
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

	open func push(viewController: NSViewController, animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController?.defaultPushAnimation() : nil
		push(viewController: viewController, contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	open func push(viewController: NSViewController, animated: Bool) {
		if animated {
			push(viewController: viewController, animation: defaultPushAnimation())
		} else {
			push(viewController: viewController, animation: nil)
		}
	}

	// MARK: - Popping
	open func pop(toViewController viewController: NSViewController, contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard Set(viewControllers).contains(viewController) else { return }
		guard let rootViewController = viewControllers.first else { return }
		guard let topViewController = topViewController else { return }
		guard topViewController != rootViewController else { return }

		delegate?.navigationController(self, willShowViewController: viewController, animated: (contentAnimation != nil))
		
        let viewControllerPosition = viewControllers.firstIndex(of: viewController)

		// Add the new view
		contentView?.addSubview(viewController.view, positioned: .below, relativeTo: topViewController.view)

		// NavigationBar
		if let vc = viewController as? JSNavigationBarViewControllerProvider {
			navigationBarController?.pop(toViewController: vc.navigationBarViewController(), animation: navigationBarAnimation)
		}

		if let contentAnimation = contentAnimation {
			CATransaction.begin()
			CATransaction.setCompletionBlock { [unowned self] in
				self.topViewController?.view.removeFromSuperview()
				self.topViewController?.view.layer?.removeAllAnimations()
				let range = (viewControllerPosition! + 1)..<self.viewControllers.count
				self.viewControllers.removeSubrange(range)
				self.delegate?.navigationController(self, didShowViewController: viewController, animated: true)
			}
			animatePop(toView: viewController.view, animation: contentAnimation)
			CATransaction.commit()
		} else {
			topViewController.view.removeFromSuperview()
			let range = (viewControllerPosition! + 1)..<self.viewControllers.count
			viewControllers.removeSubrange(range)
			delegate?.navigationController(self, didShowViewController: viewController, animated: false)
		}
	}

	open func pop(toViewController viewController: NSViewController, animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController?.defaultPopAnimation() : nil
		pop(toViewController: viewController, contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	open func pop(toViewController viewController: NSViewController, animated: Bool) {
		if animated {
			pop(toViewController: viewController, animation: defaultPopAnimation())
		} else {
			pop(toViewController: viewController, animation: nil)
		}
	}

	open func popViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard let previousViewController = previousViewController else { return }
		pop(toViewController: previousViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popViewController(animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController?.defaultPopAnimation() : nil
		popViewController(contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	open func popViewController(animated: Bool) {
		if animated {
			popViewController(animation: defaultPopAnimation())
		} else {
			popViewController(animation: nil)
		}
	}

	open func popToRootViewController(contentAnimation: AnimationBlock?, navigationBarAnimation: AnimationBlock?) {
		guard let rootViewController = viewControllers.first else { return }
		guard let topViewController = topViewController else { return }
		guard topViewController != rootViewController else { return }

		pop(toViewController: rootViewController, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	open func popToRootViewController(animation: AnimationBlock?) {
		let navBarAnimation: AnimationBlock? = animation != nil ? navigationBarController?.defaultPopAnimation() : nil
		popToRootViewController(contentAnimation: animation, navigationBarAnimation: navBarAnimation)
	}

	open func popToRootViewController(animated: Bool) {
		if animated {
			popToRootViewController(animation: defaultPopAnimation())
		} else {
			popToRootViewController(animation: nil)
		}
	}

	// MARK: - Animations
	open func defaultPushAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.contentView?.bounds ?? .zero

			let slideToLeftTransform = CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0)
			let slideToLeftAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToLeftAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToLeftAnimation.toValue = NSValue(caTransform3D: slideToLeftTransform)
			slideToLeftAnimation.duration = 0.25
			slideToLeftAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			slideToLeftAnimation.fillMode = CAMediaTimingFillMode.forwards
			slideToLeftAnimation.isRemovedOnCompletion = false

			let slideFromRightTransform = CATransform3DMakeTranslation(containerViewBounds.width, 0, 0)
			let slideFromRightAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideFromRightAnimation.fromValue = NSValue(caTransform3D: slideFromRightTransform)
			slideFromRightAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideFromRightAnimation.duration = 0.25
			slideFromRightAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			slideFromRightAnimation.fillMode = CAMediaTimingFillMode.forwards
			slideFromRightAnimation.isRemovedOnCompletion = false

			return ([slideToLeftAnimation], [slideFromRightAnimation])
		}
	}

	open func defaultPopAnimation() -> AnimationBlock {
		return { [weak self] (_, _) in
			let containerViewBounds = self?.contentView?.bounds ?? .zero

			let slideToRightTransform = CATransform3DMakeTranslation(-containerViewBounds.width / 2, 0, 0)
			let slideToRightAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToRightAnimation.fromValue = NSValue(caTransform3D: slideToRightTransform)
			slideToRightAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToRightAnimation.duration = 0.25
			slideToRightAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			slideToRightAnimation.fillMode = CAMediaTimingFillMode.forwards
			slideToRightAnimation.isRemovedOnCompletion = false

			let slideToRightFromCenterTransform = CATransform3DMakeTranslation(containerViewBounds.width, 0, 0)
			let slideToRightFromCenterAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToRightFromCenterAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToRightFromCenterAnimation.toValue = NSValue(caTransform3D: slideToRightFromCenterTransform)
			slideToRightFromCenterAnimation.duration = 0.25
			slideToRightFromCenterAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			slideToRightFromCenterAnimation.fillMode = CAMediaTimingFillMode.forwards
			slideToRightFromCenterAnimation.isRemovedOnCompletion = false

			return ([slideToRightFromCenterAnimation], [slideToRightAnimation])
		}
	}

	// MARK: - Storyboard
	open override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		guard segue.identifier == "rootViewController" else { return }
		guard let destinationController = segue.destinationController as? NSViewController else { return }

		push(viewController: destinationController, animated: false)
	}
}

// MARK: -
private class EmptyViewController: NSViewController {
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	fileprivate override func loadView() {
		view = NSView(frame: .zero)
	}
}
