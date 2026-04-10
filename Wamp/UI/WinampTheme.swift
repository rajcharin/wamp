import Cocoa

extension NSColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Theme Definition

struct WinampThemeDefinition {
    let name: String

    // Frame
    var frameBackground: NSColor
    var frameBorderLight: NSColor
    var frameBorderDark: NSColor

    // Title bar
    var titleBarTop: NSColor
    var titleBarBottom: NSColor
    var titleBarStripe1: NSColor
    var titleBarStripe2: NSColor
    var titleBarText: NSColor
    var titleBarGradientMid: NSColor
    var titleBarButtonFace: NSColor
    var titleBarButtonText: NSColor

    // LCD / Display
    var lcdBackground: NSColor
    var greenBright: NSColor
    var greenSecondary: NSColor
    var greenDim: NSColor
    var greenDimText: NSColor

    // Playlist
    var white: NSColor
    var selectionBlue: NSColor
    var playlistRowBackground: NSColor
    var searchFieldBackground: NSColor

    // Buttons
    var buttonFaceTop: NSColor
    var buttonFaceBottom: NSColor
    var buttonBorderLight: NSColor
    var buttonBorderDark: NSColor
    var buttonTextActive: NSColor
    var buttonTextInactive: NSColor
    var buttonIconDefault: NSColor

    // Seek / Balance sliders
    var seekFillTop: NSColor
    var seekFillBottom: NSColor
    var seekThumbTop: NSColor
    var seekThumbMid: NSColor
    var seekThumbBottom: NSColor
    var seekThumbBorderLight: NSColor
    var seekThumbBorderDark: NSColor

    // Volume slider
    var volumeBgStart: NSColor
    var volumeBgEnd: NSColor
    var volumeFillStart: NSColor
    var volumeFillEnd: NSColor
    var volumeThumbTop: NSColor
    var volumeThumbMid: NSColor
    var volumeThumbBottom: NSColor
    var volumeThumbBorderLight: NSColor
    var volumeThumbBorderDark: NSColor

    // EQ sliders
    var eqSliderBgTop: NSColor
    var eqSliderBgBottom: NSColor
    var eqSliderTick: NSColor
    var eqSliderCenter: NSColor
    var eqThumbTop: NSColor
    var eqThumbMid: NSColor
    var eqThumbBottom: NSColor
    var eqThumbBorderLight: NSColor
    var eqThumbBorderDark: NSColor
    var eqFillStart: NSColor
    var eqFillEnd: NSColor
    var eqBandLabelColor: NSColor
    var eqDbLabelColor: NSColor

    // Spectrum
    var spectrumBarBottom: NSColor
    var spectrumBarTop: NSColor

    // Inset borders (LCD panels)
    var insetBorderDark: NSColor
    var insetBorderLight: NSColor

    // Fonts
    var titleBarFont: NSFont
    var trackTitleFont: NSFont
    var bitrateFont: NSFont
    var smallLabelFont: NSFont
    var buttonFont: NSFont
    var playlistFont: NSFont
    var eqLabelFont: NSFont

    // Panel backgrounds (player left/right panels)
    var panelBackground: NSColor

    // Error state (missing files)
    var errorColor: NSColor
}

// MARK: - Built-in Themes

extension WinampThemeDefinition {
    private static let defaultFonts = Fonts()
    struct Fonts {
        let titleBar  = NSFont(name: "Tahoma-Bold", size: 8) ?? NSFont.boldSystemFont(ofSize: 8)
        let title     = NSFont(name: "Tahoma", size: 9)      ?? NSFont.systemFont(ofSize: 9)
        let bitrate   = NSFont(name: "Tahoma", size: 7)      ?? NSFont.systemFont(ofSize: 7)
        let small     = NSFont(name: "Tahoma", size: 6)      ?? NSFont.systemFont(ofSize: 6)
        let button    = NSFont(name: "Tahoma-Bold", size: 7) ?? NSFont.boldSystemFont(ofSize: 7)
        let playlist  = NSFont(name: "ArialMT", size: 8.5)   ?? NSFont.systemFont(ofSize: 8.5)
        let eqLabel   = NSFont(name: "Tahoma", size: 6)      ?? NSFont.systemFont(ofSize: 6)
    }

