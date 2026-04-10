import Cocoa

class TitleBarView: NSView {
    var titleText: String = "WAMP" { didSet { needsDisplay = true } }
    var showButtons: Bool = true
    var showThemeButton: Bool = false
    var onClose: (() -> Void)?
    var onMinimize: (() -> Void)?
    var onTogglePin: (() -> Void)?
    var isPinned: Bool = true { didSet { needsDisplay = true } }

    override init(frame: NSRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(
            self, selector: #selector(themeDidChange),
            name: ThemeManager.didChangeNotification, object: nil
        )
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func themeDidChange() { needsDisplay = true }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let b = bounds

        // Gradient background
        let gradient = NSGradient(colors: [
            WinampTheme.titleBarTop,
            WinampTheme.titleBarBottom,
            WinampTheme.titleBarGradientMid,
            WinampTheme.titleBarBottom
        ])
        gradient?.draw(in: b, angle: 90)

        // Calculate text width
        let attrs: [NSAttributedString.Key: Any] = [
            .font: WinampTheme.titleBarFont,
            .foregroundColor: WinampTheme.titleBarText
        ]
        let textSize = titleText.size(withAttributes: attrs)
        let textX = (b.width - textSize.width) / 2
        let textY = (b.height - textSize.height) / 2

        // Draw stripes on both sides
        let stripeMargin: CGFloat = 4
        let stripeGap: CGFloat = 4

        let leftEnd = textX - stripeGap - stripeMargin
        if leftEnd > stripeMargin {
            drawStripes(in: NSRect(x: stripeMargin, y: (b.height - 8) / 2, width: leftEnd, height: 8))
        }

        let rightStart = textX + textSize.width + stripeGap
        var rightEnd = b.width - stripeMargin
        if showButtons { rightEnd -= 41 }
        if showThemeButton { rightEnd -= 38 }
        if rightEnd > rightStart {
            drawStripes(in: NSRect(x: rightStart, y: (b.height - 8) / 2, width: rightEnd - rightStart, height: 8))
        }

        // Title text
        titleText.draw(at: NSPoint(x: textX, y: textY), withAttributes: attrs)

        // Window buttons
        if showButtons {
            let btnSize: CGFloat = 9
            let btnY = (b.height - btnSize) / 2

            drawPinButton(
                NSRect(x: b.width - 33, y: btnY, width: btnSize, height: btnSize),
                pinned: isPinned
            )
            drawWindowButton(
                NSRect(x: b.width - 22, y: btnY, width: btnSize, height: btnSize),
                symbol: "−"
            )
            drawWindowButton(
                NSRect(x: b.width - 11, y: btnY, width: btnSize, height: btnSize),
                symbol: "×"
            )
        }

        // Theme button
        if showThemeButton {
            let btnX = showButtons ? b.width - 33 - 38 : b.width - 38
            drawThemeButton(NSRect(x: btnX, y: 2, width: 34, height: b.height - 4))
        }

        // Bottom border
        WinampTheme.insetBorderDark.setStroke()
        let borderPath = NSBezierPath()
        borderPath.move(to: NSPoint(x: 0, y: 0))
        borderPath.line(to: NSPoint(x: b.width, y: 0))
        borderPath.lineWidth = 1
        borderPath.stroke()
    }

    private func drawStripes(in rect: NSRect) {
        guard rect.width > 2 else { return }
        var y = rect.minY
        while y < rect.maxY - 1 {
            WinampTheme.titleBarStripe1.setFill()
            NSRect(x: rect.minX, y: y, width: rect.width, height: 1).fill()
            y += 1
            WinampTheme.titleBarStripe2.setFill()
            NSRect(x: rect.minX, y: y, width: rect.width, height: 1).fill()
            y += 2
        }
    }

