.PHONY: ci format preview repomix repomix-all repomix-except-articles sync-agent new-article

ci:
	npm run ci

format:
	npm run format

preview:
	npm run preview

repomix: repomix-all repomix-except-articles

repomix-all:
	mkdir -p tmp/repomix
	npx repomix --output tmp/repomix/repomix-output.txt

repomix-except-articles:
	mkdir -p tmp/repomix
	npx repomix --ignore "articles/**/*" --output tmp/repomix/repomix-except-articles-output.txt

# .cursor のファイルを .agent に同期 (削除も追従)
sync-agent:
	@mkdir -p .agent
	rsync -av --delete .cursor/ .agent/
	@echo ".cursor files have been synchronized to .agent."

new-article:
	@ARTICLE_FILE=$$(npx zenn new:article --machine-readable) && \
	SLUG=$$(echo $$ARTICLE_FILE | sed -e 's|articles/||' -e 's|\.md||') && \
	mkdir -p images/$$SLUG && \
	echo "Created article: $$ARTICLE_FILE" && \
	echo "Created image directory: images/$$SLUG"
