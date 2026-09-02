from pathlib import Path
from typing import List

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


BACKEND_DIR = Path(__file__).resolve().parents[2]
PROJECT_ROOT = BACKEND_DIR.parent


class Settings(BaseSettings):
    app_name: str = "LocalMind API"
    app_version: str = "0.1.0"
    environment: str = "development"

    api_prefix: str = "/api"

    host: str = "127.0.0.1"
    port: int = 8000

    database_url: str = Field(
        default=f"sqlite:///{(PROJECT_ROOT / 'database' / 'localmind.db').as_posix()}"
    )

    books_upload_dir: Path = PROJECT_ROOT / "books" / "uploads"
    books_extracted_dir: Path = PROJECT_ROOT / "books" / "extracted"
    books_processed_dir: Path = PROJECT_ROOT / "books" / "processed"

    cors_origins: str = (
        "http://localhost:3000,"
        "http://localhost:5173,"
        "http://localhost:8080,"
        "http://127.0.0.1:8080"
    )

    debug: bool = True

    model_config = SettingsConfigDict(
        env_file=BACKEND_DIR / ".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    @property
    def cors_origin_list(self) -> List[str]:
        return [
            origin.strip()
            for origin in self.cors_origins.split(",")
            if origin.strip()
        ]

    def ensure_directories(self) -> None:
        self.books_upload_dir.mkdir(parents=True, exist_ok=True)
        self.books_extracted_dir.mkdir(parents=True, exist_ok=True)
        self.books_processed_dir.mkdir(parents=True, exist_ok=True)


settings = Settings()