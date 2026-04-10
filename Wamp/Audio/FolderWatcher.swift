import Foundation
import CoreServices

/// Watches a folder for new audio files using FSEvents and reports them via callback.
class FolderWatcher {
    private var eventStream: FSEventStreamRef?
    private(set) var watchedURL: URL?
    var onNewFiles: (([URL]) -> Void)?

    // Track files seen on start so we only report genuinely new additions
    private var knownFiles: Set<URL> = []

    func start(watching url: URL) {
        stop()
        watchedURL = url
        knownFiles = Set(currentAudioFiles(in: url))

        let paths = [url.path] as CFArray
        var context = FSEventStreamContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        eventStream = FSEventStreamCreate(
            nil,
            { _, info, _, _, _, _ in
                guard let info else { return }
                let watcher = Unmanaged<FolderWatcher>.fromOpaque(info).takeUnretainedValue()
                watcher.handleFSEvent()
            },
            &context,
            paths,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            1.0, // 1-second latency
            FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes)
        )
        guard let stream = eventStream else { return }
        FSEventStreamSetDispatchQueue(stream, DispatchQueue.main)
        FSEventStreamStart(stream)
    }

    func stop() {
        guard let stream = eventStream else { return }
        FSEventStreamStop(stream)
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        eventStream = nil
        watchedURL = nil
        knownFiles = []
    }

    private func handleFSEvent() {
        guard let url = watchedURL else { return }
        let current = Set(currentAudioFiles(in: url))
        let new = current.subtracting(knownFiles)
        knownFiles = current
        guard !new.isEmpty else { return }
        DispatchQueue.main.async { [weak self] in
            self?.onNewFiles?(Array(new).sorted { $0.lastPathComponent < $1.lastPathComponent })
        }
    }

    private func currentAudioFiles(in folder: URL) -> [URL] {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: folder,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }
        return (enumerator.allObjects as? [URL] ?? []).filter {
            Track.supportedExtensions.contains($0.pathExtension.lowercased())
        }
    }
}
