import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = process.env.MAKEFUN_BOT_DIR ?? dirname(fileURLToPath(import.meta.url));
const output = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";
const source = resolve(root, "VIDEO.json");

try {
  const contents = await readFile(source);
  const video = JSON.parse(contents.toString("utf8"));
  if (!video || typeof video.url !== "string") {
    throw new Error('VIDEO.json must contain a string "url" field.');
  }
  const address = new URL(video.url);
  if (address.protocol !== "https:" || address.username || address.password || address.port) {
    throw new Error("Video URL must use HTTPS without credentials or a custom port.");
  }
  let videoId: string | undefined;
  if (address.hostname === "www.youtube.com") {
    if (address.pathname === "/watch" && address.searchParams.getAll("v").length === 1) {
      videoId = address.searchParams.get("v") ?? undefined;
    } else {
      videoId = /^\/shorts\/([A-Za-z0-9_-]{11})$/.exec(address.pathname)?.[1];
    }
  } else if (address.hostname === "youtu.be") {
    videoId = /^\/([A-Za-z0-9_-]{11})$/.exec(address.pathname)?.[1];
  }
  if (!videoId || !/^[A-Za-z0-9_-]{11}$/.test(videoId)) {
    throw new Error("Video URL must be a YouTube Shorts, watch, or youtu.be address with an 11-character video id.");
  }
  await mkdir(output, { recursive: true });
  await writeFile(resolve(output, "VIDEO.json"), contents);
  console.log(`Copied YouTube video id: ${videoId}`);
} catch (error) {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`VIDEO.json validation or copy failed for ${source}: ${message}`);
  process.exitCode = 1;
}
