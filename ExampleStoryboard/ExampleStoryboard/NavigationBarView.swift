import AppKit

class NavigationBarView: NSView {
	override func draw(_ dirtyRect: NSRect) {
		NSGraphicsContext.saveGraphicsState()
		NSColor.white.setFill()
		dirtyRect.fill()
		NSColor.black.withAlphaComponent(0.2).setFill()
		CGRect(origin: .zero, size: CGSize(width: dirtyRect.width, height: 1)).fill()
		NSGraphicsContext.restoreGraphicsState()
	}
}
