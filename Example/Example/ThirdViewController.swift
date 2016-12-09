import AppKit
import JSNavigationController

private extension Selector {
	static let popVC = #selector(ThirdViewController.popVC)
	static let pushToFourthVC = #selector(ThirdViewController.pushFourthVC(_:))
}

class ThirdViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	fileprivate let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "ThirdViewController", bundle: Bundle.main)!
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
			view.material = .dark
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		navigationBarVC.titleLabel?.stringValue = "Third VC"
		navigationBarVC.backButton?.action = .popVC
		navigationBarVC.backButton?.target = self
		navigationBarVC.nextButton?.action = .pushToFourthVC
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
	@IBAction func popWithCustomAnimations(_: AnyObject?) {
		let contentAnimation: AnimationBlock = { [weak self] (viewToHide, viewToShow) in
			let viewBounds = self?.navigationController?.contentView?.bounds ?? .zero

			let slideFromBottomTransform = CATransform3DMakeTranslation(0, -viewBounds.height, 0)
			let slideFromBottomAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideFromBottomAnimation.fromValue = NSValue(caTransform3D: slideFromBottomTransform)
			slideFromBottomAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideFromBottomAnimation.duration = 0.25
			slideFromBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromBottomAnimation.fillMode = kCAFillModeForwards
			slideFromBottomAnimation.isRemovedOnCompletion = false

			let slideToTopTransform = CATransform3DMakeTranslation(0, viewBounds.height, 0)
			let slideToTopAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToTopAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToTopAnimation.toValue = NSValue(caTransform3D: slideToTopTransform)
			slideToTopAnimation.duration = 0.25
			slideToTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToTopAnimation.fillMode = kCAFillModeForwards
			slideToTopAnimation.isRemovedOnCompletion = false
			
			return ([slideToTopAnimation], [slideFromBottomAnimation])
		}
		let navigationBarAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.navigationController?.navigationBarController?.contentView?.bounds ?? .zero
			
			let slideFromBottomTransform = CATransform3DMakeTranslation(0, -viewBounds.height / 2, 0)
			let slideFromBottomAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideFromBottomAnimation.fromValue = NSValue(caTransform3D: slideFromBottomTransform)
			slideFromBottomAnimation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideFromBottomAnimation.duration = 0.25
			slideFromBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromBottomAnimation.fillMode = kCAFillModeForwards
			slideFromBottomAnimation.isRemovedOnCompletion = false
			
			let slideToTopTransform = CATransform3DMakeTranslation(0, viewBounds.height / 2, 0)
			let slideToTopAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
			slideToTopAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
			slideToTopAnimation.toValue = NSValue(caTransform3D: slideToTopTransform)
			slideToTopAnimation.duration = 0.25
			slideToTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToTopAnimation.fillMode = kCAFillModeForwards
			slideToTopAnimation.isRemovedOnCompletion = false
			
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
			
			return ([fadeOutAnimation, slideToTopAnimation], [fadeInAnimation, slideFromBottomAnimation])
		}
		navigationController?.popViewController(contentAnimation: contentAnimation, navigationBarAnimation: navigationBarAnimation)
	}

	@IBAction func popToRootVC(_: AnyObject?) {
		navigationController?.popToRootViewController(animated: true)
	}

	func popVC() {
		navigationController?.popViewController(animated: true)
	}

	@IBAction func pushFourthVC(_: AnyObject?) {
		let fourthVC = FourthViewController()
		fourthVC.navigationController = navigationController
		navigationController?.push(viewController: fourthVC, animated: true)
	}
}
