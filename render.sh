#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
WORK="${RENDER_WORK_DIR:-/home/hatch/workspace/makefun-agent/clipper-v2-work/render}"
mkdir -p "$WORK"
FONT="${FONT_FILE:-/usr/share/fonts/truetype/noto/NotoSansDisplay-CondensedBold.ttf}"
test -f "$FONT" || { echo "Missing bold font: $FONT" >&2; exit 1; }
FF=(ffmpeg -hide_banner -loglevel error -y -threads 4 -filter_complex_threads 2)
ENC=(-an -c:v libx264 -preset fast -crf 19 -pix_fmt yuv420p -r 30 -threads 4)
text() {
  printf "drawtext=fontfile='%s':text='%s':expansion=none:fontsize=%s:fontcolor=%s:borderw=7:bordercolor=black:shadowcolor=black@0.6:shadowx=3:shadowy=5:x=(w-tw)/2:y=%s" "$FONT" "$1" "$2" "${4:-white}" "$3"
}
BASE='split[bg][fg];[bg]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=35,eq=brightness=-0.22:saturation=0.65[back];[fg]scale=1080:608[front];[back][front]overlay=0:656'
HOOK="$(text '3 DETAILS YOU MISSED' 100 270),$(text 'IN THE GTA 6 TRAILER' 64 400),$(text 'WATCH THE BACKGROUND.' 48 1370 0x75ffe0)"
"${FF[@]}" -i assets/hook.mp4 -filter_complex "[0:v]$BASE,$HOOK,setsar=1[v]" -map '[v]' -t 2.5 "${ENC[@]}" "$WORK/01.mp4"
detail() {
  local file="$1" zoom="$2" targetx="$3" targety="$4" rank="$5" headline="$6" sub="$7" label="$8" output="$9"
  local ease='(on/194)*(on/194)*(3-2*on/194)'
  local z="1+($zoom-1)*($ease)"
  local rx="($targetx-1920/(2*$zoom))/(1920-1920/$zoom)"
  local ry="($targety-1080/(2*$zoom))/(1080-1080/$zoom)"
  local filter="[0:v]split[b][f];[b]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=35,eq=brightness=-0.25:saturation=0.6[bg];[f]scale=3840:2160,zoompan=z='$z':x='(iw-iw/zoom)*$rx':y='(ih-ih/zoom)*$ry':d=1:s=1080x608:fps=30[fg];[bg][fg]overlay=0:656,drawbox=x=0:y=650:w=1080:h=6:color=0x75ffe0:t=fill,$(text "#$rank" 132 215 0x75ffe0),$(text "$headline" 76 405),$(text "$sub" 49 520),$(text "$label" 34 1325),$(text 'LOOK CLOSER.' 44 1420 0x75ffe0),setsar=1[v]"
  "${FF[@]}" -loop 1 -framerate 30 -i "$file" -filter_complex "$filter" -map '[v]' -frames:v 195 "${ENC[@]}" "$WORK/$output.mp4"
}
detail assets/gator.png 2.8 1180 600 3 'THE GATOR WALKS IN' 'THROUGH THE SHOP DOORS' 'TRAILER 1 / 00.48.10 / FREEZE + ZOOM' 02
PITCH="$(text 'THIS CLIP WAS CUT BY AN AI AGENT' 49 610),$(text 'IT EARNS MONEY MAKING CLIPS' 53 755),$(text 'ON make.fun' 132 920 0x75ffe0)"
CARD='scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=40,eq=brightness=-0.22,drawbox=x=55:y=490:w=970:h=810:color=black@0.76:t=fill'
"${FF[@]}" -i assets/card-background.mp4 -vf "$CARD,$PITCH,setsar=1" -t 3 "${ENC[@]}" "$WORK/03.mp4"
detail assets/car-roof.png 2.15 800 520 2 'SHE IS ON THE ROOF' 'OF A MOVING CAR' 'TRAILER 1 / 00.44.15 / FREEZE + ZOOM' 04
detail assets/phil-tv.png 3.2 1050 440 1 'PHIL IS ON THE TV' 'HIS NAME IS ON THE SHIRT' 'TRAILER 2 / 02.09.40 / FREEZE + ZOOM' 05
CTA="$(text 'MAKE CLIPS LIKE THIS WITH AI' 61 605),$(text 'EARN MONEY ON make.fun' 72 785 0x75ffe0),$(text 'make.fun/bounty/gta6-clipper-01 - link in description' 32 1090)"
"${FF[@]}" -i assets/card-background.mp4 -vf "$CARD,$CTA,setsar=1" -t 5 "${ENC[@]}" "$WORK/06.mp4"
printf "file '%s/01.mp4'\nfile '%s/02.mp4'\nfile '%s/03.mp4'\nfile '%s/04.mp4'\nfile '%s/05.mp4'\nfile '%s/06.mp4'\n" "$WORK" "$WORK" "$WORK" "$WORK" "$WORK" "$WORK" > "$WORK/concat.txt"
"${FF[@]}" -f concat -safe 0 -i "$WORK/concat.txt" -c copy "$WORK/picture.mp4"
SYNTH='aevalsrc=exprs=0.10*(sin(2*PI*110*t)+0.45*sin(2*PI*220*t)+0.30*sin(2*PI*261.6256*t)+0.25*sin(2*PI*329.6276*t))*(0.65+0.35*cos(2*PI*2*t))+0.025*(2*(t*55-floor(t*55))-1)*exp(-5*mod(t\,0.5)):s=48000:d=30,lowpass=f=2200,afade=t=in:d=0.35,afade=t=out:st=29:d=1,volume=0.60'
"${FF[@]}" -i "$WORK/picture.mp4" -f lavfi -i "$SYNTH" -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 192k -ac 2 -ar 48000 -t 30 -movflags +faststart -map_metadata -1 clip.mp4
ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate,sample_rate,channels -show_entries format=duration,size -of json clip.mp4
