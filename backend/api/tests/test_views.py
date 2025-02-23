from datetime import timezone
import pytest
from api.models import Activity, FavouritePlace, Category, MoodEntry, ActivityCategory
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.exceptions import ErrorDetail
from api.tests.factories import (
    FeelingTagFactory,
    UserFactory,
    MoodFactory,
    MoodEntryFactory,
    PlaceFactory,
    VisitedPlaceFactory,
    FavouritePlaceFactory,
    CategoryFactory,
    ActivityFactory,
    ActivityCategoryFactory,
    FavouriteActivityFactory,
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


@pytest.mark.django_db
class TestMoodEntryViewSet:
    def test_create_mood_entry(self, api_client):
        """Test creating a new mood entry via API."""
        user = UserFactory()
        mood = MoodFactory()

        api_client.force_authenticate(user=user)
        url = reverse("moodentry-list")

        payload = {
            "user": user.id,
            "mood": mood.id,
            "move_preference": "yes",
        }

        response = api_client.post(url, payload, format="json")

        assert response.status_code == status.HTTP_201_CREATED
        assert MoodEntry.objects.count() == 1
        assert MoodEntry.objects.first().user == user

    def test_list_mood_entries(self, api_client):
        """Test listing all mood entries."""
        user = UserFactory()
        mood = MoodFactory()
        feelings = FeelingTagFactory.create_batch(2)
        mood_entry = MoodEntryFactory.create(user=user, mood=mood)
        mood_entry.feelings.set(feelings)

        api_client.force_authenticate(user=user)
        url = reverse("moodentry-list")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert len(response.json()["results"]) == 1
        assert "feelings" in response.json()["results"][0]

    def test_retrieve_mood_entry(self, api_client):
        """Test retrieving a single mood entry."""
        entry = MoodEntryFactory()

        api_client.force_authenticate(user=entry.user)
        url = reverse("moodentry-detail", args=[entry.id])

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert response.json()["id"] == str(entry.id)

    def test_delete_mood_entry(self, api_client):
        """Test deleting a mood entry."""
        entry = MoodEntryFactory()

        api_client.force_authenticate(user=entry.user)
        url = reverse("moodentry-detail", args=[entry.id])

        response = api_client.delete(url)

        assert response.status_code == status.HTTP_204_NO_CONTENT
        assert MoodEntry.objects.count() == 0


@pytest.mark.django_db
class TestActivityCategoryViewSet:
    def test_create_activity_category(self, api_client):
        """Test creating a new activity category via API."""
        user = UserFactory()

        api_client.force_authenticate(user=user)
        url = reverse("activity-category-list")

        data = {
            "slug": "adventure",
            "verbose_label": "Adventure Activities",
        }

        response = api_client.post(url, data, format="json")

        assert response.status_code == status.HTTP_201_CREATED
        assert ActivityCategory.objects.count() == 1
        assert response.data["slug"] == data["slug"]
        assert response.data["verbose_label"] == data["verbose_label"]

    def test_list_activity_categories(self, api_client):
        """Test listing all activity categories."""
        user = UserFactory()
        ActivityCategoryFactory.create_batch(3)

        api_client.force_authenticate(user=user)
        url = reverse("activity-category-list")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert len(response.data["results"]) == 3

    def test_retrieve_activity_category(self, api_client):
        """Test retrieving a single activity category."""
        category = ActivityCategoryFactory()

        user = UserFactory()
        api_client.force_authenticate(user=user)
        url = reverse("activity-category-detail", kwargs={"pk": category.pk})

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert response.data["slug"] == category.slug
        assert response.data["verbose_label"] == category.verbose_label

    def test_update_activity_category(self, api_client):
        """Test updating an activity category."""
        category = ActivityCategoryFactory()

        user = UserFactory()
        api_client.force_authenticate(user=user)
        url = reverse("activity-category-detail", kwargs={"pk": category.pk})
        updated_data = {
            "slug": "updated-adventure",
            "verbose_label": "Updated Adventure Activities",
        }

        response = api_client.put(url, updated_data, format="json")

        assert response.status_code == status.HTTP_200_OK
        assert response.data["slug"] == updated_data["slug"]
        assert response.data["verbose_label"] == updated_data["verbose_label"]

    def test_delete_activity_category(self, api_client):
        """Test deleting an activity category."""
        category = ActivityCategoryFactory()

        user = UserFactory()
        api_client.force_authenticate(user=user)
        url = reverse("activity-category-detail", kwargs={"pk": category.pk})
        response = api_client.delete(url)

        assert response.status_code == status.HTTP_204_NO_CONTENT
        assert not ActivityCategory.objects.filter(pk=category.pk).exists()


@pytest.mark.django_db
class TestActivityViewSet:
    def test_create_activity(self, api_client):
        """Test creating a new activity via API."""
        user = UserFactory()
        category = ActivityCategoryFactory()
        moods = MoodFactory.create_batch(2)  # Create some moods for the activity

        api_client.force_authenticate(user=user)
        url = reverse("activity-list")

        data = {
            "name": "Skydiving",
            "description": "Jump from an airplane",
            "category": category.id,
            "moods": [mood.id for mood in moods],
        }

        response = api_client.post(url, data, format="json")
        print(response.data)

        assert response.status_code == status.HTTP_201_CREATED
        assert Activity.objects.count() == 1
        assert response.data["name"] == data["name"]
        assert response.data["description"] == data["description"]
        assert response.data["category"] == category.id

    def test_list_activities(self, api_client):
        """Test listing all activities."""
        user = UserFactory()
        category = ActivityCategoryFactory()
        ActivityFactory.create_batch(3, category=category)

        api_client.force_authenticate(user=user)
        url = reverse("activity-list")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert len(response.data["results"]) == 3

    def test_retrieve_activity(self, api_client):
        """Test retrieving a single activity."""
        activity = ActivityFactory()

        url = reverse("activity-detail", kwargs={"pk": activity.pk})

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert response.data["name"] == activity.name
        assert response.data["description"] == activity.description
        assert response.data["category"] == activity.category.id

    def test_update_activity(self, api_client):
        """Test updating an activity."""
        # Create an activity and some moods
        activity = ActivityFactory()
        moods = MoodFactory.create_batch(2)  # Create 2 moods for the activity

        # Prepare the updated data, including the `moods` field
        updated_data = {
            "name": "Bungee Jumping",
            "description": "Jump off a bridge with a bungee cord",
            "category": activity.category.id,
            "moods": [mood.id for mood in moods],  # Include the moods in the update
        }

        # Get the URL for the activity detail view
        url = reverse("activity-detail", kwargs={"pk": activity.pk})

        # Send a PUT request to update the activity
        response = api_client.put(url, updated_data, format="json")

        # Assert the response status code and data
        assert response.status_code == status.HTTP_200_OK
        assert response.data["name"] == updated_data["name"]
        assert response.data["description"] == updated_data["description"]
        assert response.data["category"] == activity.category.id
        assert len(response.data["moods"]) == 2  # Ensure the moods are updated

    def test_delete_activity(self, api_client):
        """Test deleting an activity."""
        activity = ActivityFactory()

        url = reverse("activity-detail", kwargs={"pk": activity.pk})

        response = api_client.delete(url)

        assert response.status_code == status.HTTP_204_NO_CONTENT
        assert not Activity.objects.filter(pk=activity.pk).exists()


@pytest.mark.django_db
class TestFavouritesGroupedByMoodViewSet:
    def test_get_grouped_favourites_success(self, api_client):
        """Test for successfully retrieving grouped favourites by mood."""
        user = UserFactory()

        category = ActivityCategoryFactory()
        activity = ActivityFactory(category=category)
        mood1 = MoodFactory(label="Happy")
        mood2 = MoodFactory(label="Excited")

        activity.moods.add(mood1, mood2)

        place1 = PlaceFactory()
        place2 = PlaceFactory()
        place1.moods.add(mood1)
        place2.moods.add(mood1, mood2)

        FavouriteActivityFactory(user=user, activity=activity)
        FavouritePlaceFactory(user=user, place=place1)
        FavouritePlaceFactory(user=user, place=place2)

        api_client.force_authenticate(user=user)

        url = reverse("favourites-grouped-by-mood")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK

        data = response.json()

        assert isinstance(data, list)
        mood_found = any(mood.get("mood") == "Happy" for mood in data)
        assert mood_found

        happy_mood = next((mood for mood in data if mood["mood"] == "Happy"), None)
        assert happy_mood is not None
        assert isinstance(happy_mood.get("places", []), list)
        assert len(happy_mood["places"]) == 2
        assert isinstance(happy_mood.get("activities", []), list)
        assert len(happy_mood["activities"]) == 1

        excited_mood = next((mood for mood in data if mood["mood"] == "Excited"), None)
        assert excited_mood is not None
        assert isinstance(excited_mood.get("places", []), list)
        assert len(excited_mood["places"]) == 1
        assert isinstance(excited_mood.get("activities", []), list)
        assert len(excited_mood["activities"]) == 1

    def test_handle_multiple_moods_for_single_item(self, api_client):
        """Test that an item with multiple moods appears in all relevant groups."""
        user = UserFactory()

        category = ActivityCategoryFactory()
        activity = ActivityFactory(category=category)
        place = PlaceFactory()

        mood1 = MoodFactory(label="Happy")
        mood2 = MoodFactory(label="Relaxed")

        activity.moods.add(mood1, mood2)
        place.moods.add(mood1, mood2)

        FavouriteActivityFactory(user=user, activity=activity)
        FavouritePlaceFactory(user=user, place=place)

        api_client.force_authenticate(user=user)

        url = reverse("favourites-grouped-by-mood")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK

        data = response.json()
        assert isinstance(data, list)
        mood_labels = [item.get("mood") for item in data]
        assert "Happy" in mood_labels
        assert "Relaxed" in mood_labels

        for mood_item in data:
            if mood_item["mood"] in ["Happy", "Relaxed"]:
                places = mood_item.get("places", [])
                assert isinstance(places, list)
                if mood_item["mood"] == "Happy":
                    assert len(places) >= 1
                if mood_item["mood"] == "Relaxed":
                    assert len(places) >= 1

                activities = mood_item.get("activities", [])
                assert isinstance(activities, list)
                if mood_item["mood"] == "Happy":
                    assert len(activities) >= 1
                if mood_item["mood"] == "Relaxed":
                    assert len(activities) >= 1

    def test_handle_no_favourites(self, api_client):
        """Test response when there are no favourite activities or places."""
        user = UserFactory()

        api_client.force_authenticate(user=user)

        url = reverse("favourites-grouped-by-mood")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert isinstance(response.json(), list)
        assert len(response.json()) == 0

    def test_unauthenticated_access(self, api_client):
        """Test that unauthenticated users cannot access the endpoint."""
        url = reverse("favourites-grouped-by-mood")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_401_UNAUTHORIZED
        assert "Authentication credentials were not provided." in str(response.data)

    def test_endpoint_returns_only_favourites(self, api_client):
        """Test that only favourite activities and places are included."""
        user = UserFactory()
        other_user = UserFactory()

        category = ActivityCategoryFactory()
        activity = ActivityFactory(category=category)
        mood = MoodFactory(label="Happy")
        activity.moods.add(mood)

        place = PlaceFactory()
        place.moods.add(mood)

        FavouriteActivityFactory(user=other_user, activity=activity)
        FavouritePlaceFactory(user=other_user, place=place)

        api_client.force_authenticate(user=user)

        url = reverse("favourites-grouped-by-mood")

        response = api_client.get(url)

        assert response.status_code == status.HTTP_200_OK
        assert isinstance(response.json(), list)
        assert len(response.json()) == 0