    /// Original Winamp 2.x look — green-on-black, gold title bar
    static let classic = WinampThemeDefinition(
        name: "Classic",
        frameBackground:      NSColor(hex: 0x3C4250),
        frameBorderLight:     NSColor(hex: 0x5A6070),
        frameBorderDark:      NSColor(hex: 0x20242C),
        titleBarTop:          NSColor(hex: 0x4A5268),
        titleBarBottom:       NSColor(hex: 0x222840),
        titleBarStripe1:      NSColor(hex: 0xB8860B),
        titleBarStripe2:      NSColor(hex: 0xDAA520),
        titleBarText:         NSColor(hex: 0xC0C8E0),
        titleBarGradientMid:  NSColor(hex: 0x3A4460),
        titleBarButtonFace:   NSColor(hex: 0x3A4060),
        titleBarButtonText:   NSColor(hex: 0xA0A8C0),
        lcdBackground:        .black,
        greenBright:          NSColor(hex: 0x00E000),
        greenSecondary:       NSColor(hex: 0x00A800),
        greenDim:             NSColor(hex: 0x1A3A1A),
        greenDimText:         NSColor(hex: 0x1A5A1A),
        white:                .white,
        selectionBlue:        NSColor(hex: 0x0000C0),
        playlistRowBackground: .black,
        searchFieldBackground: NSColor(hex: 0x0A0E0A),
        buttonFaceTop:        NSColor(hex: 0x4A4E58),
        buttonFaceBottom:     NSColor(hex: 0x3A3E48),
        buttonBorderLight:    NSColor(hex: 0x5A5E68),
        buttonBorderDark:     NSColor(hex: 0x2A2E38),
        buttonTextActive:     NSColor(hex: 0x00E000),
        buttonTextInactive:   NSColor(hex: 0x7A8A9A),
        buttonIconDefault:    NSColor(hex: 0x8A9AAA),
        seekFillTop:          NSColor(hex: 0x6A8A40),
        seekFillBottom:       NSColor(hex: 0x4A6A28),
        seekThumbTop:         NSColor(hex: 0x9AA060),
        seekThumbMid:         NSColor(hex: 0x6A7A40),
        seekThumbBottom:      NSColor(hex: 0x4A5A28),
        seekThumbBorderLight: NSColor(hex: 0xB0BA70),
        seekThumbBorderDark:  NSColor(hex: 0x3A4A20),
        volumeBgStart:        NSColor(hex: 0x1A1200),
        volumeBgEnd:          NSColor(hex: 0xAA7000),
        volumeFillStart:      NSColor(hex: 0x8A6A20),
        volumeFillEnd:        NSColor(hex: 0xFFAA00),
        volumeThumbTop:       NSColor(hex: 0xDAA520),
        volumeThumbMid:       NSColor(hex: 0xAA7A10),
        volumeThumbBottom:    NSColor(hex: 0x8A6000),
        volumeThumbBorderLight: NSColor(hex: 0xEEBB40),
        volumeThumbBorderDark:  NSColor(hex: 0x6A5000),
        eqSliderBgTop:        NSColor(hex: 0x2A2810),
        eqSliderBgBottom:     NSColor(hex: 0x332E14),
        eqSliderTick:         NSColor(hex: 0x3A3518),
        eqSliderCenter:       NSColor(hex: 0x4A4520),
        eqThumbTop:           NSColor(hex: 0xB0BA60),
        eqThumbMid:           NSColor(hex: 0x8A9A40),
        eqThumbBottom:        NSColor(hex: 0x6A7A28),
        eqThumbBorderLight:   NSColor(hex: 0xD0DA80),
        eqThumbBorderDark:    NSColor(hex: 0x4A5A18),
        eqFillStart:          NSColor(hex: 0x2A6A10),
        eqFillEnd:            NSColor(hex: 0x4A8A20),
        eqBandLabelColor:     NSColor(hex: 0x6A8A6A),
        eqDbLabelColor:       NSColor(hex: 0x6A7A6A),
        spectrumBarBottom:    NSColor(hex: 0x00C000),
        spectrumBarTop:       NSColor(hex: 0xE0E000),
        insetBorderDark:      NSColor(hex: 0x1A1E28),
        insetBorderLight:     NSColor(hex: 0x4A4E58),
        titleBarFont:         defaultFonts.titleBar,
        trackTitleFont:       defaultFonts.title,
        bitrateFont:          defaultFonts.bitrate,
        smallLabelFont:       defaultFonts.small,
        buttonFont:           defaultFonts.button,
        playlistFont:         defaultFonts.playlist,
        eqLabelFont:          defaultFonts.eqLabel,
        panelBackground:      .black,
        errorColor:           NSColor(hex: 0xFF4444)
    )

