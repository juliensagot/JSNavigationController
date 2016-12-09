import AppKit
import JSNavigationController

class FourthViewController: NSViewController {
	weak var navigationController: JSNavigationController?

	init() {
		super.init(nibName: "FourthViewController", bundle: Bundle.main)!
	}

	required init?(coder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor(deviceRed: 120/255.0, green: 163/255.0, blue: 255/255.0, alpha: 1.0).cgColor
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.superview?.addConstraints(viewConstraints())
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

	// MARK: - Actions
	@IBAction func popVC(_: AnyObject?) {
		navigationController?.popViewController(animated: true)
	}
}
