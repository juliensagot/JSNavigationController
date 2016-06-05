import AppKit
import JSNavigationController

private extension Selector {
	static let pushToThirdVC = #selector(SecondViewController.pushToThirdViewController(_:))
	static let popVC = #selector(SecondViewController.popVC)
}

class SecondViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	private let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "SecondViewController", bundle: NSBundle.mainBundle())!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		if let view = view as? NSVisualEffectView {
			view.material = .MediumLight
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
	@IBAction func pushToThirdViewController(_: AnyObject?) {
		let thirdVC = ThirdViewController()
		navigationController?.push(viewController: thirdVC, animated: true)
	}

	@IBAction func pushWithCustomAnimations(_: AnyObject?) {
		let thirdVC = ThirdViewController()
		let contentAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.view.bounds ?? .zero
			
			let slideToBottomTransform = CATransform3DMakeTranslation(0, -NSHeight(viewBounds), 0)
			let slideToBottomAnimation = CABasicAnimation(keyPath: "transform")
			slideToBottomAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToBottomAnimation.toValue = NSValue(CATransform3D: slideToBottomTransform)
			slideToBottomAnimation.duration = 0.25
			slideToBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToBottomAnimation.fillMode = kCAFillModeForwards
			slideToBottomAnimation.removedOnCompletion = false

			let slideFromTopTransform = CATransform3DMakeTranslation(0, NSHeight(viewBounds), 0)
			let slideFromTopAnimation = CABasicAnimation(keyPath: "transform")
			slideFromTopAnimation.fromValue = NSValue(CATransform3D: slideFromTopTransform)
			slideFromTopAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromTopAnimation.duration = 0.25
			slideFromTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromTopAnimation.fillMode = kCAFillModeForwards
			slideFromTopAnimation.removedOnCompletion = false

			return ([slideToBottomAnimation], [slideFromTopAnimation])
		}
		let navigationBarAnimation: AnimationBlock = { [weak self] (_, _) in
			let viewBounds = self?.navigationController?.navigationBarController?.contentView?.bounds ?? .zero
			
			let slideToBottomTransform = CATransform3DMakeTranslation(0, -NSHeight(viewBounds) / 2, 0)
			let slideToBottomAnimation = CABasicAnimation(keyPath: "transform")
			slideToBottomAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideToBottomAnimation.toValue = NSValue(CATransform3D: slideToBottomTransform)
			slideToBottomAnimation.duration = 0.25
			slideToBottomAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideToBottomAnimation.fillMode = kCAFillModeForwards
			slideToBottomAnimation.removedOnCompletion = false
			
			let slideFromTopTransform = CATransform3DMakeTranslation(0, NSHeight(viewBounds) / 2, 0)
			let slideFromTopAnimation = CABasicAnimation(keyPath: "transform")
			slideFromTopAnimation.fromValue = NSValue(CATransform3D: slideFromTopTransform)
			slideFromTopAnimation.toValue = NSValue(CATransform3D: CATransform3DIdentity)
			slideFromTopAnimation.duration = 0.25
			slideFromTopAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			slideFromTopAnimation.fillMode = kCAFillModeForwards
			slideFromTopAnimation.removedOnCompletion = false

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