    /// Modern dark — blue-gray frame, white and cyan accents
    static let darkSteel = WinampThemeDefinition(
        name: "Dark Steel",
        frameBackground:      NSColor(hex: 0x1E2530),
        frameBorderLight:     NSColor(hex: 0x3A4555),
        frameBorderDark:      NSColor(hex: 0x0E1018),
        titleBarTop:          NSColor(hex: 0x2A3545),
        titleBarBottom:       NSColor(hex: 0x0E1420),
        titleBarStripe1:      NSColor(hex: 0x2E8BC0),
        titleBarStripe2:      NSColor(hex: 0x48A8E0),
        titleBarText:         NSColor(hex: 0xD0E4F4),
        titleBarGradientMid:  NSColor(hex: 0x1A2535),
        titleBarButtonFace:   NSColor(hex: 0x253040),
        titleBarButtonText:   NSColor(hex: 0x90B4D0),
        lcdBackground:        NSColor(hex: 0x060A10),
        greenBright:          NSColor(hex: 0x48D0FF),
        greenSecondary:       NSColor(hex: 0x2090C0),
        greenDim:             NSColor(hex: 0x0A1825),
        greenDimText:         NSColor(hex: 0x0A2030),
        white:                .white,
        selectionBlue:        NSColor(hex: 0x1E5A9C),
        playlistRowBackground: NSColor(hex: 0x060A10),
        searchFieldBackground: NSColor(hex: 0x080C14),
        buttonFaceTop:        NSColor(hex: 0x2E3848),
        buttonFaceBottom:     NSColor(hex: 0x1E2838),
        buttonBorderLight:    NSColor(hex: 0x445060),
        buttonBorderDark:     NSColor(hex: 0x101820),
        buttonTextActive:     NSColor(hex: 0x48D0FF),
        buttonTextInactive:   NSColor(hex: 0x506070),
        buttonIconDefault:    NSColor(hex: 0x607080),
        seekFillTop:          NSColor(hex: 0x2878A8),
        seekFillBottom:       NSColor(hex: 0x185880),
        seekThumbTop:         NSColor(hex: 0x50A0D0),
        seekThumbMid:         NSColor(hex: 0x3080B0),
        seekThumbBottom:      NSColor(hex: 0x206090),
        seekThumbBorderLight: NSColor(hex: 0x70C0F0),
        seekThumbBorderDark:  NSColor(hex: 0x104060),
        volumeBgStart:        NSColor(hex: 0x060C18),
        volumeBgEnd:          NSColor(hex: 0x204878),
        volumeFillStart:      NSColor(hex: 0x285888),
        volumeFillEnd:        NSColor(hex: 0x48A8E8),
        volumeThumbTop:       NSColor(hex: 0x58C0F0),
        volumeThumbMid:       NSColor(hex: 0x3898C8),
        volumeThumbBottom:    NSColor(hex: 0x2070A0),
        volumeThumbBorderLight: NSColor(hex: 0x78D0FF),
        volumeThumbBorderDark:  NSColor(hex: 0x104870),
        eqSliderBgTop:        NSColor(hex: 0x101820),
        eqSliderBgBottom:     NSColor(hex: 0x182030),
        eqSliderTick:         NSColor(hex: 0x202838),
        eqSliderCenter:       NSColor(hex: 0x283040),
        eqThumbTop:           NSColor(hex: 0x60B0E0),
        eqThumbMid:           NSColor(hex: 0x4090C0),
        eqThumbBottom:        NSColor(hex: 0x2870A0),
        eqThumbBorderLight:   NSColor(hex: 0x80D0FF),
        eqThumbBorderDark:    NSColor(hex: 0x184060),
        eqFillStart:          NSColor(hex: 0x104878),
        eqFillEnd:            NSColor(hex: 0x2870A8),
        eqBandLabelColor:     NSColor(hex: 0x4880A8),
        eqDbLabelColor:       NSColor(hex: 0x406880),
        spectrumBarBottom:    NSColor(hex: 0x2090C0),
        spectrumBarTop:       NSColor(hex: 0x48D0FF),
        insetBorderDark:      NSColor(hex: 0x080C14),
        insetBorderLight:     NSColor(hex: 0x2A3848),
        titleBarFont:         defaultFonts.titleBar,
        trackTitleFont:       defaultFonts.title,
        bitrateFont:          defaultFonts.bitrate,
        smallLabelFont:       defaultFonts.small,
        buttonFont:           defaultFonts.button,
        playlistFont:         defaultFonts.playlist,
        eqLabelFont:          defaultFonts.eqLabel,
        panelBackground:      NSColor(hex: 0x060A10),
        errorColor:           NSColor(hex: 0xFF4444)
    )

