<h1 align="center">
  Lyrics Notch
</h1>

<p align="center">
  <b>在 MacBook 刘海屏上实时显示歌词</b><br>
  Real-time lyrics on your MacBook's notch
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue?style=flat-square" alt="macOS 14+" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" alt="Swift" />
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License" />
</p>

---

## Screenshots

<!-- 
  📸 在下方添加产品截图
  建议尺寸：宽度 800px+，PNG 或 GIF 格式
  可以展示：收起状态歌词、展开状态歌词、不同播放器效果等
-->

<p align="center">
  <!-- 截图 1：收起状态 — 刘海屏下方显示歌词 -->
  <!-- <img src="screenshots/closed-notch-lyrics.png" width="600" alt="收起状态歌词" /> -->
  <i>收起状态 — 刘海屏下方实时歌词</i>
</p>

<p align="center">
  <!-- 截图 2：展开状态 — 完整歌词显示 -->
  <!-- <img src="screenshots/expanded-notch-lyrics.png" width="600" alt="展开状态歌词" /> -->
  <i>展开状态 — 完整歌词显示</i>
</p>

<p align="center">
  <!-- 截图 3：歌词颜色跟随专辑封面 -->
  <!-- <img src="screenshots/lyrics-color-sync.png" width="600" alt="歌词颜色同步" /> -->
  <i>歌词颜色自动跟随专辑封面主色调</i>
</p>

<p align="center">
  <!-- 截图 4：GIF 动图 — 实际使用效果 -->
  <!-- <img src="screenshots/demo.gif" width="600" alt="使用演示" /> -->
  <i>实际使用演示</i>
</p>

---

## 功能特性

- **收起状态歌词** — 刘海屏药丸下方实时显示当前歌词，不遮挡任何 UI
- **同步歌词** — LRC 时间轴歌词精确跟随播放进度，拖动进度条歌词即时跟上
- **纯文本歌词** — 无时间轴歌词时自动逐行轮播（每 6 秒切换）
- **多源歌词获取** — 6 个歌词源自动 fallback，覆盖中文、英文、韩文等多语种歌曲
- **智能颜色** — 歌词颜色自动跟随专辑封面主色调，保证可读性
- **多播放器支持** — Apple Music、Spotify、YouTube Music 等主流播放器

### 歌词源 Fallback 链

| 优先级 | 源 | 类型 | 说明 |
|:---:|:---|:---|:---|
| 1 | LRCLIB | synced + plain | 免费开放 API |
| 2 | LRCLIB (cleaned) | synced + plain | 清洗标题后重试 |
| 3 | 网易云音乐 | synced | 中文歌覆盖最强 |
| 4 | Musixmatch (via LewdHuTao) | plain | 1400 万+ 歌词库 |
| 5 | YouTube Music (via LewdHuTao) | plain | 补充覆盖 |
| 6 | lyrics.ovh | plain | 兜底 |

## Features

- **Closed-notch lyrics** — Real-time lyrics displayed below the notch pill without blocking any UI
- **Synced lyrics** — LRC-based lyrics follow playback position precisely, even after seeking
- **Plain text fallback** — Auto-cycles through lines (every 6s) when no timed lyrics available
- **Multi-source lyrics** — 6 lyrics sources with automatic fallback for broad coverage
- **Dynamic color** — Lyrics color adapts to album artwork dominant color
- **Multi-player support** — Apple Music, Spotify, YouTube Music, and more

---

## 安装 / Installation

**系统要求 / System Requirements:**
- macOS **14 Sonoma** 或更高版本
- Apple Silicon 或 Intel Mac

### 方式一：下载 DMG

从 [Releases](https://github.com/Dreammmmix/lycrics_notch/releases) 页面下载最新的 `.dmg` 文件，打开后将 app 拖入 `/Applications` 文件夹。

首次运行需要执行：

```bash
xattr -dr com.apple.quarantine /Applications/boringNotch.app
```

### 方式二：从源码构建

```bash
git clone https://github.com/Dreammmmix/lycrics_notch.git
cd lycrics_notch
open boringNotch.xcodeproj
```

在 Xcode 中按 `Cmd + R` 构建运行。

---

## 技术细节

### 修改的文件

| 文件 | 说明 |
|:---|:---|
| `boringNotch/components/Notch/ClosedNotchLyricView.swift` | **新增** — 收起状态歌词视图 |
| `boringNotch/managers/MusicManager.swift` | 多源歌词 fallback + 并发控制 + LRC 解析 |
| `boringNotch/ContentView.swift` | 插入 ClosedNotchLyricView |
| `boringNotch/models/Constants.swift` | enableLyrics 默认开启 |

### 架构

```
播放状态变化
    ↓
fetchLyricsIfAvailable()
    ↓ (cancel previous task)
fetchLyricsFromWeb()
    ↓ (try sources 1→6)
    ├── LRCLIB (original title)
    ├── LRCLIB (cleaned title)
    ├── 网易云音乐
    ├── LewdHuTao Musixmatch
    ├── LewdHuTao YouTube Music
    └── lyrics.ovh
    ↓
syncedLyrics / currentLyrics
    ↓
ClosedNotchLyricView (TimelineView 0.1s tick)
    ↓
estimatedPlaybackPosition → lyricLine(at:) → Text
```

---

## 致谢 / Acknowledgments

本项目基于 [boring.notch](https://github.com/TheBoredTeam/boring.notch) 进行二次开发，感谢原作者团队的工作。

- [boring.notch](https://github.com/TheBoredTeam/boring.notch) — 原始项目
- [LRCLIB](https://lrclib.net) — 开放歌词 API
- [LewdHuTao Lyrics API](https://github.com/LewdHuTao/lyrics-api) — Musixmatch / YouTube Music 歌词
- [lyrics.ovh](https://lyrics.ovh) — 歌词兜底源

---

## License

MIT License — 详见 [LICENSE](LICENSE)
