import type { ElectrobunConfig } from "electrobun";

export default {
	app: {
		name: "ruli-smile-cleaner",
		identifier: "ruli.smilecleaner",
		version: "1.0.0",
	},
	build: {
		views: {
			mainview: {
				entrypoint: "src/mainview/index.ts",
			},
		},
		copy: {
			"src/cleaner_dom.js": "cleaner_dom.js",
			"src/mainview/index.html": "views/mainview/index.html",
			"src/mainview/index.css": "views/mainview/index.css",
		},
		mac: {
			icons: "assets/icons/smile.icns",
			bundleCEF: false,
		},
		linux: {
			icon: "assets/icons/smile.png",
			bundleCEF: false,
		},
		win: {
			icon: "assets/icons/smile.ico",
			bundleCEF: false,
		},
	},
} satisfies ElectrobunConfig;
