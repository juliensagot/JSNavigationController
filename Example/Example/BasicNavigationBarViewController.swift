import AppKit

class BasicNavigationBarViewController: NSViewController {
	@IBOutlet var backButton: NSButton?
	@IBOutlet var titleLabel: NSTextField?
	@IBOutlet var nextButton: NSButton?

	// MARK: - Initializers
	init() {
		super.init(nibName: "BasicNavigationBarViewController", bundle: Bundle.main)
	}

	required init?(coder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.wantsLayer = true
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.superview?.addConstraints(viewConstraints())
	}

	override func viewWillDisappear() {
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
}
