import { BrowserWindow } from "electrobun/bun"
import { readFile } from "node:fs/promises"
import { resolve } from "node:path"
import { escapeNonAscii } from "./Util.ts"

const articleURL = "https://bbs.ruliweb.com/member/mypage/myarticle"

const cleanerPreloadScript = escapeNonAscii(
	await readFile(resolve(import.meta.dir, "../cleaner_dom.js"), "utf8")
)

// Create the main application window
const mainWindow = new BrowserWindow({
	title: "Smile Cleaner",
	url: articleURL,
	frame: {
		width: 800,
		height: 600,
		x: 200,
		y: 200,
	},
	preload: cleanerPreloadScript,
});

console.log("Hello Electrobun app started!");
