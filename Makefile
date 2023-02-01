check: typecheck test lintcheck

test:
	# pytest .

typecheck:
	mypy .

lintcheck:
	black --check .
	ruff .

lint:
	black .
	ruff --fix .

.PHONY: test typecheck lintcheck lint
