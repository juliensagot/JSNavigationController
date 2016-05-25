import Cocoa
import JSNavigationController

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var navBarView: NSView!
	@IBOutlet weak var contentView: NSView!
	private var navigationController: JSNavigationController?


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		window.contentView?.wantsLayer = true
		let firstVC = FirstViewController()
		navigationController = JSNavigationController(rootViewController: firstVC, contentView: contentView, navigationBarView: navBarView)
	}

	func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
		return true
	}
}

