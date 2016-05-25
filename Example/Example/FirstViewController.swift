import AppKit
import JSNavigationController

private extension Selector {
	static let pushToSecondVC = #selector(FirstViewController.pushToSecondViewController(_:))
}

class FirstViewController: NSViewController, JSNavigationBarViewControllerProvider {
	weak var navigationController: JSNavigationController?
	private let navigationBarVC = BasicNavigationBarViewController()

	// MARK: - Initializers
	init() {
		super.init(nibName: "FirstViewController", bundle: NSBundle.mainBundle())!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor(deviceRed: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).CGColor
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.superview?.addConstraints(viewConstraints())

		// NavigationBar
		navigationBarVC.backButton?.hidden = true
		navigationBarVC.titleLabel?.stringValue = "First VC"
		navigationBarVC.nextButton?.action = .pushToSecondVC
		navigationBarVC.nextButton?.target = self
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
	@IBAction func pushToSecondViewController(_: AnyObject?) {
		let secondVC = SecondViewController()
		navigationController?.push(viewController: secondVC, animated: true)
	}
}
