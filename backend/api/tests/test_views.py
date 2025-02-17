import pytest
from rest_framework.test import APIClient
from api.tests.factories import UserFactory
from django.urls import reverse


@pytest.mark.django_db
def test_user_login_success():
    user = UserFactory(email="test@example.com", password="testpassword123")

    client = APIClient()
    url = reverse("login")
    data = {
        "email": "test@example.com",
        "password": "testpassword123",
    }
    response = client.post(url, data, format="json")

    breakpoint()

    assert response.status_code == 200
    assert "tokens" in response.data
    assert "access" in response.data["tokens"]
    assert "refresh" in response.data["tokens"]
    assert response.data["user"]["email"] == "test@example.com"


@pytest.mark.django_db
def test_user_login_invalid_credentials():
    UserFactory(email="test@example.com", password="testpassword123")

    client = APIClient()
    url = reverse("login")
    data = {
        "email": "test@example.com",
        "password": "wrongpassword",  # Incorrect password
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "Invalid credentials" in str(response.data)


@pytest.mark.django_db
def test_user_login_inactive_user():
    user = UserFactory(email="test@example.com", is_active=False)

    client = APIClient()
    url = reverse("login")
    data = {
        "email": "test@example.com",
        "password": "testpassword123",
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "User account is not active." in response.data["non_field_errors"]