    /// DOS terminal amber — warm amber LCD on dark brown frame
    static let amber = WinampThemeDefinition(
        name: "Amber",
        frameBackground:      NSColor(hex: 0x2A2010),
        frameBorderLight:     NSColor(hex: 0x483818),
        frameBorderDark:      NSColor(hex: 0x140C04),
        titleBarTop:          NSColor(hex: 0x3A2C14),
        titleBarBottom:       NSColor(hex: 0x180E04),
        titleBarStripe1:      NSColor(hex: 0xA06020),
        titleBarStripe2:      NSColor(hex: 0xC88030),
        titleBarText:         NSColor(hex: 0xE8C880),
        titleBarGradientMid:  NSColor(hex: 0x2A1E0C),
        titleBarButtonFace:   NSColor(hex: 0x301E0A),
        titleBarButtonText:   NSColor(hex: 0xC09050),
        lcdBackground:        NSColor(hex: 0x0C0800),
        greenBright:          NSColor(hex: 0xFFAA00),
        greenSecondary:       NSColor(hex: 0xC07800),
        greenDim:             NSColor(hex: 0x2A1800),
        greenDimText:         NSColor(hex: 0x3A2200),
        white:                NSColor(hex: 0xFFE080),
        selectionBlue:        NSColor(hex: 0x784800),
        playlistRowBackground: NSColor(hex: 0x0C0800),
        searchFieldBackground: NSColor(hex: 0x100A00),
        buttonFaceTop:        NSColor(hex: 0x3C2E18),
        buttonFaceBottom:     NSColor(hex: 0x2C2010),
        buttonBorderLight:    NSColor(hex: 0x504020),
        buttonBorderDark:     NSColor(hex: 0x180C04),
        buttonTextActive:     NSColor(hex: 0xFFAA00),
        buttonTextInactive:   NSColor(hex: 0x786040),
        buttonIconDefault:    NSColor(hex: 0x886040),
        seekFillTop:          NSColor(hex: 0xA07030),
        seekFillBottom:       NSColor(hex: 0x785020),
        seekThumbTop:         NSColor(hex: 0xE0A040),
        seekThumbMid:         NSColor(hex: 0xB07828),
        seekThumbBottom:      NSColor(hex: 0x886020),
        seekThumbBorderLight: NSColor(hex: 0xF0C060),
        seekThumbBorderDark:  NSColor(hex: 0x584010),
        volumeBgStart:        NSColor(hex: 0x0C0800),
        volumeBgEnd:          NSColor(hex: 0x804800),
        volumeFillStart:      NSColor(hex: 0x906030),
        volumeFillEnd:        NSColor(hex: 0xFFAA00),
        volumeThumbTop:       NSColor(hex: 0xE8A030),
        volumeThumbMid:       NSColor(hex: 0xB87020),
        volumeThumbBottom:    NSColor(hex: 0x905010),
        volumeThumbBorderLight: NSColor(hex: 0xF8C050),
        volumeThumbBorderDark:  NSColor(hex: 0x603808),
        eqSliderBgTop:        NSColor(hex: 0x1C1408),
        eqSliderBgBottom:     NSColor(hex: 0x241A0A),
        eqSliderTick:         NSColor(hex: 0x30200C),
        eqSliderCenter:       NSColor(hex: 0x3C2C10),
        eqThumbTop:           NSColor(hex: 0xD09030),
        eqThumbMid:           NSColor(hex: 0xA86820),
        eqThumbBottom:        NSColor(hex: 0x805010),
        eqThumbBorderLight:   NSColor(hex: 0xF0B040),
        eqThumbBorderDark:    NSColor(hex: 0x503008),
        eqFillStart:          NSColor(hex: 0x704010),
        eqFillEnd:            NSColor(hex: 0xA06020),
        eqBandLabelColor:     NSColor(hex: 0x987050),
        eqDbLabelColor:       NSColor(hex: 0x806040),
        spectrumBarBottom:    NSColor(hex: 0xC07800),
        spectrumBarTop:       NSColor(hex: 0xFFCC00),
        insetBorderDark:      NSColor(hex: 0x100A00),
        insetBorderLight:     NSColor(hex: 0x3C2C14),
        titleBarFont:         defaultFonts.titleBar,
        trackTitleFont:       defaultFonts.title,
        bitrateFont:          defaultFonts.bitrate,
        smallLabelFont:       defaultFonts.small,
        buttonFont:           defaultFonts.button,
        playlistFont:         defaultFonts.playlist,
        eqLabelFont:          defaultFonts.eqLabel,
        panelBackground:      NSColor(hex: 0x0C0800),
        errorColor:           NSColor(hex: 0xFF4444)
    )

