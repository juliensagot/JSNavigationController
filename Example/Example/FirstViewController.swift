import AppKit
import JSNavigationController

private extension Selector {
	static let pushToSecondVC = #selector(FirstViewController.pushToSecondViewController(_:))
}

class FirstViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	fileprivate let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "FirstViewController", bundle: Bundle.main)!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor(deviceRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		navigationBarVC.backButton?.isHidden = true
		navigationBarVC.titleLabel?.stringValue = "First VC"
		navigationBarVC.nextButton?.action = .pushToSecondVC
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
	@IBAction func pushToSecondViewController(_: AnyObject?) {
		let secondVC = SecondViewController()
		navigationController?.push(viewController: secondVC, animated: true)
	}
}
