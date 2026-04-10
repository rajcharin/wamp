import AppKit
import MediaPlayer

class HotKeyManager {
    private weak var audioEngine: AudioEngine?
    private weak var playlistManager: PlaylistManager?
    private var cachedArtworkURL: URL?
    private var cachedArtwork: MPMediaItemArtwork?

    init(audioEngine: AudioEngine, playlistManager: PlaylistManager) {
        self.audioEngine = audioEngine
        self.playlistManager = playlistManager
        setupRemoteCommands()
        setupNowPlayingUpdates()
    }

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ in
            self?.audioEngine?.play()
            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ in
            self?.audioEngine?.pause()
            return .success
        }

        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.audioEngine?.togglePlayPause()
            return .success
        }

        center.nextTrackCommand.addTarget { [weak self] _ in
            self?.playlistManager?.playNext()
            return .success
        }

        center.previousTrackCommand.addTarget { [weak self] _ in
            self?.playlistManager?.playPrevious()
            return .success
        }

        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let posEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.audioEngine?.seek(to: posEvent.positionTime)
            return .success
        }
    }

    private func setupNowPlayingUpdates() {
        // Update periodically
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNowPlaying()
        }
    }

    func updateNowPlaying() {
        guard let engine = audioEngine,
              let track = playlistManager?.currentTrack else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }

        var info: [String: Any] = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.artist,
            MPMediaItemPropertyPlaybackDuration: track.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: engine.currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: engine.isPlaying ? 1.0 : 0.0
        ]

        if !track.album.isEmpty { info[MPMediaItemPropertyAlbumTitle] = track.album }
        if !track.genre.isEmpty { info[MPMediaItemPropertyGenre] = track.genre }
        if track.trackNumber > 0 { info[MPMediaItemPropertyAlbumTrackNumber] = track.trackNumber }

        // Use cached artwork if available; otherwise load async
        if let artwork = cachedArtwork, cachedArtworkURL == track.url {
            info[MPMediaItemPropertyArtwork] = artwork
        } else if cachedArtworkURL != track.url {
            cachedArtwork = nil
            cachedArtworkURL = track.url
            Task { [weak self] in
                guard let self else { return }
                if let image = await Track.loadArtwork(from: track.url) {
                    let mpArtwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                    await MainActor.run {
                        self.cachedArtwork = mpArtwork
                        self.updateNowPlaying()
                    }
                }
            }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
