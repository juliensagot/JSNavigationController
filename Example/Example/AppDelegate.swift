import Cocoa
import JSNavigationController

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, JSNavigationControllerDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var navBarView: NSView!
	@IBOutlet weak var contentView: NSView!
	fileprivate var navigationController: JSNavigationController?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.contentView?.wantsLayer = true
		let firstVC = FirstViewController()
		navigationController = JSNavigationController(rootViewController: firstVC, contentView: contentView, navigationBarView: navBarView)
		navigationController?.delegate = self
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}

	func navigationController(_ navigationController: JSNavigationController, willShowViewController viewController: NSViewController, animated: Bool) {
		print("\(navigationController) will show view controller: \(viewController), animated: \(animated)")
	}

	func navigationController(_ navigationController: JSNavigationController, didShowViewController viewController: NSViewController, animated: Bool) {
		print("\(navigationController) did show view controller: \(viewController), animated: \(animated)")
	}
}
