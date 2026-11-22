# Neon Afterglow MV

南京大学智能科学与技术学院 2026—2027 秋季学期

## 智能语音技术 · 第二次作业

本仓库用于存放第二次作业的 MV 视频素材与制作文件。作业内容是为视频配上小组生成的音乐，使最终作品呈现音乐视频（Music Video，MV）的视听效果。

当前仓库已经包含一首原创生成的 3 分钟 Synthwave 配乐，以及纯音乐版和带人声版两种 MV 初稿。

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

为减少长片中的重复镜头，又补充了以下横屏素材。新版成片会将这些素材按时间线各使用一次：

| 文件 | 画面内容 | 原始素材 |
| --- | --- | --- |
| `assets/06-rainy-timelapse.mp4` | 雨夜街道延时 | [Pexels](https://www.pexels.com/video/time-lapse-video-of-a-street-on-a-rainy-night-5108846/) |
| `assets/07-traffic-bokeh.mp4` | 夜间车流光斑 | [Pexels](https://www.pexels.com/video/blurred-traffic-lights-on-a-city-highway-30233378/) |
| `assets/08-traffic-light-trails.mp4` | 车流光轨 | [Pexels](https://www.pexels.com/video/dynamic-nighttime-city-traffic-light-trails-28709567/) |
| `assets/10-bridge-cityscape.mp4` | 桥上城市景观 | [Pexels](https://www.pexels.com/video/cityscape-through-bridge-at-night-36244108/) |
| `assets/11-street-lamp.mp4` | 街灯与建筑 | [Pexels](https://www.pexels.com/video/a-city-street-at-night-with-a-street-light-16657010/) |
| `assets/12-skyline.mp4` | 城市天际线 | [Pexels](https://www.pexels.com/video/a-city-skyline-at-night-with-lights-on-18569318/) |
| `assets/13-city-timelapse.mp4` | 城市桥梁延时 | [Pexels](https://www.pexels.com/video/timelapse-of-a-nighttime-city-scene-33078752/) |
| `assets/14-colorful-street.mp4` | 彩色街区与商铺 | [Pexels](https://www.pexels.com/video/street-in-city-at-night-9956020/) |
| `assets/15-long-city-train.mp4` | 城市夜景长镜头 | [Pexels](https://www.pexels.com/video/night-life-in-a-city-5683157/) |
| `assets/16-city-dusk-walk.mp4` | 黄昏城市人群 | [Pexels](https://www.pexels.com/video/people-walk-down-a-street-in-a-city-at-dusk-20601998/) |
| `assets/17-city-train-later.mp4` | 城市夜景后段 | [Pexels](https://www.pexels.com/video/night-life-in-a-city-5683157/) |
| `assets/18-city-train-final.mp4` | 城市夜景尾段 | [Pexels](https://www.pexels.com/video/night-life-in-a-city-5683157/) |

## 成片文件

- `audio/neon-afterglow-synthwave.mp3`：原创 Synthwave 配乐，180 秒
- `audio/neon-afterglow-vocal.mp3`：加入英文人声 Hook 的版本，180 秒
- `output/neon-afterglow-mv.mp4`：完整 MV 初稿，180 秒，1280×720，30 FPS
- `output/neon-afterglow-vocal-mv.mp4`：带人声的完整 MV 版本，180 秒
- `storyboard.md`：分镜和时间线
- `tools/generate_synthwave.js`：本地生成配乐的可复现脚本
- `tools/generate_vocal.ps1`：生成英文人声短句
- `tools/build_vocal_audio.ps1`：将人声与 Synthwave 配乐混音
- `tools/render_mv.ps1`：视频素材整理、片头片尾和最终渲染脚本

仓库内的视频是为便于剪辑而制作的 720p 短片段，已移除原始音轨；正式成片应使用小组生成的音乐作为主音轨。

## 建议剪辑顺序

```text
01-city-walk → 02-rainy-neon-reflections → 03-elevated-train → 04-city-overlook
```

建议将音乐的重拍、段落变化或高潮分别对应到雨夜霓虹、车流光轨和高架列车画面，结尾保留城市夜景，形成“黄昏出发—进入城市—情绪爆发—夜色收束”的叙事闭环。新版时间线尽量不重复同一素材，只在片尾使用约 2 秒定格补齐时长。

## 人声版本

人声版本使用英文短句作为 Synthwave vocal hook，内容为：

```text
Neon afterglow.
Running through the night.
We are alive in the city lights.
Do not look back.
```

人声在前奏、第一次高潮、间奏和最终高潮处依次出现，并加入延迟、混响和压缩，使其更接近 MV 中的氛围人声采样。

## 本地复现

在 Windows 环境中，确保已安装 Node.js 和 FFmpeg，然后运行：

```powershell
node tools/generate_synthwave.js build/neon-afterglow-synthwave.wav
ffmpeg -i build/neon-afterglow-synthwave.wav -af loudnorm=I=-14:TP=-1.0:LRA=7 -c:a libmp3lame -b:a 192k -ar 44100 -ac 2 audio/neon-afterglow-synthwave.mp3
powershell -ExecutionPolicy Bypass -File tools/render_mv.ps1
```

最终视频会生成在 `output/neon-afterglow-mv.mp4`。

生成带人声版本：

```powershell
powershell -ExecutionPolicy Bypass -File tools/build_vocal_audio.ps1
powershell -ExecutionPolicy Bypass -File tools/render_mv.ps1 -AudioFile audio/neon-afterglow-vocal.mp3 -OutputFile output/neon-afterglow-vocal-mv.mp4
```

## 素材说明

视频素材来自 Pexels，原始页面标注为 Free。使用时保留原始链接和作者信息，课程提交时可在片尾或项目说明中注明素材来源。素材来源与具体授权条款以原始页面及 [Pexels License](https://www.pexels.com/license/) 为准。

