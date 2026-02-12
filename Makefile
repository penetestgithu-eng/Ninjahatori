.PHONY: help install install-dev install-termux run run-api run-worker run-all test coverage lint format clean docker-up docker-down migrate init

help:
	@echo "Ninjahatori - Penetration Testing Tool"
	@echo ""
	@echo "Usage:"
	@echo "  make install          Install dependencies"
	@echo "  make install-dev      Install dev dependencies"
	@echo "  make install-termux   Install for Termux (Android)"
	@echo "  make run              Run full stack (Docker)"
	@echo "  make run-api          Run API only"
	@echo "  make run-worker       Run Celery worker only"
	@echo "  make run-all          Run all services (no Docker)"
	@echo "  make test             Run tests"
	@echo "  make coverage         Run tests with coverage"
	@echo "  make lint             Run linting"
	@echo "  make format           Format code"
	@echo "  make clean            Clean up"
	@echo "  make docker-up        Start Docker containers"
	@echo "  make docker-down      Stop Docker containers"
	@echo "  make migrate          Run database migrations"
	@echo "  make init             Initialize database"

install:
	python -m venv venv
	. venv/bin/activate && pip install -r requirements.txt
	cp .env.example .env
	@echo "✅ Installation complete. Run 'source venv/bin/activate' to activate."

install-dev:
	python -m venv venv
	. venv/bin/activate && pip install -r requirements.txt -r requirements-dev.txt
	cp .env.example .env
	@echo "✅ Dev installation complete."

install-termux:
	pkg update && pkg upgrade -y
	pkg install python python-dev clang make openssl-dev git -y
	python -m venv venv
	. venv/bin/activate && pip install -r requirements-termux.txt
	cp .env.example .env
	@echo "✅ Termux installation complete."

init:
	. venv/bin/activate && python -m core.database init
	@echo "✅ Database initialized."

migrate:
	. venv/bin/activate && python -m core.database migrate
	@echo "✅ Database migrated."

run:
	docker-compose up -d
	@echo "✅ All services started. API: http://localhost:8000"

run-api:
	. venv/bin/activate && python api/main.py
	@echo "✅ API running on http://localhost:8000"

run-worker:
	. venv/bin/activate && celery -A worker.celery_app worker --loglevel=info
	@echo "✅ Celery worker started."

run-all:
	@echo "Starting all services..."
	@echo "Terminal 1: Redis"
	@echo "Terminal 2: Celery Worker"
	@echo "Terminal 3: API"
	@echo ""
	@echo "Run in separate terminals:"
	@echo "  make redis-server"
	@echo "  make run-worker"
	@echo "  make run-api"

redis-server:
	reedis-server

test:
	. venv/bin/activate && pytest tests/ -v
	@echo "✅ Tests passed."

coverage:
	. venv/bin/activate && pytest --cov=scanner --cov=api --cov=core tests/ -v
	@echo "✅ Coverage report generated."

lint:
	. venv/bin/activate && flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	. venv/bin/activate && flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

format:
	. venv/bin/activate && black .
	. venv/bin/activate && isort .

docker-build:
	docker build -t ninjahatori:latest .
docker-up:
	docker-compose up -d
	@echo "✅ Docker containers started."
docker-down:
	docker-compose down
	@echo "✅ Docker containers stopped."
docker-logs:
	docker-compose logs -f

clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	find . -type d -name ".coverage" -exec rm -r {} +
	find . -type d -name "*.egg-info" -exec rm -r {} +
	@echo "✅ Cleanup complete."

scan-example:
	. venv/bin/activate && python -m ninjahatori scan --target example.com --type full

scan-port:
	. venv/bin/activate && python -m ninjahatori scan --target 192.168.1.1 --type port

version:
	@grep "APP_VERSION" .env.example