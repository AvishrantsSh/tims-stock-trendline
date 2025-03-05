UV_EXISTS := $(shell command -v uv 2> /dev/null)
PORT := 8080

install:
	@echo "-> Configuring uv package manager"
ifndef UV_EXISTS
	curl -LsSf https://astral.sh/uv/install.sh | sh
endif
	uv venv --python 3.12
	uv sync --no-dev

dev: install
	@echo "-> Installing Developer Dependencies"
	uv sync

run:
	@echo "Running server..."
	flask run --port $(PORT)


migrate:
	@echo "Migrating database..."
	flask db upgrade

format:
	@echo "Formatting code..."
	uvx ruff format .
	uvx ruff check --fix . || true

clean: format
	@echo "Clearing python cache"
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
