# Moodmap app

## CLone this repository

```bash
git clone git@github.com:romain-sadar/moodmap.git
cd moodmap
```
## Install pre-commit

```bash
pip install pre-commit
pre-commit install
```

## Docker Installation

1. Create a `.envs/.local/.django` file with following content

```
ALLOWED_HOSTS=[*]
DJANGO_SETTINGS_MODULE=config.local
PYTHONBREAKPOINT=ipdb.set_trace
PYTEST_ADDOPTS=--pdbcls=IPython.terminal.debugger:Pdb -n 0
```

2. Create a `.envs/.local/.postgres` file with following content

```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=root
POSTGRES_HOST=moodmap_db
POSTGRES_DB=moodmap
CURRENT_ENV=CICD
PGADMIN_LISTEN_PORT=8052
```

1. Create in `backend/config/`  => `local.py`  file with following content
```
import os

from config.settings import *  # noqa

# SECURITY WARNING: don"t run with debug turned on in production!
DEBUG = True
ALLOWED_HOSTS = [
    os.getenv("ALLOWED_HOSTS", "*"),
]

# Database
# https://docs.djangoproject.com/en/3.1/ref/settings/#databases
DATABASES = {
    "default": {
        "ENGINE": "django.contrib.gis.db.backends.postgis",
        "NAME": os.getenv("POSTGRES_DB", "moodmap"),
        "USER": os.getenv("POSTGRES_USER", "postgres"),
        "PASSWORD": os.getenv("POSTGRES_PASSWORD", "root"),
        "HOST": os.getenv(
            "POSTGRES_HOST", "postgis"
        ),  # Ensure this matches your .env file
        "PORT": "5432",
    }
}

GDAL_LIBRARY_PATH = "/usr/lib/x86_64-linux-gnu/libgdal.so"

```

4. Install `make` command if not already present

For Linux - `sudo apt-get install build-essential`

For MacOS - `brew install make`

For Windows, using [Chocolatey](https://chocolatey.org/install) `choco install make`


5. Run `make build`

6. Create the necessary external docker networks : `docker network create moodmap`

7. Run `make start`


## Description

## Key features
