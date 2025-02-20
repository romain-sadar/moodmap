from datetime import timezone
import pytest
from api.models import FavouritePlace, Category
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.exceptions import ErrorDetail
from api.tests.factories import (
    UserFactory,
    MoodFactory,
    PlaceFactory,
    VisitedPlaceFactory,
    FavouritePlaceFactory,
    CategoryFactory,
)
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


@pytest.mark.django_db
def test_place_retrieve():
    category = CategoryFactory()
    mood = MoodFactory()
    place = PlaceFactory(category=category, moods=[mood])

    url = reverse("place-detail", kwargs={"pk": place.pk})

    client = APIClient()

    response = client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert response.data["label"] == place.label
    assert response.data["latitude"] == float(place.latitude)
    assert response.data["longitude"] == float(place.longitude)
    assert response.data["description"] == place.description
    assert response.data["category"] == category.slug
    assert response.data["moods"][0] == mood.label
    assert "created_at" in response.data
    assert "updated_at" in response.data


@pytest.mark.django_db
def test_visited_place_list(api_client):
    user = UserFactory()
    place = PlaceFactory()
    VisitedPlaceFactory(user=user, place=place)

    url = reverse("visited-place-list")
    response = api_client.get(url)

    assert response.status_code == 200
    assert len(response.data["results"]) == 1


@pytest.mark.django_db
def test_visited_place_retrieve(api_client):
    visited_place = VisitedPlaceFactory()

    url = reverse("visited-place-detail", kwargs={"pk": visited_place.pk})
    response = api_client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert response.data["visited_time"] == visited_place.visited_time.isoformat() + "Z"
    assert (
        response.data["mood_feedback"] == visited_place.mood_feedback.id
        if visited_place.mood_feedback
        else None
    )


@pytest.mark.django_db
def test_visited_place_create(api_client):
    user = UserFactory()
    place = PlaceFactory()
    mood = MoodFactory()

    url = reverse("visited-place-list")
    data = {
        "user": user.pk,
        "place": place.pk,
        "visited_time": "2025-02-18T12:00:00Z",
        "mood_feedback": mood.pk,
    }

    response = api_client.post(url, data, format="json")

    assert response.status_code == status.HTTP_201_CREATED
    assert response.data["visited_time"] == data["visited_time"]
    assert response.data["mood_feedback"] == mood.pk


@pytest.mark.django_db
def test_visited_place_update(api_client):
    visited_place = VisitedPlaceFactory()
    new_mood = MoodFactory()

    url = reverse("visited-place-detail", kwargs={"pk": visited_place.pk})
    data = {
        "mood_feedback": new_mood.pk,
    }

    response = api_client.patch(url, data, format="json")

    assert response.status_code == status.HTTP_200_OK
    assert response.data["mood_feedback"] == new_mood.pk


@pytest.mark.django_db
def test_visited_place_delete(api_client):
    visited_place = VisitedPlaceFactory()

    url = reverse("visited-place-detail", kwargs={"pk": visited_place.pk})
    response = api_client.delete(url)

    assert response.status_code == status.HTTP_204_NO_CONTENT


@pytest.mark.django_db
def test_favourite_place_list(api_client):
    user = UserFactory()
    FavouritePlaceFactory.create_batch(3, user=user)

    url = reverse("favourite-place-list")
    api_client.force_authenticate(user=user)
    response = api_client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert len(response.data["results"]) == 3


@pytest.mark.django_db
def test_favourite_place_retrieve(api_client):
    favourite_place = FavouritePlaceFactory()

    url = reverse("favourite-place-detail", kwargs={"pk": favourite_place.pk})
    api_client.force_authenticate(user=favourite_place.user)
    response = api_client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert response.data["user"] == favourite_place.user.id
    assert response.data["place"] == favourite_place.place.id
    assert (
        response.data["added_at"]
        == favourite_place.added_at.astimezone(timezone.utc)
        .replace(tzinfo=None)
        .isoformat()
        + "Z"
    )


@pytest.mark.django_db
def test_favourite_place_create(api_client):
    user = UserFactory()
    place = PlaceFactory()

    url = reverse("favourite-place-list")
    api_client.force_authenticate(user=user)
    response = api_client.post(
        url, data={"user": user.id, "place": place.id}, format="json"
    )

    assert response.status_code == status.HTTP_201_CREATED
    assert FavouritePlace.objects.filter(user=user, place=place).exists()


@pytest.mark.django_db
def test_favourite_place_delete(api_client):
    favourite_place = FavouritePlaceFactory()

    url = reverse("favourite-place-detail", kwargs={"pk": favourite_place.pk})
    api_client.force_authenticate(user=favourite_place.user)
    response = api_client.delete(url)

    assert response.status_code == status.HTTP_204_NO_CONTENT
    assert not FavouritePlace.objects.filter(pk=favourite_place.pk).exists()


@pytest.mark.django_db
def test_category_list(api_client):
    # Create some categories using the CategoryFactory
    CategoryFactory.create_batch(5)

    url = reverse("category-list")  # Update with your correct URL name
    response = api_client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert len(response.data["results"]) == 5  # Check if all categories are listed


@pytest.mark.django_db
def test_category_retrieve(api_client):
    category = CategoryFactory()

    url = reverse(
        "category-detail", kwargs={"pk": category.pk}
    )  # Update with your correct URL name
    response = api_client.get(url)

    assert response.status_code == status.HTTP_200_OK
    assert response.data["slug"] == category.slug
    assert response.data["verbose_label"] == category.verbose_label


@pytest.mark.django_db
def test_category_create(api_client):
    # Prepare data for creating a new category
    data = {"slug": "new-category", "verbose_label": "New Category"}

    url = reverse("category-list")  # Update with your correct URL name
    response = api_client.post(url, data, format="json")

    # Check if the category is created successfully
    assert response.status_code == status.HTTP_201_CREATED
    assert response.data["slug"] == data["slug"]
    assert response.data["verbose_label"] == data["verbose_label"]


@pytest.mark.django_db
def test_category_update(api_client):
    # Create a category instance to be updated
    category = CategoryFactory()

    # Prepare data for updating the category
    updated_data = {"slug": "updated-category", "verbose_label": "Updated Category"}

    url = reverse(
        "category-detail", kwargs={"pk": category.pk}
    )  # Update with your correct URL name
    response = api_client.put(url, updated_data, format="json")

    # Check if the category is updated correctly
    assert response.status_code == status.HTTP_200_OK
    assert response.data["slug"] == updated_data["slug"]
    assert response.data["verbose_label"] == updated_data["verbose_label"]


@pytest.mark.django_db
def test_category_delete(api_client):
    # Create a category instance to be deleted
    category = CategoryFactory()

    url = reverse(
        "category-detail", kwargs={"pk": category.pk}
    )  # Update with your correct URL name
    response = api_client.delete(url)

    # Check if the category is deleted
    assert response.status_code == status.HTTP_204_NO_CONTENT

    # Check if the category no longer exists
    assert not Category.objects.filter(pk=category.pk).exists()
