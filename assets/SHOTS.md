# Source decisions

Both source IDs were verified with yt-dlp --get-title and channel metadata as Rockstar Games' official Grand Theft Auto VI Trailer 1 and Trailer 2. Source video: 1920x1080, 30 fps. Coordinates below refer to those original frames, with origin at the upper left.

| Pick | Official source | Frame time | Target center | End zoom | Confirmed visual |
| --- | --- | --- | --- | --- | --- |
| #3 | Trailer 1, QdBZY2fkU-0 | 00:48.100 | (1180, 600) | 2.8x | Alligator entering the convenience store through its glass doors. |
| #2 | Trailer 1, QdBZY2fkU-0 | 00:44.150 | (800, 520) | 2.15x | Woman dancing on a car roof; adjacent scene frames at 43.85 and 44.55 show changing street/background position. |
| #1 | Trailer 2, VQRLujxTm3c | 02:09.400 | (1050, 440) | 3.2x | Gun-shop advertisement on the room's TV; PHIL'S is visible on the man's shirt. No claim that this is a returning character. |

The hook is Trailer 1's red-car driving/drift shot, 01:10.000–01:12.500. Card background is Trailer 1, 00:33.000–00:38.000. Only those small, silent extracts and the three full-resolution stills are retained. The downloaded trailers remain outside the repository.

Creative: lead with kinetic driving, then count down from an unexpected animal to precarious roof dancing to the easily overlooked TV-within-the-trailer. Each freeze begins uncropped and uses an eased zoom into its recorded target. Captions describe only visible evidence. The early pitch interrupts after the first payoff, and the final card explicitly connects AI clipping with earning money on make.fun. Earnings text is promotional, not a claim this unpublished clip has earned a reward.

Timeline: hook 0–2.5; #3 2.5–9; pitch 9–12; #2 12–18.5; #1 18.5–25; CTA 25–30 seconds. Original synthesized sine-chord and soft saw-pulse audio only; no source audio, added watermark, or transcript bundle.

Run ./render.sh to regenerate clip.mp4 from the committed assets with ffmpeg. FONT_FILE and RENDER_WORK_DIR may override the installed font and temporary-render directory. Node 22.18+ runs main.ts without dependencies. VIDEO.json intentionally remains an upload placeholder.
