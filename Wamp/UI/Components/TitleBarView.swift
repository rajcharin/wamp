import Cocoa
import Combine
import CoreAudio

class TitleBarView: NSView {
    var titleText: String = "WAMP" { didSet { needsDisplay = true } }
    var showButtons: Bool = true
    var showSettingsButton: Bool = false
    var onClose: (() -> Void)?
    var onMinimize: (() -> Void)?
    var onTogglePin: (() -> Void)?
    var isPinned: Bool = true { didSet { needsDisplay = true } }

    weak var audioEngine: AudioEngine? {
        didSet { bindAudioEngine() }
    }
    private var cancellables = Set<AnyCancellable>()

    override init(frame: NSRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(
            self, selector: #selector(themeDidChange),
            name: ThemeManager.didChangeNotification, object: nil
        )
    }

    required init?(coder: NSCoder) { fatalError() }

    private func bindAudioEngine() {
        cancellables.removeAll()
        audioEngine?.$sleepTimerRemaining
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.needsDisplay = true }
            .store(in: &cancellables)
    }

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
        if showSettingsButton { rightEnd -= 38 }
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

        // Settings button (≡ — consolidates theme, sleep, output)
        if showSettingsButton {
            drawSettingsButton(settingsButtonRect())
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

        if showButtons && (closeRect.contains(point) || minimizeRect.contains(point) || pinRect.contains(point)) {
            super.mouseDown(with: event)
            return
        }
        if showSettingsButton && settingsButtonRect().contains(point) { super.mouseDown(with: event); return }
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

        if showSettingsButton && settingsButtonRect().contains(point) { showSettingsMenu(); return }
    }

    // Button rect — settings button sits just left of the window control cluster
    private func settingsButtonRect() -> NSRect {
        let b = bounds
        let offset: CGFloat = (showButtons ? 33 : 0) + 4
        return NSRect(x: b.width - offset - 34, y: 2, width: 34, height: b.height - 4)
    }

    // MARK: - Settings Button (≡)

    private func drawSettingsButton(_ rect: NSRect) {
        WinampTheme.titleBarButtonFace.setFill()
        rect.fill()

        WinampTheme.buttonBorderLight.setStroke()
        let p1 = NSBezierPath()
        p1.move(to: NSPoint(x: rect.minX, y: rect.minY))
        p1.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        p1.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        p1.lineWidth = 1; p1.stroke()
        WinampTheme.buttonBorderDark.setStroke()
        let p2 = NSBezierPath()
        p2.move(to: NSPoint(x: rect.maxX, y: rect.maxY))
        p2.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        p2.line(to: NSPoint(x: rect.minX, y: rect.minY))
        p2.lineWidth = 1; p2.stroke()

        // Show sleep countdown badge when timer is active; otherwise show ≡ lines
        let remaining = audioEngine?.sleepTimerRemaining
        if let r = remaining {
            let mins = Int(r) / 60
            let secs = Int(r) % 60
            let label = String(format: "%d:%02d", mins, secs)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: WinampTheme.smallLabelFont,
                .foregroundColor: WinampTheme.greenBright
            ]
            let size = label.size(withAttributes: attrs)
            label.draw(at: NSPoint(x: rect.midX - size.width / 2, y: rect.midY - size.height / 2), withAttributes: attrs)
        } else {
            // Draw three horizontal hamburger lines
            WinampTheme.titleBarButtonText.setStroke()
            let lineW: CGFloat = 14
            let cx = rect.midX
            let cy = rect.midY
            for dy in [-2.5, 0.0, 2.5] as [CGFloat] {
                let line = NSBezierPath()
                line.move(to: NSPoint(x: cx - lineW / 2, y: cy + dy))
                line.line(to: NSPoint(x: cx + lineW / 2, y: cy + dy))
                line.lineWidth = 1
                line.stroke()
            }
        }
    }

    private func showSettingsMenu() {
        let menu = NSMenu()

        // ── Theme ──────────────────────────────────────────
        let themeHeader = NSMenuItem(title: "Theme", action: nil, keyEquivalent: "")
        themeHeader.isEnabled = false
        menu.addItem(themeHeader)
        for theme in ThemeManager.shared.allThemes {
            let item = NSMenuItem(title: "  \(theme.name)", action: #selector(selectTheme(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = theme.name
            item.state = ThemeManager.shared.current.name == theme.name ? .on : .off
            menu.addItem(item)
        }

        menu.addItem(.separator())

        // ── Sleep Timer ────────────────────────────────────
        let sleepHeader = NSMenuItem(title: "Sleep Timer", action: nil, keyEquivalent: "")
        sleepHeader.isEnabled = false
        menu.addItem(sleepHeader)
        for mins in [15, 30, 45, 60] {
            let item = NSMenuItem(title: "  \(mins) min", action: #selector(selectSleepTimer(_:)), keyEquivalent: "")
            item.target = self
            item.tag = mins
            menu.addItem(item)
        }
        if audioEngine?.sleepTimerRemaining != nil {
            let cancel = NSMenuItem(title: "  Cancel Timer", action: #selector(cancelSleepTimer), keyEquivalent: "")
            cancel.target = self
            menu.addItem(cancel)
        }

        menu.addItem(.separator())

        // ── Output Device ──────────────────────────────────
        let outHeader = NSMenuItem(title: "Output Device", action: nil, keyEquivalent: "")
        outHeader.isEnabled = false
        menu.addItem(outHeader)
        let devices = OutputDeviceManager.availableOutputDevices()
        let currentID = audioEngine?.currentOutputDeviceID ?? OutputDeviceManager.currentOutputDeviceID()
        if devices.isEmpty {
            let none = NSMenuItem(title: "  No output devices found", action: nil, keyEquivalent: "")
            none.isEnabled = false
            menu.addItem(none)
        } else {
            for device in devices {
                let item = NSMenuItem(title: "  \(device.name)", action: #selector(selectOutputDevice(_:)), keyEquivalent: "")
                item.target = self
                item.representedObject = device.id
                item.state = device.id == currentID ? .on : .off
                menu.addItem(item)
            }
        }

        let rect = settingsButtonRect()
        menu.popUp(positioning: nil, at: NSPoint(x: rect.minX, y: rect.minY), in: self)
    }

    @objc private func selectTheme(_ item: NSMenuItem) {
        guard let name = item.representedObject as? String else { return }
        ThemeManager.shared.apply(named: name)
    }

    @objc private func selectSleepTimer(_ item: NSMenuItem) {
        audioEngine?.setSleepTimer(minutes: item.tag)
    }

    @objc private func cancelSleepTimer() {
        audioEngine?.cancelSleepTimer()
    }

    @objc private func selectOutputDevice(_ item: NSMenuItem) {
        guard let deviceID = item.representedObject as? AudioDeviceID else { return }
        audioEngine?.selectOutputDevice(deviceID)
    }
}
