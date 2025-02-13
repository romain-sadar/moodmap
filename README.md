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
POSTGRES_USER=<TO DEFINE>
POSTGRES_PASSWORD=<TO DEFINE>
POSTGRES_HOST=postgis
POSTGRES_DB=moodmap
PGADMIN_LISTEN_PORT=8052
```

3. Add a config/local.py file
```
from os import getenv

from config.settings import *  # noqa

# SECURITY WARNING: don"t run with debug turned on in production!
DEBUG = True
ALLOWED_HOSTS = [
    getenv("ALLOWED_HOSTS", "*"),
]

# Database
# https://docs.djangoproject.com/en/3.1/ref/settings/#databases
DATABASES = {
    "default": {
        "ENGINE": "django.contrib.gis.db.backends.postgis",
        "NAME": getenv("POSTGRES_DB", "moodmap"),
        "USER": getenv("POSTGRES_USER", "postgres"),
        "PASSWORD": getenv("POSTGRES_PASSWORD"),
        "HOST": getenv("POSTGRES_HOST", default="localhost"),
    }
}

```

4. Install `make` command if not already present

For Linux - `sudo apt-get install build-essential`

For MacOS - `brew install make`


5. Run `make build`

6. Create the necessary external docker networks : `docker network create moodmap`

7. Run `make start`


## Description

## Key features
