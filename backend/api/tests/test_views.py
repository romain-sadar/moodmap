import pytest
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.exceptions import ErrorDetail
from api.tests.factories import UserFactory, MoodFactory
from django.urls import reverse


@pytest.fixture
def api_client():
    return APIClient()


@pytest.fixture
def user_data():
    return {
        "username": "testuser",
        "email": "testuser@example.com",
        "password": "password123",
    }


@pytest.fixture
def existing_user():
    return UserFactory()


@pytest.mark.django_db
def test_register_success(api_client, user_data):
    # Test for successful user registration
    response = api_client.post(reverse("auth-register"), user_data, format="json")

    assert response.status_code == status.HTTP_201_CREATED
    assert response.data["message"] == "User registered successfully"
    assert "user" in response.data
    assert "id" in response.data["user"]
    assert response.data["user"]["id"] is not None


@pytest.mark.django_db
def test_register_user_already_exists(api_client, existing_user, user_data):
    # Test for attempting to register a user that already exists
    response = api_client.post(
        reverse("auth-register"),
        {
            **user_data,
            "email": existing_user.email,  # Duplicate email
        },
        format="json",
    )

    assert response.status_code == status.HTTP_400_BAD_REQUEST
    assert response.data["email"] == [
        ErrorDetail(
            string="User with this email address already exists.", code="unique"
        )
    ]


@pytest.mark.django_db
def test_register_missing_fields(api_client):
    # Test for missing fields in the registration request
    response = api_client.post(reverse("auth-register"), {}, format="json")

    assert response.status_code == status.HTTP_400_BAD_REQUEST
    assert "username" in response.data
    assert "email" in response.data
    assert "password" in response.data


@pytest.mark.django_db
def test_user_login_success():
    password = "testpassword123"
    user = UserFactory(email="test@example.com")
    user.set_password(password)
    user.save()

    client = APIClient()
    url = reverse("auth-login")
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
    user.set_password(password)
    user.save()

    client = APIClient()
    url = reverse("auth-login")
    data = {
        "email": "test@example.com",
        "password": "wrongpassword",
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "non_field_errors" in response.data
    assert "Invalid credentials" in response.data["non_field_errors"][0]


@pytest.mark.django_db
def test_user_login_inactive_user():
    password = "testpassword123"
    user = UserFactory(email="test@example.com", is_active=False)
    user.set_password(password)
    user.save()

    client = APIClient()
    url = reverse("auth-login")
    data = {
        "email": "test@example.com",
        "password": password,
    }
    response = client.post(url, data, format="json")

    assert response.status_code == 400
    assert "non_field_errors" in response.data
    assert "User account is not active." in response.data["non_field_errors"]


@pytest.mark.django_db
def test_update_profile_success(api_client, user_data, existing_user):
    # Authenticate user
    api_client.force_authenticate(user=existing_user)

    # Prepare the data to update
    update_data = {
        "username": "new_username",
        "email": "new_email@example.com",
        "age": 30,
        "gender": "M",
        "premium": True,
    }

    response = api_client.patch(
        reverse("auth-update-profile"), update_data, format="json"
    )

    assert response.status_code == status.HTTP_200_OK
    assert response.data["message"] == "User profile updated successfully"
    assert response.data["user"]["username"] == "new_username"
    assert response.data["user"]["email"] == "new_email@example.com"
    assert response.data["user"]["age"] == 30
    assert response.data["user"]["gender"] == "M"
    assert response.data["user"]["premium"] is True


@pytest.mark.django_db
def test_mood_list():
    MoodFactory.create_batch(3)

    client = APIClient()
    url = reverse("mood-list")
    response = client.get(url)

    assert response.status_code == 200
    assert len(response.data["results"]) == 3


@pytest.mark.django_db
def test_mood_create():
    client = APIClient()
    url = reverse("mood-list")
    data = {"label": "Excited"}

    response = client.post(url, data, format="json")

    assert response.status_code == 201
    assert response.data["label"] == "Excited"


@pytest.mark.django_db
def test_mood_retrieve():
    mood = MoodFactory(label="Happy")

    client = APIClient()
    url = reverse("mood-detail", kwargs={"pk": mood.pk})
    response = client.get(url)

    assert response.status_code == 200
    assert response.data["label"] == "Happy"


@pytest.mark.django_db
def test_mood_update():
    mood = MoodFactory(label="Sad")

    client = APIClient()
    url = reverse("mood-detail", kwargs={"pk": mood.pk})
    data = {"label": "Cheerful"}

    response = client.put(url, data, format="json")

    assert response.status_code == 200
    assert response.data["label"] == "Cheerful"


@pytest.mark.django_db
def test_mood_delete():
    mood = MoodFactory()

    client = APIClient()
    url = reverse("mood-detail", kwargs={"pk": mood.pk})
    response = client.delete(url)

    assert response.status_code == 204
