import Foundation

class ThemeManager {
    static let shared = ThemeManager()
    static let didChangeNotification = Notification.Name("WampThemeDidChange")

    private(set) var current: WinampThemeDefinition = .classic

    let allThemes: [WinampThemeDefinition] = [
        .classic, .darkSteel, .amber, .midnight, .softGreen
    ]

    private init() {}

    func apply(_ theme: WinampThemeDefinition) {
        current = theme
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    func apply(named name: String) {
        if let theme = allThemes.first(where: { $0.name == name }) {
            apply(theme)
        }
    }
}
