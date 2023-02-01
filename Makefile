check: typecheck test lintcheck

test:
	pytest --cov=. --cov-branch .
	coverage html

typecheck:
	mypy .

lintcheck:
	black --check .
	ruff .

lint:
	black .
	ruff --fix .

.PHONY: test typecheck lintcheck lint
