.PHONY: ci format preview repomix repomix-all repomix-except-articles sync-agent new-article sync-ruler setup

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

sync-ruler:
	@sh scripts/sync_rule.sh

setup:
	@if [ -e .git/hooks/post-merge ]; then echo "setup: skipping post-merge (already exists)"; else printf '#!/bin/sh\nmake sync-ruler\n' > .git/hooks/post-merge && chmod +x .git/hooks/post-merge; fi
	@if [ -e .git/hooks/post-checkout ]; then echo "setup: skipping post-checkout (already exists)"; else printf '#!/bin/sh\nmake sync-ruler\n' > .git/hooks/post-checkout && chmod +x .git/hooks/post-checkout; fi
	@echo "setup: git hooks installed"
