# Render verification

- Final file: clip.mp4, 30.000 seconds, 900 frames, 1080x1920, 30 fps, H.264/yuv420p; AAC stereo, 48 kHz, requested 192 kb/s. MP4 fast-start enabled.
- Extracted and visually inspected final frames at 1, 5, 10.5, 15, 21, and 27 seconds: all six segment captions present, readable, inside the canvas, and correctly spelled. Also inspected the Phil zoom endpoint at 24.9 seconds; the shirt name remains in view.
- Full ffmpeg decode completed without errors. Per-second signalstats were generated in the external scratch directory. Synth audio measured mean -32.7 dBFS, peak -22.2 dBFS: deliberately quiet and not clipped.
- Only video streams from the official sources were used; all audio was synthesized in render.sh. No added watermark.
- Runner tested on Node 22.23.5 and the host's Node 24.22.1: successful copy is byte-identical; missing source exits 1 with an actionable error. The output directory is created recursively, never replaced or deleted.
- No YouTube upload, make.fun submission, invented video address, or transcript bundle. VIDEO.json is the requested placeholder for the later human upload.