    /// Night mode — deep purple frame, violet and cyan accents
    static let midnight = WinampThemeDefinition(
        name: "Midnight",
        frameBackground:      NSColor(hex: 0x1A1028),
        frameBorderLight:     NSColor(hex: 0x342048),
        frameBorderDark:      NSColor(hex: 0x0A0818),
        titleBarTop:          NSColor(hex: 0x241438),
        titleBarBottom:       NSColor(hex: 0x0E0820),
        titleBarStripe1:      NSColor(hex: 0x7830C0),
        titleBarStripe2:      NSColor(hex: 0xA050E8),
        titleBarText:         NSColor(hex: 0xD0B8F0),
        titleBarGradientMid:  NSColor(hex: 0x180E2C),
        titleBarButtonFace:   NSColor(hex: 0x200C30),
        titleBarButtonText:   NSColor(hex: 0xA080C8),
        lcdBackground:        NSColor(hex: 0x080410),
        greenBright:          NSColor(hex: 0xC060FF),
        greenSecondary:       NSColor(hex: 0x8030C0),
        greenDim:             NSColor(hex: 0x1A0830),
        greenDimText:         NSColor(hex: 0x200A38),
        white:                NSColor(hex: 0xE8D0FF),
        selectionBlue:        NSColor(hex: 0x5020A0),
        playlistRowBackground: NSColor(hex: 0x080410),
        searchFieldBackground: NSColor(hex: 0x0A0618),
        buttonFaceTop:        NSColor(hex: 0x281838),
        buttonFaceBottom:     NSColor(hex: 0x1A0C28),
        buttonBorderLight:    NSColor(hex: 0x402858),
        buttonBorderDark:     NSColor(hex: 0x0C0618),
        buttonTextActive:     NSColor(hex: 0xC060FF),
        buttonTextInactive:   NSColor(hex: 0x604880),
        buttonIconDefault:    NSColor(hex: 0x705890),
        seekFillTop:          NSColor(hex: 0x6030A0),
        seekFillBottom:       NSColor(hex: 0x481880),
        seekThumbTop:         NSColor(hex: 0xA060E0),
        seekThumbMid:         NSColor(hex: 0x7840C0),
        seekThumbBottom:      NSColor(hex: 0x5828A0),
        seekThumbBorderLight: NSColor(hex: 0xC880FF),
        seekThumbBorderDark:  NSColor(hex: 0x301060),
        volumeBgStart:        NSColor(hex: 0x080410),
        volumeBgEnd:          NSColor(hex: 0x401870),
        volumeFillStart:      NSColor(hex: 0x502080),
        volumeFillEnd:        NSColor(hex: 0xA040E0),
        volumeThumbTop:       NSColor(hex: 0xB858F0),
        volumeThumbMid:       NSColor(hex: 0x8838C8),
        volumeThumbBottom:    NSColor(hex: 0x6020A0),
        volumeThumbBorderLight: NSColor(hex: 0xD078FF),
        volumeThumbBorderDark:  NSColor(hex: 0x381060),
        eqSliderBgTop:        NSColor(hex: 0x100818),
        eqSliderBgBottom:     NSColor(hex: 0x180C22),
        eqSliderTick:         NSColor(hex: 0x20102C),
        eqSliderCenter:       NSColor(hex: 0x281838),
        eqThumbTop:           NSColor(hex: 0x9050D8),
        eqThumbMid:           NSColor(hex: 0x6830B0),
        eqThumbBottom:        NSColor(hex: 0x481890),
        eqThumbBorderLight:   NSColor(hex: 0xB070F0),
        eqThumbBorderDark:    NSColor(hex: 0x281060),
        eqFillStart:          NSColor(hex: 0x401070),
        eqFillEnd:            NSColor(hex: 0x6828A8),
        eqBandLabelColor:     NSColor(hex: 0x6848A0),
        eqDbLabelColor:       NSColor(hex: 0x583880),
        spectrumBarBottom:    NSColor(hex: 0x8030C0),
        spectrumBarTop:       NSColor(hex: 0xC060FF),
        insetBorderDark:      NSColor(hex: 0x060210),
        insetBorderLight:     NSColor(hex: 0x281838),
        titleBarFont:         defaultFonts.titleBar,
        trackTitleFont:       defaultFonts.title,
        bitrateFont:          defaultFonts.bitrate,
        smallLabelFont:       defaultFonts.small,
        buttonFont:           defaultFonts.button,
        playlistFont:         defaultFonts.playlist,
        eqLabelFont:          defaultFonts.eqLabel,
        panelBackground:      NSColor(hex: 0x080410),
        errorColor:           NSColor(hex: 0xFF4444)
    )

