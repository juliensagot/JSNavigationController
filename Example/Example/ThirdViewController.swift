import AppKit
import JSNavigationController

private extension Selector {
	static let popVC = #selector(ThirdViewController.popVC)
}

class ThirdViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	private let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "ThirdViewController", bundle: NSBundle.mainBundle())!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.wantsLayer = true
		if let view = view as? NSVisualEffectView {
			view.material = .Dark
		}
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		navigationBarVC.titleLabel?.stringValue = "Third VC"
		navigationBarVC.nextButton?.hidden = true
		navigationBarVC.backButton?.action = .popVC
		navigationBarVC.backButton?.target = self
	}

	override func viewWillDisappear() {
		view.superview?.removeConstraints(viewConstraints())
	}

	// MARK: - Layout
	private func viewConstraints() -> [NSLayoutConstraint] {
		let left = NSLayoutConstraint(
			item: view, attribute: .Left, relatedBy: .Equal,
			toItem: view.superview, attribute: .Left,
			multiplier: 1.0, constant: 0.0
		)
		let right = NSLayoutConstraint(
			item: view, attribute: .Right, relatedBy: .Equal,
			toItem: view.superview, attribute: .Right,
			multiplier: 1.0, constant: 0.0
		)
		let top = NSLayoutConstraint(
			item: view, attribute: .Top, relatedBy: .Equal,
			toItem: view.superview, attribute: .Top,
			multiplier: 1.0, constant: 0.0
		)
		let bottom = NSLayoutConstraint(
			item: view, attribute: .Bottom, relatedBy: .Equal,
			toItem: view.superview, attribute: .Bottom,
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
			let viewBounds = self?.navigationController?.containerView?.bounds ?? .zero

			let slideFromBottomTransform = CATransform3DMakeTranslation(0, -NSHeight(viewBounds), 0)
			let slideFromBottomAnimation = CABasicAnimation(keyPath: "transform")
			slideFromBottomAnimation.fromValue = NSValue(CATransform3D: slideFromBottomTransform)
			slideFromBottomAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromBottomAnimation.duration = 0.25
			slideFromBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromBottomAnimation.fillMode = kCAFillModeForwards
			slideFromBottomAnimation.removedOnCompletion = false

			let slideToTopTransform = CATransform3DMakeTranslation(0, NSHeight(viewBounds), 0)
			let slideToTopAnimation = CABasicAnimation(keyPath: "transform")
			slideToTopAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToTopAnimation.toValue = NSValue(CATransform3D: slideToTopTransform)
			slideToTopAnimation.duration = 0.25
			slideToTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToTopAnimation.fillMode = kCAFillModeForwards
			slideToTopAnimation.removedOnCompletion = false
			
			return ([slideToTopAnimation], [slideFromBottomAnimation])
		}
		let navigationBarAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.navigationController?.navigationBarController.containerView?.bounds ?? .zero
			
			let slideFromBottomTransform = CATransform3DMakeTranslation(0, -NSHeight(viewBounds) / 2, 0)
			let slideFromBottomAnimation = CABasicAnimation(keyPath: "transform")
			slideFromBottomAnimation.fromValue = NSValue(CATransform3D: slideFromBottomTransform)
			slideFromBottomAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromBottomAnimation.duration = 0.25
			slideFromBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromBottomAnimation.fillMode = kCAFillModeForwards
			slideFromBottomAnimation.removedOnCompletion = false
			
			let slideToTopTransform = CATransform3DMakeTranslation(0, NSHeight(viewBounds) / 2, 0)
			let slideToTopAnimation = CABasicAnimation(keyPath: "transform")
			slideToTopAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToTopAnimation.toValue = NSValue(CATransform3D: slideToTopTransform)
			slideToTopAnimation.duration = 0.25
			slideToTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToTopAnimation.fillMode = kCAFillModeForwards
			slideToTopAnimation.removedOnCompletion = false
			
			let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
			fadeInAnimation.fromValue = 0.0
			fadeInAnimation.toValue = 1.0
			fadeInAnimation.duration = 0.25
			fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeInAnimation.fillMode = kCAFillModeForwards
			fadeInAnimation.removedOnCompletion = false
			
			let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
			fadeOutAnimation.fromValue = 1.0
			fadeOutAnimation.toValue = 0.0
			fadeOutAnimation.duration = 0.25
			fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			fadeOutAnimation.fillMode = kCAFillModeForwards
			fadeOutAnimation.removedOnCompletion = false
			
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
}
