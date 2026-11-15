.PHONY: clean build-browser-extension

clean:
	rm -rf dist

build-browser-extension: clean
	pnpm exec tsc --noEmit
	pnpm exec vite build -c vite.config.chromium.ts
	pnpm exec vite build -c vite.config.firefox.ts
	cd dist/browser-extension/chromium && zip -qr ../chromium.zip .
	cd dist/browser-extension/firefox && zip -qr ../firefox.zip .