    /// Easy on the eyes — muted pastel greens, warm gray frame
    static let softGreen = WinampThemeDefinition(
        name: "Soft Green",
        frameBackground:      NSColor(hex: 0x2C3428),
        frameBorderLight:     NSColor(hex: 0x485040),
        frameBorderDark:      NSColor(hex: 0x161C14),
        titleBarTop:          NSColor(hex: 0x384030),
        titleBarBottom:       NSColor(hex: 0x1A2018),
        titleBarStripe1:      NSColor(hex: 0x4A7840),
        titleBarStripe2:      NSColor(hex: 0x68A058),
        titleBarText:         NSColor(hex: 0xC8DCC0),
        titleBarGradientMid:  NSColor(hex: 0x2A3828),
        titleBarButtonFace:   NSColor(hex: 0x303C28),
        titleBarButtonText:   NSColor(hex: 0x90B080),
        lcdBackground:        NSColor(hex: 0x0C1008),
        greenBright:          NSColor(hex: 0x80D060),
        greenSecondary:       NSColor(hex: 0x50A038),
        greenDim:             NSColor(hex: 0x182010),
        greenDimText:         NSColor(hex: 0x203018),
        white:                NSColor(hex: 0xD8F0C8),
        selectionBlue:        NSColor(hex: 0x306828),
        playlistRowBackground: NSColor(hex: 0x0C1008),
        searchFieldBackground: NSColor(hex: 0x0E1409),
        buttonFaceTop:        NSColor(hex: 0x384030),
        buttonFaceBottom:     NSColor(hex: 0x283020),
        buttonBorderLight:    NSColor(hex: 0x506048),
        buttonBorderDark:     NSColor(hex: 0x141C10),
        buttonTextActive:     NSColor(hex: 0x80D060),
        buttonTextInactive:   NSColor(hex: 0x607858),
        buttonIconDefault:    NSColor(hex: 0x708068),
        seekFillTop:          NSColor(hex: 0x507840),
        seekFillBottom:       NSColor(hex: 0x385828),
        seekThumbTop:         NSColor(hex: 0x78A868),
        seekThumbMid:         NSColor(hex: 0x587848),
        seekThumbBottom:      NSColor(hex: 0x3C5830),
        seekThumbBorderLight: NSColor(hex: 0x98C880),
        seekThumbBorderDark:  NSColor(hex: 0x284820),
        volumeBgStart:        NSColor(hex: 0x0C1008),
        volumeBgEnd:          NSColor(hex: 0x386030),
        volumeFillStart:      NSColor(hex: 0x487040),
        volumeFillEnd:        NSColor(hex: 0x80D060),
        volumeThumbTop:       NSColor(hex: 0x90C078),
        volumeThumbMid:       NSColor(hex: 0x689858),
        volumeThumbBottom:    NSColor(hex: 0x487040),
        volumeThumbBorderLight: NSColor(hex: 0xA8D890),
        volumeThumbBorderDark:  NSColor(hex: 0x305828),
        eqSliderBgTop:        NSColor(hex: 0x181E14),
        eqSliderBgBottom:     NSColor(hex: 0x1E2618),
        eqSliderTick:         NSColor(hex: 0x263020),
        eqSliderCenter:       NSColor(hex: 0x303C28),
        eqThumbTop:           NSColor(hex: 0x70A860),
        eqThumbMid:           NSColor(hex: 0x508040),
        eqThumbBottom:        NSColor(hex: 0x386030),
        eqThumbBorderLight:   NSColor(hex: 0x90C878),
        eqThumbBorderDark:    NSColor(hex: 0x284820),
        eqFillStart:          NSColor(hex: 0x305828),
        eqFillEnd:            NSColor(hex: 0x508040),
        eqBandLabelColor:     NSColor(hex: 0x608858),
        eqDbLabelColor:       NSColor(hex: 0x507848),
        spectrumBarBottom:    NSColor(hex: 0x50A038),
        spectrumBarTop:       NSColor(hex: 0xA8E080),
        insetBorderDark:      NSColor(hex: 0x0A0E08),
        insetBorderLight:     NSColor(hex: 0x384030),
        titleBarFont:         defaultFonts.titleBar,
        trackTitleFont:       defaultFonts.title,
        bitrateFont:          defaultFonts.bitrate,
        smallLabelFont:       defaultFonts.small,
        buttonFont:           defaultFonts.button,
        playlistFont:         defaultFonts.playlist,
        eqLabelFont:          defaultFonts.eqLabel,
        panelBackground:      NSColor(hex: 0x0C1008),
        errorColor:           NSColor(hex: 0xFF4444)
    )
}

