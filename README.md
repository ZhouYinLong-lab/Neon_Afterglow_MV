# Neon Afterglow MV

南京大学智能科学与技术学院 2026—2027 秋季学期

## 智能语音技术 · 第二次作业

本仓库用于存放第二次作业的 MV 视频素材与制作文件。作业内容是为视频配上小组生成的音乐，使最终作品呈现音乐视频（Music Video，MV）的视听效果。

当前仓库已经包含一首原创生成的 3 分钟 Synthwave 配乐和一版完整 MV 初稿。

## 作品方向

**Neon Afterglow**（霓虹余晖）

整体采用“夜晚城市独行”的视觉主题：人物在城市夜色中出发，穿过霓虹、雨夜和列车灯光，最后停下来眺望城市。画面剪辑建议跟随音乐段落推进：前奏使用人物和环境镜头，高潮使用车流、霓虹和列车镜头，尾奏回到安静的城市眺望画面。

## 素材目录

| 文件 | 用途 | 原始素材 |
| --- | --- | --- |
| `assets/01-city-walk.mp4` | 开头：人物在雾中街道行走 | [Pexels 原始页面](https://www.pexels.com/video/people-walking-in-city-at-night-11839819/) |
| `assets/02-rainy-neon-reflections.mp4` | 高潮：雨夜街道与霓虹倒影 | [Pexels 原始页面](https://www.pexels.com/video/vibrant-urban-night-scene-with-reflections-30284377/) |
| `assets/03-elevated-train.mp4` | 过渡/高潮：高架列车经过城市 | [Pexels 原始页面](https://www.pexels.com/video/nighttime-cityscape-with-elevated-train-passing-36244116/) |
| `assets/04-city-overlook.mp4` | 结尾：人物在桥上眺望城市 | [Pexels 原始页面](https://www.pexels.com/video/silhouettes-overlooking-city-at-night-36244092/) |

## 成片文件

- `audio/neon-afterglow-synthwave.mp3`：原创 Synthwave 配乐，180 秒
- `output/neon-afterglow-mv.mp4`：完整 MV 初稿，180 秒，1280×720，30 FPS
- `storyboard.md`：分镜和时间线
- `tools/generate_synthwave.js`：本地生成配乐的可复现脚本
- `tools/render_mv.ps1`：视频素材整理、片头片尾和最终渲染脚本

仓库内的视频是为便于剪辑而制作的 720p 短片段，已移除原始音轨；正式成片应使用小组生成的音乐作为主音轨。

## 建议剪辑顺序

```text
01-city-walk → 02-rainy-neon-reflections → 03-elevated-train → 04-city-overlook
```

建议将音乐的重拍、段落变化或高潮分别对应到雨夜霓虹和高架列车画面，结尾保留城市眺望镜头，形成“出发—穿行—情绪爆发—回望”的叙事闭环。

## 本地复现

在 Windows 环境中，确保已安装 Node.js 和 FFmpeg，然后运行：

```powershell
node tools/generate_synthwave.js build/neon-afterglow-synthwave.wav
ffmpeg -i build/neon-afterglow-synthwave.wav -af loudnorm=I=-14:TP=-1.0:LRA=7 -c:a libmp3lame -b:a 192k -ar 44100 -ac 2 audio/neon-afterglow-synthwave.mp3
powershell -ExecutionPolicy Bypass -File tools/render_mv.ps1
```

最终视频会生成在 `output/neon-afterglow-mv.mp4`。

## 素材说明

视频素材来自 Pexels，原始页面标注为 Free。使用时保留原始链接和作者信息，课程提交时可在片尾或项目说明中注明素材来源。素材来源与具体授权条款以原始页面及 [Pexels License](https://www.pexels.com/license/) 为准。

