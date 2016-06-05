import AppKit

class NavigationBarView: NSView {
	override func drawRect(dirtyRect: NSRect) {
		NSGraphicsContext.saveGraphicsState()
		NSColor.whiteColor().setFill()
		NSRectFill(dirtyRect)
		NSColor.blackColor().colorWithAlphaComponent(0.2).setFill()
		NSRectFill(CGRect(origin: .zero, size: CGSize(width: dirtyRect.width, height: 1)))
		NSGraphicsContext.restoreGraphicsState()
	}
}
