import os
from dotenv import load_dotenv
from pydantic import BaseSettings

load_dotenv()

class Settings(BaseSettings):
    # API
    API_HOST: str = os.getenv("API_HOST", "0.0.0.0")
    API_PORT: int = int(os.getenv("API_PORT", 8000))
    API_DEBUG: bool = os.getenv("API_DEBUG", "True") == "True"
    API_SECRET_KEY: str = os.getenv("API_SECRET_KEY", "dev-key")
    
    # Database
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", 5432))
    DB_NAME: str = os.getenv("DB_NAME", "ninjahatori")
    DB_USER: str = os.getenv("DB_USER", "ninjahatori")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "ninjahatori_secure_password")
    
    @property
    def DATABASE_URL(self) -> str:
        return f"postgresql://{self.DB_USER}:{self.DB_PASSWORD}@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
    
    # Redis
    REDIS_HOST: str = os.getenv("REDIS_HOST", "localhost")
    REDIS_PORT: int = int(os.getenv("REDIS_PORT", 6379))
    REDIS_DB: int = int(os.getenv("REDIS_DB", 0))
    REDIS_PASSWORD: str = os.getenv("REDIS_PASSWORD", "")
    
    @property
    def REDIS_URL(self) -> str:
        if self.REDIS_PASSWORD:
            return f"redis://:{self.REDIS_PASSWORD}@{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_DB}"
        return f"redis://{self.REDIS_HOST}:{self.REDIS_PORT}/{self.REDIS_DB}"
    
    # Scanning
    SCAN_TIMEOUT: int = int(os.getenv("SCAN_TIMEOUT", 30))
    SCAN_THREADS: int = int(os.getenv("SCAN_THREADS", 10))
    SCAN_MAX_RETRIES: int = int(os.getenv("SCAN_MAX_RETRIES", 3))
    SCAN_RATE_LIMIT: int = int(os.getenv("SCAN_RATE_LIMIT", 100))
    
    # DNS
    DNS_SERVERS: list = os.getenv("DNS_SERVERS", "8.8.8.8,1.1.1.1").split(",")
    DNS_TIMEOUT: int = int(os.getenv("DNS_TIMEOUT", 5))
    DNS_WORDLIST_PATH: str = os.getenv("DNS_WORDLIST_PATH", "./data/dns_wordlist.txt")
    
    # Port
    PORT_RANGE: str = os.getenv("PORT_RANGE", "1-65535")
    PORT_COMMON_ONLY: bool = os.getenv("PORT_COMMON_ONLY", "False") == "True"
    PORT_TIMEOUT: int = int(os.getenv("PORT_TIMEOUT", 3))
    
    # HTTP
    HTTP_TIMEOUT: int = int(os.getenv("HTTP_TIMEOUT", 10))
    HTTP_USER_AGENT: str = os.getenv("HTTP_USER_AGENT", "Mozilla/5.0 (Ninjahatori/1.0)")
    HTTP_PROXY: str = os.getenv("HTTP_PROXY", "")
    
    # Logging
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    LOG_FILE: str = os.getenv("LOG_FILE", "./logs/ninjahatori.log")
    LOG_FORMAT: str = os.getenv("LOG_FORMAT", "json")
    
    # Paths
    RESULTS_DIR: str = os.getenv("RESULTS_DIR", "./results")
    DATA_DIR: str = os.getenv("DATA_DIR", "./data")
    BACKUP_DIR: str = os.getenv("BACKUP_DIR", "./backups")

settings = Settings()