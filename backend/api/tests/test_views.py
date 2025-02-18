import pytest
from rest_framework.test import APIClient
from api.tests.factories import UserFactory, MoodFactory
from django.urls import reverse


@pytest.mark.django_db
def test_user_login_success():
    password = "testpassword123"
    user = UserFactory(email="test@example.com")
    user.set_password(password)  # Ensure password hashing is correct
    user.save()

    client = APIClient()
    url = reverse("auth-login")  # Updated name based on the router action
    data = {
        "email": "test@example.com",
        "password": password,
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 200
    assert "tokens" in response.data
    assert "access" in response.data["tokens"]
    assert "refresh" in response.data["tokens"]
    assert response.data["user"]["email"] == "test@example.com"


@pytest.mark.django_db
def test_user_login_invalid_credentials():
    password = "testpassword123"
    user = UserFactory(email="test@example.com")
    user.set_password(password)  # Hash password properly
    user.save()

    client = APIClient()
    url = reverse("auth-login")  # Updated to match the viewset action
    data = {
        "email": "test@example.com",
        "password": "wrongpassword",  # Incorrect password
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "non_field_errors" in response.data
    assert "Invalid credentials" in response.data["non_field_errors"][0]


@pytest.mark.django_db
def test_user_login_inactive_user():
    password = "testpassword123"
    user = UserFactory(email="test@example.com", is_active=False)
    user.set_password(password)  # Hash password correctly
    user.save()

    client = APIClient()
    url = reverse("auth-login")  # Updated to match the viewset action
    data = {
        "email": "test@example.com",
        "password": password,
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "non_field_errors" in response.data
    assert "User account is not active." in response.data["non_field_errors"]


@pytest.mark.django_db
def test_mood_list():
    MoodFactory.create_batch(3)  # Create 3 mood instances

    client = APIClient()
    url = reverse("mood-list")  # Update based on your router's name
    response = client.get(url)

    assert response.status_code == 200
    assert len(response.data["results"]) == 3  # Ensure all moods are returned


@pytest.mark.django_db
def test_mood_create():
    client = APIClient()
    url = reverse("mood-list")  # URL for creating a new Mood
    data = {"label": "Excited"}

    response = client.post(url, data, format="json")

    assert response.status_code == 201  # Created
    assert response.data["label"] == "Excited"


@pytest.mark.django_db
def test_mood_retrieve():
    mood = MoodFactory(label="Happy")

    client = APIClient()
    url = reverse(
        "mood-detail", kwargs={"pk": mood.pk}
    )  # URL for retrieving a specific mood
    response = client.get(url)

    assert response.status_code == 200
    assert response.data["label"] == "Happy"


@pytest.mark.django_db
def test_mood_update():
    mood = MoodFactory(label="Sad")

    client = APIClient()
    url = reverse("mood-detail", kwargs={"pk": mood.pk})  # URL for updating a mood
    data = {"label": "Cheerful"}

    response = client.put(url, data, format="json")

    assert response.status_code == 200
    assert response.data["label"] == "Cheerful"


@pytest.mark.django_db
def test_mood_delete():
    mood = MoodFactory()

    client = APIClient()
    url = reverse("mood-detail", kwargs={"pk": mood.pk})  # URL for deleting a mood
    response = client.delete(url)

    assert response.status_code == 204  # No content (successful deletion)
