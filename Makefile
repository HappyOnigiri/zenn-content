.PHONY: ci format preview repomix repomix-all repomix-except-articles new-article setup

ci:
	npm run ci

format:
	npm run format

preview:
	npm run preview -- --port 8231

repomix: repomix-all repomix-except-articles

repomix-all:
	mkdir -p tmp/repomix
	npx repomix --output tmp/repomix/repomix-output.txt

repomix-except-articles:
	mkdir -p tmp/repomix
	npx repomix --ignore "articles/**/*" --output tmp/repomix/repomix-except-articles-output.txt

new-article:
	@ARTICLE_FILE=$$(npx zenn new:article --machine-readable) && \
	SLUG=$$(echo $$ARTICLE_FILE | sed -e 's|articles/||' -e 's|\.md||') && \
	mkdir -p images/$$SLUG && \
	echo "Created article: $$ARTICLE_FILE" && \
	echo "Created image directory: images/$$SLUG"

setup:
	curl -fsSL https://raw.githubusercontent.com/HappyOnigiri/ShareSettings/main/SyncRule/run.sh | bash
