import AppKit

class NavigationBarView: NSView {
	override func draw(_ dirtyRect: NSRect) {
		NSGraphicsContext.saveGraphicsState()
        NSColor.white.setFill()
        NSGraphicsContext.current?.cgContext.fill(dirtyRect)
        NSColor.black.withAlphaComponent(0.2).setFill()
        NSGraphicsContext.current?.cgContext.fill(CGRect(origin: .zero, size: CGSize(width: dirtyRect.width, height: 1)))
		NSGraphicsContext.restoreGraphicsState()
	}
}
