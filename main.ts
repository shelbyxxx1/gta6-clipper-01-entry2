import { access, copyFile, mkdir } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = process.env.MAKEFUN_BOT_DIR ?? dirname(fileURLToPath(import.meta.url));
const output = process.env.MAKEFUN_OUTPUT_DIR ?? "/output";
const source = resolve(root, "VIDEO.json");

try {
  await access(source);
  await mkdir(output, { recursive: true });
  await copyFile(source, resolve(output, "VIDEO.json"));
} catch (error) {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`VIDEO.json copy failed. Ensure ${source} exists and the output directory is writable: ${message}`);
  process.exitCode = 1;
}
