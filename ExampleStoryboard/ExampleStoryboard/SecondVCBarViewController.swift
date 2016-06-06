import AppKit

class SecondVCBarViewController: NSViewController {
	@IBOutlet var backButton: NSButton?
	@IBOutlet var titleLabel: NSTextField?
	@IBOutlet var thirdButton: NSButton?
	@IBOutlet var fourthButton: NSButton?
	
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
}
