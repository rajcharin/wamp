import Foundation
import AVFoundation
import AppKit

struct Track: Identifiable, Codable, Equatable {
    nonisolated static let supportedExtensions: Set<String> = [
        "mp3", "aac", "m4a", "flac", "wav", "aiff", "aif"
    ]

    let id: UUID
    let url: URL
    var title: String
    var artist: String
    var album: String
    var duration: TimeInterval
    var genre: String
    var bitrate: Int
    var sampleRate: Int
    var channels: Int
    var trackNumber: Int
    var year: Int

    // Explicit CodingKeys so artworkImage (NSImage) stays out of JSON
    enum CodingKeys: String, CodingKey {
        case id, url, title, artist, album, duration, genre, bitrate, sampleRate, channels, trackNumber, year
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        url = try c.decode(URL.self, forKey: .url)
        title = try c.decode(String.self, forKey: .title)
        artist = try c.decode(String.self, forKey: .artist)
        album = try c.decode(String.self, forKey: .album)
        duration = try c.decode(TimeInterval.self, forKey: .duration)
        genre = try c.decode(String.self, forKey: .genre)
        bitrate = try c.decode(Int.self, forKey: .bitrate)
        sampleRate = try c.decode(Int.self, forKey: .sampleRate)
        channels = try c.decode(Int.self, forKey: .channels)
        trackNumber = try c.decodeIfPresent(Int.self, forKey: .trackNumber) ?? 0
        year = try c.decodeIfPresent(Int.self, forKey: .year) ?? 0
    }

    init(
        url: URL,
        title: String,
        artist: String,
        album: String,
        duration: TimeInterval,
        genre: String = "",
        bitrate: Int = 0,
        sampleRate: Int = 0,
        channels: Int = 2,
        trackNumber: Int = 0,
        year: Int = 0
    ) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.genre = genre
        self.bitrate = bitrate
        self.sampleRate = sampleRate
        self.channels = channels
        self.trackNumber = trackNumber
        self.year = year
    }

    var displayTitle: String {
        if artist.isEmpty || artist == "Unknown Artist" {
            return title
        }
        return "\(artist) - \(title)"
    }

    var formattedDuration: String {
        let totalSeconds = Int(duration)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }

    var isStereo: Bool { channels >= 2 }

    @MainActor
    static func loadArtwork(from url: URL) async -> NSImage? {
        let asset = AVURLAsset(url: url)
        guard let metadata = try? await asset.load(.commonMetadata) else { return nil }
        for item in metadata {
            guard item.commonKey == .commonKeyArtwork else { continue }
            if let data = try? await item.load(.dataValue) {
                return NSImage(data: data)
            }
        }
        return nil
    }

    private static func looksLikeMojibake(_ text: String) -> Bool {
        let nonASCII = text.unicodeScalars.filter { $0.value > 0x7F }
        guard !nonASCII.isEmpty else { return false }
        return nonASCII.allSatisfy { $0.value <= 0x00FF }
    }

    private static let candidateEncodings: [String.Encoding] = {
        func enc(_ windowsCodepage: UInt32) -> String.Encoding? {
            let cfEnc = CFStringConvertWindowsCodepageToEncoding(windowsCodepage)
            guard cfEnc != kCFStringEncodingInvalidId else { return nil }
            let nsEnc = CFStringConvertEncodingToNSStringEncoding(cfEnc)
            guard nsEnc != UInt(kCFStringEncodingInvalidId) else { return nil }
            return String.Encoding(rawValue: nsEnc)
        }
        return [
            .utf8,
            enc(874),   // Thai (Windows-874 / TIS-620)
            .shiftJIS,  // Japanese (CP932)
            enc(936),   // Chinese Simplified (GBK)
            enc(950),   // Chinese Traditional (Big5)
        ].compactMap { $0 }
    }()

    private static func fixEncoding(_ text: String) -> String {
        guard looksLikeMojibake(text) else { return text }
        guard let rawBytes = text.data(using: .isoLatin1) else { return text }
        for encoding in candidateEncodings {
            if let decoded = String(data: rawBytes, encoding: encoding),
               decoded.unicodeScalars.contains(where: { $0.value > 0x00FF }) {
                return decoded
            }
        }
        return text
    }

    @MainActor
    static func fromURL(_ url: URL) async -> Track {
        let asset = AVURLAsset(url: url)
        var title = url.deletingPathExtension().lastPathComponent
        var artist = "Unknown Artist"
        var album = ""
        var genre = ""
        var duration: TimeInterval = 0
        var bitrate = 0
        var sampleRate = 0
        var channels = 2
        var trackNumber = 0
        var year = 0

        do {
            let metadata = try await asset.load(.commonMetadata)
            let dur = try await asset.load(.duration)
            duration = dur.seconds.isFinite ? dur.seconds : 0

            for item in metadata {
                guard let key = item.commonKey else { continue }
                switch key {
                case .commonKeyTitle:
                    if let val = try await item.load(.stringValue), !val.isEmpty {
                        title = fixEncoding(val)
                    }
                case .commonKeyArtist:
                    if let val = try await item.load(.stringValue), !val.isEmpty {
                        artist = fixEncoding(val)
                    }
                case .commonKeyAlbumName:
                    if let val = try await item.load(.stringValue), !val.isEmpty {
                        album = fixEncoding(val)
                    }
                case .commonKeyType:
                    if let val = try await item.load(.stringValue), !val.isEmpty {
                        genre = fixEncoding(val)
                    }
                case .commonKeyCreationDate:
                    if let val = try await item.load(.stringValue), !val.isEmpty {
                        year = Int(String(fixEncoding(val).prefix(4))) ?? 0
                    }
                default:
                    break
                }
            }

            // Extract track number from ID3 TRCK (not in common keys)
            let allMeta = (try? await asset.load(.metadata)) ?? []
            for item in allMeta where trackNumber == 0 {
                guard item.keySpace == .id3, (item.key as? String) == "TRCK" else { continue }
                if let val = try? await item.load(.stringValue), !val.isEmpty {
                    trackNumber = Int(val.components(separatedBy: "/").first?.trimmingCharacters(in: .whitespaces) ?? "") ?? 0
                }
            }

            if let audioTrack = try await asset.loadTracks(withMediaType: .audio).first {
                let descriptions = try await audioTrack.load(.formatDescriptions)
                if let desc = descriptions.first {
                    let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(desc)?.pointee
                    if let asbd = asbd {
                        sampleRate = Int(asbd.mSampleRate)
                        channels = Int(asbd.mChannelsPerFrame)
                    }
                }
                let estimatedRate = try await audioTrack.load(.estimatedDataRate)
                bitrate = Int(estimatedRate / 1000)
            }
        } catch {
            // Fallback: use filename as title
        }

        return Track(
            url: url,
            title: title,
            artist: artist,
            album: album,
            duration: duration,
            genre: genre,
            bitrate: bitrate,
            sampleRate: sampleRate,
            channels: channels,
            trackNumber: trackNumber,
            year: year
        )
    }
}
