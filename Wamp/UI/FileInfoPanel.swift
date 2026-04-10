import Cocoa

class FileInfoPanel: NSView {
    private struct Row {
        let labelView: NSTextField
        let valueView: NSTextField
    }

    private let titleBar = TitleBarView()
    private var rows: [Row] = []
    private let keys = ["Title", "Artist", "Album", "Codec", "Bitrate", "Sample Rate", "Channels", "File Size", "Play Count", "Last Played"]

    override init(frame: NSRect) {
        super.init(frame: frame)
        wantsLayer = true
        layer?.backgroundColor = WinampTheme.frameBackground.cgColor
        setup()
        NotificationCenter.default.addObserver(
            self, selector: #selector(themeDidChange),
            name: ThemeManager.didChangeNotification, object: nil
        )
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func themeDidChange() {
        layer?.backgroundColor = WinampTheme.frameBackground.cgColor
        for row in rows {
            row.labelView.textColor = WinampTheme.greenDimText
            row.valueView.textColor = WinampTheme.greenBright
        }
        needsDisplay = true
    }

    private func setup() {
        titleBar.titleText = "FILE INFO"
        titleBar.showButtons = false
        addSubview(titleBar)

        for key in keys {
            let label = NSTextField(labelWithString: key + ":")
            label.font = WinampTheme.bitrateFont
            label.textColor = WinampTheme.greenDimText
            label.isBezeled = false
            label.drawsBackground = false
            label.alignment = .right

            let value = NSTextField(labelWithString: "—")
            value.font = WinampTheme.bitrateFont
            value.textColor = WinampTheme.greenBright
            value.isBezeled = false
            value.drawsBackground = false
            value.lineBreakMode = .byTruncatingTail

            addSubview(label)
            addSubview(value)
            rows.append(Row(labelView: label, valueView: value))
        }
    }

    override func layout() {
        super.layout()
        let w = bounds.width
        let pad: CGFloat = 4
        let rowH: CGFloat = 13
        let labelW: CGFloat = 68
        let titleH = WinampTheme.titleBarHeight

        titleBar.frame = NSRect(x: 0, y: bounds.height - titleH, width: w, height: titleH)

        var y = bounds.height - titleH - pad
        for row in rows {
            y -= rowH
            row.labelView.frame = NSRect(x: pad, y: y, width: labelW, height: rowH)
            row.valueView.frame = NSRect(x: pad + labelW + 4, y: y, width: w - labelW - pad * 2 - 4, height: rowH)
        }
    }

    func configure(with track: Track?) {
        guard let track else {
            for row in rows { row.valueView.stringValue = "—" }
            return
        }

        let values: [String] = [
            track.title,
            track.artist,
            track.album.isEmpty ? "—" : track.album,
            track.codec.isEmpty ? "—" : track.codec,
            track.bitrate > 0 ? "\(track.bitrate) kbps" : "—",
            track.sampleRate > 0 ? "\(track.sampleRate) Hz" : "—",
            track.channels == 1 ? "Mono" : track.channels == 2 ? "Stereo" : "\(track.channels) ch",
            track.fileSize > 0 ? ByteCountFormatter.string(fromByteCount: track.fileSize, countStyle: .file) : "—",
            "\(track.playCount) play\(track.playCount == 1 ? "" : "s")",
            track.lastPlayed.map { RelativeDateTimeFormatter().localizedString(for: $0, relativeTo: Date()) } ?? "Never"
        ]

        for (row, value) in zip(rows, values) {
            row.valueView.stringValue = value
        }
    }

    static let panelHeight: CGFloat = WinampTheme.titleBarHeight + CGFloat(10) * 13 + 8
}
