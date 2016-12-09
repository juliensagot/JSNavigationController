import AppKit
import JSNavigationController

private extension Selector {
	static let pushToThirdVC = #selector(SecondViewController.pushToThirdViewController(_:))
	static let popVC = #selector(SecondViewController.popVC)
}

class SecondViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	fileprivate let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "SecondViewController", bundle: Bundle.main)!
	}

	required init?(coder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		if let view = view as? NSVisualEffectView {
			view.material = .mediumLight
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		navigationBarVC.backButton?.action = .popVC
		navigationBarVC.backButton?.target = self
		navigationBarVC.titleLabel?.stringValue = "Second VC"
		navigationBarVC.nextButton?.action = .pushToThirdVC
		navigationBarVC.nextButton?.target = self
	}

	override func viewDidDisappear() {
		view.superview?.removeConstraints(viewConstraints())
	}

	// MARK: - Layout
	fileprivate func viewConstraints() -> [NSLayoutConstraint] {
		let left = NSLayoutConstraint(
			item: view, attribute: .left, relatedBy: .equal,
			toItem: view.superview, attribute: .left,
			multiplier: 1.0, constant: 0.0
		)
		let right = NSLayoutConstraint(
			item: view, attribute: .right, relatedBy: .equal,
			toItem: view.superview, attribute: .right,
			multiplier: 1.0, constant: 0.0
		)
		let top = NSLayoutConstraint(
			item: view, attribute: .top, relatedBy: .equal,
			toItem: view.superview, attribute: .top,
			multiplier: 1.0, constant: 0.0
		)
		let bottom = NSLayoutConstraint(
			item: view, attribute: .bottom, relatedBy: .equal,
			toItem: view.superview, attribute: .bottom,
			multiplier: 1.0, constant: 0.0
		)
		return [left, right, top, bottom]
	}

	// MARK: - NavigationBar
	func navigationBarViewController() -> NSViewController {
		return navigationBarVC
	}

	// MARK: - Actions
	@IBAction func pushToThirdViewController(_: AnyObject?) {
		let thirdVC = ThirdViewController()
		navigationController?.push(viewController: thirdVC, animated: true)
	}

	@IBAction func pushWithCustomAnimations(_: AnyObject?) {
		let thirdVC = ThirdViewController()
		let contentAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.view.bounds ?? .zero
			
			let slideToBottomTransform = CATransform3DMakeTranslation(0, -viewBounds.height, 0)
			let slideToBottomAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToBottomAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToBottomAnimation.toValue = NSValue(caTransform3D: slideToBottomTransform)
			slideToBottomAnimation.duration = 0.25
			slideToBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToBottomAnimation.fillMode = kCAFillModeForwards
			slideToBottomAnimation.isRemovedOnCompletion = false

			let slideFromTopTransform = CATransform3DMakeTranslation(0, viewBounds.height, 0)
			let slideFromTopAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideFromTopAnimation.fromValue = NSValue(caTransform3D: slideFromTopTransform)
			slideFromTopAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideFromTopAnimation.duration = 0.25
			slideFromTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromTopAnimation.fillMode = kCAFillModeForwards
			slideFromTopAnimation.isRemovedOnCompletion = false

			return ([slideToBottomAnimation], [slideFromTopAnimation])
		}
		let navigationBarAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.navigationController?.navigationBarController?.contentView?.bounds ?? .zero
			
			let slideToBottomTransform = CATransform3DMakeTranslation(0, -viewBounds.height / 2, 0)
			let slideToBottomAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToBottomAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToBottomAnimation.toValue = NSValue(caTransform3D: slideToBottomTransform)
			slideToBottomAnimation.duration = 0.25
			slideToBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToBottomAnimation.fillMode = kCAFillModeForwards
			slideToBottomAnimation.isRemovedOnCompletion = false
			
			let slideFromTopTransform = CATransform3DMakeTranslation(0, viewBounds.height / 2, 0)
			let slideFromTopAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideFromTopAnimation.fromValue = NSValue(caTransform3D: slideFromTopTransform)
			slideFromTopAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideFromTopAnimation.duration = 0.25
			slideFromTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromTopAnimation.fillMode = kCAFillModeForwards
			slideFromTopAnimation.isRemovedOnCompletion = false

			let fadeInAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
			fadeInAnimation.fromValue = 0.0
			fadeInAnimation.toValue = 1.0
			fadeInAnimation.duration = 0.25
			fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeInAnimation.fillMode = kCAFillModeForwards
			fadeInAnimation.isRemovedOnCompletion = false

			let fadeOutAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
			fadeOutAnimation.fromValue = 1.0
			fadeOutAnimation.toValue = 0.0
			fadeOutAnimation.duration = 0.25
			fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeOutAnimation.fillMode = kCAFillModeForwards
			fadeOutAnimation.isRemovedOnCompletion = false
			
			return ([fadeOutAnimation, slideToBottomAnimation], [fadeInAnimation, slideFromTopAnimation])
		}
		navigationController?.push(viewController: thirdVC, contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	@IBAction func popToRootVC(_: AnyObject?) {
		navigationController?.popToRootViewController(animated: true)
	}

	func popVC() {
		navigationController?.popViewController(animated: true)
	}
}