// MARK: - WinampTheme (computed proxies → current theme)

enum WinampTheme {
    // Frame
    static var frameBackground:  NSColor { ThemeManager.shared.current.frameBackground }
    static var frameBorderLight: NSColor { ThemeManager.shared.current.frameBorderLight }
    static var frameBorderDark:  NSColor { ThemeManager.shared.current.frameBorderDark }

    // Title bar
    static var titleBarTop:         NSColor { ThemeManager.shared.current.titleBarTop }
    static var titleBarBottom:      NSColor { ThemeManager.shared.current.titleBarBottom }
    static var titleBarStripe1:     NSColor { ThemeManager.shared.current.titleBarStripe1 }
    static var titleBarStripe2:     NSColor { ThemeManager.shared.current.titleBarStripe2 }
    static var titleBarText:        NSColor { ThemeManager.shared.current.titleBarText }
    static var titleBarGradientMid: NSColor { ThemeManager.shared.current.titleBarGradientMid }
    static var titleBarButtonFace:  NSColor { ThemeManager.shared.current.titleBarButtonFace }
    static var titleBarButtonText:  NSColor { ThemeManager.shared.current.titleBarButtonText }

    // LCD / Display
    static var lcdBackground:  NSColor { ThemeManager.shared.current.lcdBackground }
    static var greenBright:    NSColor { ThemeManager.shared.current.greenBright }
    static var greenSecondary: NSColor { ThemeManager.shared.current.greenSecondary }
    static var greenDim:       NSColor { ThemeManager.shared.current.greenDim }
    static var greenDimText:   NSColor { ThemeManager.shared.current.greenDimText }

    // Playlist
    static var white:                 NSColor { ThemeManager.shared.current.white }
    static var selectionBlue:         NSColor { ThemeManager.shared.current.selectionBlue }
    static var playlistRowBackground: NSColor { ThemeManager.shared.current.playlistRowBackground }
    static var searchFieldBackground: NSColor { ThemeManager.shared.current.searchFieldBackground }

    // Buttons
    static var buttonFaceTop:      NSColor { ThemeManager.shared.current.buttonFaceTop }
    static var buttonFaceBottom:   NSColor { ThemeManager.shared.current.buttonFaceBottom }
    static var buttonBorderLight:  NSColor { ThemeManager.shared.current.buttonBorderLight }
    static var buttonBorderDark:   NSColor { ThemeManager.shared.current.buttonBorderDark }
    static var buttonTextActive:   NSColor { ThemeManager.shared.current.buttonTextActive }
    static var buttonTextInactive: NSColor { ThemeManager.shared.current.buttonTextInactive }
    static var buttonIconDefault:  NSColor { ThemeManager.shared.current.buttonIconDefault }

