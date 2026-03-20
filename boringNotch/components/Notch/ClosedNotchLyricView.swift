//
//  ClosedNotchLyricView.swift
//  boringNotch
//
//

import Defaults
import SwiftUI

struct ClosedNotchLyricView: View {
    @ObservedObject var musicManager = MusicManager.shared

    private var lyricColor: Color {
        Color(nsColor: musicManager.avgColor).ensureMinimumBrightness(factor: 0.85)
    }

    var body: some View {
        GeometryReader { geo in
            TimelineView(.periodic(from: .now, by: 0.1)) { timeline in
                let elapsed = musicManager.estimatedPlaybackPosition(at: timeline.date)
                let hasSynced = !musicManager.syncedLyrics.isEmpty
                let currentLine = hasSynced ? musicManager.lyricLine(at: elapsed) : plainLyricLine(at: timeline.date)

                Text(currentLine)
                    .font(.subheadline)
                    .foregroundColor(lyricColor)
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 0)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .id(currentLine)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: hasSynced ? 0.3 : 0.5), value: currentLine)
            }
        }
        .padding(.horizontal, 12)
    }

    /// For plain lyrics: split into lines and cycle every ~6 seconds
    private func plainLyricLine(at date: Date) -> String {
        if musicManager.isFetchingLyrics { return "" }
        let plain = musicManager.currentLyrics.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !plain.isEmpty else { return "" }
        let lines = plain.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        guard !lines.isEmpty else { return "" }
        let secondsSinceRef = date.timeIntervalSinceReferenceDate
        let index = Int(secondsSinceRef / 6.0) % lines.count
        return lines[index]
    }
}
