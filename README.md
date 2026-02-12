# Ninjahatori - Advanced Penetration Testing Tool

A comprehensive, production-ready penetration testing framework with DNS, port, and HTTP scanning capabilities, real-time reporting, and behavior analysis. Works on Linux, macOS, and Android (Termux).

## Features

- 🎯 **Multi-Protocol Scanning**: DNS, Port, HTTP
- 🤖 **Behavior Model**: AI-powered attack pattern detection
- 📊 **Real-time Dashboard**: Live scanning results
- 🔄 **Async Task Queue**: Celery-based distributed scanning
- 📈 **Observability**: Prometheus + Grafana integration
- 🐳 **Container Ready**: Docker & Kubernetes support
- 📱 **Termux Compatible**: Run on Android devices
- 🔐 **Enterprise Security**: JWT, API Keys, CORS
- 📝 **Full Logging**: Structured JSON logging
- 🚀 **Production Optimized**: Zero-downtime deployment

## Quick Start

### Prerequisites
- Python 3.9+
- Redis (for task queue)
- PostgreSQL or SQLite

### Installation - Linux/macOS

```bash
git clone https://github.com/penetestgithu-eng/Ninjahatori.git
cd Ninjahatori
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
```

### Installation - Termux (Android)

```bash
pkg update && pkg upgrade
pkg install python python-dev clang make openssl-dev
git clone https://github.com/penetestgithu-eng/Ninjahatori.git
cd Ninjahatori
python -m venv venv
source venv/bin/activate
pip install -r requirements-termux.txt
cp .env.example .env
```

### Start Services

```bash
# Terminal 1: Redis (if not using external)
redis-server

# Terminal 2: Celery Worker
celery -A worker.celery_app worker --loglevel=info

# Terminal 3: Main API
python api/main.py

# Terminal 4: Prometheus (optional)
prometheus --config.file=observability/prometheus/prometheus.yml
```

Or use Docker:

```bash
docker-compose up -d
```

## API Endpoints

### Core Scanning
- `POST /api/v1/scan/dns` - DNS reconnaissance
- `POST /api/v1/scan/port` - Port scanning
- `POST /api/v1/scan/http` - HTTP enumeration
- `POST /api/v1/scan/full` - Full integrated scan

### Task Management
- `GET /api/v1/tasks/{task_id}` - Check scan status
- `GET /api/v1/tasks` - List all tasks
- `DELETE /api/v1/tasks/{task_id}` - Cancel scan

### Reports
- `GET /api/v1/reports/{scan_id}` - Get scan report
- `GET /api/v1/reports` - List all reports

### System
- `GET /api/v1/health` - Health check
- `GET /metrics` - Prometheus metrics

## Configuration

Edit `.env` file to customize:

```env
APP_ENV=production
DATABASE_URL=postgresql://user:pass@localhost/ninjahatori
CELERY_BROKER_URL=redis://localhost:6379/0
SCANNER_THREADS=10
LOG_LEVEL=INFO
```

## Usage Examples

### CLI Mode

```bash
python -m ninjahatori scan --target example.com --type full
python -m ninjahatori scan --target 192.168.1.0/24 --type port --threads 20
python -m ninjahatori report --scan-id abc123
```

### Python API

```python
from scanner.dns import DNSScanner
from scanner.port import PortScanner

# DNS scan
dns_scanner = DNSScanner()
results = dns_scanner.scan("example.com")

# Port scan
port_scanner = PortScanner()
results = port_scanner.scan("192.168.1.1", ports=[80, 443, 8080])
```

### HTTP API

```bash
curl -X POST http://localhost:8000/api/v1/scan/dns \ 
  -H "Content-Type: application/json" \ 
  -H "X-API-Key: your-api-key" \ 
  -d '{"target": "example.com"}'

curl http://localhost:8000/api/v1/tasks/task-id
```

## Architecture

```
Ninjahatori/
├── core/              # Core utilities, logging, config
├── scanner/           # DNS, Port, HTTP scanning engines
├── worker/            # Async task processing (Celery)
├── api/               # FastAPI REST endpoints
├── infra/             # Docker, K8s, Terraform configs
└── observability/     # Prometheus, Grafana
```

## Performance

- **Throughput**: 10,000+ domains/hour (DNS)
- **Latency**: <100ms per request (P99)
- **Concurrency**: 100+ concurrent scans
- **Memory**: ~200MB base + per-scan allocation
- **Storage**: Efficient SQLite/PostgreSQL usage

## Security

- ✅ API Key authentication
- ✅ JWT token support
- ✅ CORS protection
- ✅ Rate limiting (100 req/min)
- ✅ Input validation & sanitization
- ✅ No credential storage
- ✅ Secure headers enabled

## Monitoring

Access Grafana dashboard:
```
http://localhost:3000
```

Access Prometheus:
```
http://localhost:9090
```

## Troubleshooting

**Redis connection error**: Ensure Redis is running
```bash
redis-cli ping  # Should return PONG
```

**Database migration**: 
```bash
python -m core.database migrate
```

**Check logs**:
```bash
tail -f logs/app.log
```

## Development

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run tests
pytest tests/ -v

# Code coverage
pytest --cov=scanner --cov=api tests/

# Linting
flake8 .
black --check .
```

## Contributing

1. Fork repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

MIT License - see LICENSE file

## Support

- 📧 Email: support@ninjahatori.dev
- 🐛 Issues: GitHub Issues
- 📚 Docs: docs.ninjahatori.dev

## Roadmap

See [ROADMAP.md](ROADMAP.md) for planned features.