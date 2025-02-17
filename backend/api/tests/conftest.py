import os
import pytest
import django


@pytest.fixture(scope="session", autouse=True)
def configure_django_settings():
    # Set the DJANGO_SETTINGS_MODULE environment variable
    os.environ["DJANGO_SETTINGS_MODULE"] = "config.settings"

    # Ensure that Django is set up and ready for tests
    django.setup()