    private func drawWindowButton(_ rect: NSRect, symbol: String) {
        WinampTheme.titleBarButtonFace.setFill()
        rect.fill()

        WinampTheme.buttonBorderLight.setStroke()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))
        path.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path.lineWidth = 1
        path.stroke()

        WinampTheme.buttonBorderDark.setStroke()
        let path2 = NSBezierPath()
        path2.move(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path2.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        path2.line(to: NSPoint(x: rect.minX, y: rect.minY))
        path2.lineWidth = 1
        path2.stroke()

        let attrs: [NSAttributedString.Key: Any] = [
            .font: WinampTheme.smallLabelFont,
            .foregroundColor: WinampTheme.titleBarButtonText
        ]
        let size = symbol.size(withAttributes: attrs)
        symbol.draw(
            at: NSPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2),
            withAttributes: attrs
        )
    }

    private func drawPinButton(_ rect: NSRect, pinned: Bool) {
        WinampTheme.titleBarButtonFace.setFill()
        rect.fill()

        WinampTheme.buttonBorderLight.setStroke()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))
        path.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path.lineWidth = 1
        path.stroke()

        WinampTheme.buttonBorderDark.setStroke()
        let path2 = NSBezierPath()
        path2.move(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path2.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        path2.line(to: NSPoint(x: rect.minX, y: rect.minY))
        path2.lineWidth = 1
        path2.stroke()

        let color = pinned ? WinampTheme.greenBright : WinampTheme.titleBarButtonText
        color.setStroke()
        color.setFill()
        let pinPath = NSBezierPath()
        pinPath.lineWidth = 1.0
        let cx = rect.midX
        let cy = rect.midY
        pinPath.move(to: NSPoint(x: cx, y: cy - 3))
        pinPath.line(to: NSPoint(x: cx, y: cy + 1))
        pinPath.stroke()
        let dotSize: CGFloat = pinned ? 3 : 2.5
        let dotRect = NSRect(x: cx - dotSize / 2, y: cy + 0.5, width: dotSize, height: dotSize)
        if pinned {
            NSBezierPath(ovalIn: dotRect).fill()
        } else {
            let oval = NSBezierPath(ovalIn: dotRect)
            oval.lineWidth = 0.8
            oval.stroke()
        }
    }

    private func drawThemeButton(_ rect: NSRect) {
        WinampTheme.titleBarButtonFace.setFill()
        rect.fill()

        WinampTheme.buttonBorderLight.setStroke()
        let path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))
        path.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path.lineWidth = 1
        path.stroke()

        WinampTheme.buttonBorderDark.setStroke()
        let path2 = NSBezierPath()
        path2.move(to: NSPoint(x: rect.maxX, y: rect.maxY))
        path2.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        path2.line(to: NSPoint(x: rect.minX, y: rect.minY))
        path2.lineWidth = 1
        path2.stroke()

        let attrs: [NSAttributedString.Key: Any] = [
            .font: WinampTheme.smallLabelFont,
            .foregroundColor: WinampTheme.titleBarButtonText
        ]
        let label = "THEME"
        let size = label.size(withAttributes: attrs)
        label.draw(
            at: NSPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2),
            withAttributes: attrs
        )
    }

    // MARK: - Window dragging
    private var dragOrigin: NSPoint?

    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let b = bounds
        let btnSize: CGFloat = 9
        let btnY = (b.height - btnSize) / 2
        let pinRect = NSRect(x: b.width - 33, y: btnY, width: btnSize, height: btnSize)
        let minimizeRect = NSRect(x: b.width - 22, y: btnY, width: btnSize, height: btnSize)
        let closeRect = NSRect(x: b.width - 11, y: btnY, width: btnSize, height: btnSize)

        let themeRect = themeButtonRect()

        if showButtons && (closeRect.contains(point) || minimizeRect.contains(point) || pinRect.contains(point)) {
            super.mouseDown(with: event)
            return
        }
        if showThemeButton && themeRect.contains(point) {
            super.mouseDown(with: event)
            return
        }
        dragOrigin = event.locationInWindow
    }

    override func mouseDragged(with event: NSEvent) {
        guard let origin = dragOrigin, let win = window else { return }
        let current = event.locationInWindow
        let dx = current.x - origin.x
        let dy = current.y - origin.y
        var frame = win.frame
        frame.origin.x += dx
        frame.origin.y += dy
        win.setFrameOrigin(frame.origin)
    }

    override func mouseUp(with event: NSEvent) {
        dragOrigin = nil
        let point = convert(event.locationInWindow, from: nil)
        let b = bounds
        let btnSize: CGFloat = 9
        let btnY = (b.height - btnSize) / 2

        if showButtons {
            let pinRect = NSRect(x: b.width - 33, y: btnY, width: btnSize, height: btnSize)
            let minimizeRect = NSRect(x: b.width - 22, y: btnY, width: btnSize, height: btnSize)
            let closeRect = NSRect(x: b.width - 11, y: btnY, width: btnSize, height: btnSize)
            if closeRect.contains(point) { onClose?(); return }
            if minimizeRect.contains(point) { onMinimize?(); return }
            if pinRect.contains(point) { onTogglePin?(); return }
        }

        if showThemeButton && themeButtonRect().contains(point) {
            showThemeMenu()
        }
    }

    private func themeButtonRect() -> NSRect {
        let b = bounds
        let btnX = showButtons ? b.width - 33 - 38 : b.width - 38
        return NSRect(x: btnX, y: 2, width: 34, height: b.height - 4)
    }

    private func showThemeMenu() {
        let menu = NSMenu()
        for theme in ThemeManager.shared.allThemes {
            let item = NSMenuItem(title: theme.name, action: #selector(selectTheme(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = theme.name
            item.state = ThemeManager.shared.current.name == theme.name ? .on : .off
            menu.addItem(item)
        }
        let rect = themeButtonRect()
        menu.popUp(positioning: nil, at: NSPoint(x: rect.minX, y: rect.minY), in: self)
    }

    @objc private func selectTheme(_ item: NSMenuItem) {
        guard let name = item.representedObject as? String else { return }
        ThemeManager.shared.apply(named: name)
    }
}