    // Seek / Balance sliders
    static var seekFillTop:          NSColor { ThemeManager.shared.current.seekFillTop }
    static var seekFillBottom:       NSColor { ThemeManager.shared.current.seekFillBottom }
    static var seekThumbTop:         NSColor { ThemeManager.shared.current.seekThumbTop }
    static var seekThumbMid:         NSColor { ThemeManager.shared.current.seekThumbMid }
    static var seekThumbBottom:      NSColor { ThemeManager.shared.current.seekThumbBottom }
    static var seekThumbBorderLight: NSColor { ThemeManager.shared.current.seekThumbBorderLight }
    static var seekThumbBorderDark:  NSColor { ThemeManager.shared.current.seekThumbBorderDark }

    // Volume slider
    static var volumeBgStart:          NSColor { ThemeManager.shared.current.volumeBgStart }
    static var volumeBgEnd:            NSColor { ThemeManager.shared.current.volumeBgEnd }
    static var volumeFillStart:        NSColor { ThemeManager.shared.current.volumeFillStart }
    static var volumeFillEnd:          NSColor { ThemeManager.shared.current.volumeFillEnd }
    static var volumeThumbTop:         NSColor { ThemeManager.shared.current.volumeThumbTop }
    static var volumeThumbMid:         NSColor { ThemeManager.shared.current.volumeThumbMid }
    static var volumeThumbBottom:      NSColor { ThemeManager.shared.current.volumeThumbBottom }
    static var volumeThumbBorderLight: NSColor { ThemeManager.shared.current.volumeThumbBorderLight }
    static var volumeThumbBorderDark:  NSColor { ThemeManager.shared.current.volumeThumbBorderDark }

    // EQ sliders
    static var eqSliderBgTop:      NSColor { ThemeManager.shared.current.eqSliderBgTop }
    static var eqSliderBgBottom:   NSColor { ThemeManager.shared.current.eqSliderBgBottom }
    static var eqSliderTick:       NSColor { ThemeManager.shared.current.eqSliderTick }
    static var eqSliderCenter:     NSColor { ThemeManager.shared.current.eqSliderCenter }
    static var eqThumbTop:         NSColor { ThemeManager.shared.current.eqThumbTop }
    static var eqThumbMid:         NSColor { ThemeManager.shared.current.eqThumbMid }
    static var eqThumbBottom:      NSColor { ThemeManager.shared.current.eqThumbBottom }
    static var eqThumbBorderLight: NSColor { ThemeManager.shared.current.eqThumbBorderLight }
    static var eqThumbBorderDark:  NSColor { ThemeManager.shared.current.eqThumbBorderDark }
    static var eqFillStart:        NSColor { ThemeManager.shared.current.eqFillStart }
    static var eqFillEnd:          NSColor { ThemeManager.shared.current.eqFillEnd }
    static var eqBandLabelColor:   NSColor { ThemeManager.shared.current.eqBandLabelColor }
    static var eqDbLabelColor:     NSColor { ThemeManager.shared.current.eqDbLabelColor }

    // Spectrum
    static var spectrumBarBottom: NSColor { ThemeManager.shared.current.spectrumBarBottom }
    static var spectrumBarTop:    NSColor { ThemeManager.shared.current.spectrumBarTop }

    // Inset borders
    static var insetBorderDark:  NSColor { ThemeManager.shared.current.insetBorderDark }
    static var insetBorderLight: NSColor { ThemeManager.shared.current.insetBorderLight }

    // Panel backgrounds
    static var panelBackground: NSColor { ThemeManager.shared.current.panelBackground }

    // Error state
    static var errorColor: NSColor { ThemeManager.shared.current.errorColor }

    // Fonts
    static var titleBarFont:   NSFont { ThemeManager.shared.current.titleBarFont }
    static var trackTitleFont: NSFont { ThemeManager.shared.current.trackTitleFont }
    static var bitrateFont:    NSFont { ThemeManager.shared.current.bitrateFont }
    static var smallLabelFont: NSFont { ThemeManager.shared.current.smallLabelFont }
    static var buttonFont:     NSFont { ThemeManager.shared.current.buttonFont }
    static var playlistFont:   NSFont { ThemeManager.shared.current.playlistFont }
    static var eqLabelFont:    NSFont { ThemeManager.shared.current.eqLabelFont }

    // MARK: - Scale & Dimensions (not theme-dependent)
    static let scale: CGFloat = 1.3
    static let windowWidth: CGFloat = 275
    static let mainPlayerHeight: CGFloat = 126
    static let equalizerHeight: CGFloat = 112
    static let playlistMinHeight: CGFloat = 232
    static let titleBarHeight: CGFloat = 16
    static let transportButtonSize = NSSize(width: 22, height: 18)
}
