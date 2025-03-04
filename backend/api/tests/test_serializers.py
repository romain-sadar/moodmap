import pytest
from django.contrib.auth import get_user_model
from api.tests.factories import (
    ActivityFactory,
    PlaceFactory,
    UserFactory,
    CategoryFactory,
    MoodFactory,
    ActivityCategoryFactory,
)
from django.core.files.uploadedfile import SimpleUploadedFile
from api.serializers import (
    PlaceSerializer,
    UserRegistrationSerializer,
    VisitedPlaceSerializer,
    FavouritePlaceSerializer,
    CategorySerializer,
    MoodSerializer,
    ActivitySerializer,
    ActivityCategorySerializer,
)
from io import BytesIO
from PIL import Image

User = get_user_model()


@pytest.mark.django_db
def test_user_registration_serializer_valid_data():
    data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "testpassword123",
    }
    serializer = UserRegistrationSerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    user = serializer.save()
    assert user.username == "testuser"
    assert user.email == "test@example.com"


@pytest.mark.django_db
def test_user_registration_serializer_duplicate_email():
    UserFactory(email="duplicate@example.com")
    data = {
        "username": "testuser",
        "email": "duplicate@example.com",
        "password": "testpassword123",
    }
    serializer = UserRegistrationSerializer(data=data)
    assert not serializer.is_valid()
    assert "email" in serializer.errors


@pytest.mark.django_db
def test_mood_serializer_valid_data():
    data = {"label": "Happy"}
    serializer = MoodSerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    mood = serializer.save()
    assert mood.label == "Happy"


@pytest.mark.django_db
def test_mood_serializer_blank_label():
    data = {"label": ""}
    serializer = MoodSerializer(data=data)
    assert serializer.is_valid(), (
        serializer.errors
    )  # Should be valid since label is nullable/blank


@pytest.mark.django_db
def test_mood_serializer_missing_label():
    data = {}  # No label provided
    serializer = MoodSerializer(data=data)
    assert serializer.is_valid(), (
        serializer.errors
    )  # Should be valid due to `null=True, blank=True`


@pytest.mark.django_db
def test_place_serializer_valid_data():
    category = CategoryFactory()  # Ensure there's a category for the place

    # Create the required moods in the database
    mood_happy = MoodFactory(label="Happy")
    mood_relaxed = MoodFactory(label="Relaxed")

    # Create a valid image using BytesIO and PIL
    image_file = BytesIO()
    image = Image.new("RGB", (100, 100), color="red")  # Create a 100x100 red image
    image.save(image_file, "JPEG")
    image_file.name = "park.jpg"
    image_file.seek(0)  # Reset the file pointer to the beginning
    photo = SimpleUploadedFile("park.jpg", image_file.read(), content_type="image/jpeg")

    data = {
        "label": "Park",
        "latitude": 40.7128,
        "longitude": -74.0060,
        "description": "A beautiful park in the city",
        "category": category.slug,
        "photo": photo,
        "moods": [mood_happy.label, mood_relaxed.label],  # Use the labels of the moods
    }

    serializer = PlaceSerializer(data=data)

    # Validate the serializer
    assert serializer.is_valid(), serializer.errors
    place = serializer.save()

    # Assert the fields are correct
    assert place.label == "Park"
    assert place.latitude == 40.7128
    assert place.category.slug == category.slug
    assert place.moods.count() == 2  # Check that two moods are assigned


@pytest.mark.django_db
def test_visited_place_serializer_valid_data():
    place = PlaceFactory()
    user = UserFactory()
    mood = MoodFactory()

    data = {
        "user": user.id,
        "place": place.id,
        "visited_time": "2025-02-18T10:00:00Z",
        "mood_feedback": mood.id,
    }
    serializer = VisitedPlaceSerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    visited_place = serializer.save()
    assert visited_place.user == user
    assert visited_place.place == place
    assert visited_place.mood_feedback == mood


@pytest.mark.django_db
def test_favourite_place_serializer_valid_data():
    place = PlaceFactory()
    user = UserFactory()
    data = {
        "user": user.id,
        "place": place.id,
        "added_at": "2025-02-18T10:00:00Z",
    }
    serializer = FavouritePlaceSerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    favourite_place = serializer.save()
    assert favourite_place.user == user
    assert favourite_place.place == place


@pytest.mark.django_db
def test_category_serializer_valid_data():
    data = {
        "slug": "historical-sites",
        "verbose_label": "Historical Sites",
    }
    serializer = CategorySerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    category = serializer.save()
    assert category.slug == "historical-sites"
    assert category.verbose_label == "Historical Sites"


@pytest.mark.django_db
def test_category_serializer_duplicate_slug():
    CategoryFactory(slug="duplicate-slug")
    data = {
        "slug": "duplicate-slug",
        "verbose_label": "Duplicate Category",
    }
    serializer = CategorySerializer(data=data)
    assert not serializer.is_valid()
    assert "slug" in serializer.errors


@pytest.mark.django_db
def test_activity_category_serializer_valid_data():
    """Test ActivityCategorySerializer with valid data."""
    data = {
        "slug": "adventure",
        "verbose_label": "Adventure Activities",
    }
    serializer = ActivityCategorySerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    category = serializer.save()
    assert category.slug == "adventure"
    assert category.verbose_label == "Adventure Activities"


@pytest.mark.django_db
def test_activity_category_serializer_duplicate_slug():
    """Test ActivityCategorySerializer with a duplicate slug."""
    ActivityCategoryFactory(slug="duplicate-slug")
    data = {
        "slug": "duplicate-slug",
        "verbose_label": "Duplicate Category",
    }
    serializer = ActivityCategorySerializer(data=data)
    assert not serializer.is_valid()
    assert "slug" in serializer.errors


@pytest.mark.django_db
def test_activity_category_serializer_missing_fields():
    """Test ActivityCategorySerializer with missing required fields."""
    data = {}  # Missing slug and verbose_label
    serializer = ActivityCategorySerializer(data=data)
    assert not serializer.is_valid()
    assert "slug" in serializer.errors
    assert "verbose_label" in serializer.errors


@pytest.mark.django_db
def test_activity_serializer_valid_data():
    """Test ActivitySerializer with valid data."""
    category = ActivityCategoryFactory()
    moods = MoodFactory.create_batch(2)  # Create 2 moods for the activity

    data = {
        "name": "Skydiving",
        "description": "Jump from an airplane",
        "category": category.id,
        "moods": [mood.id for mood in moods],  # Include moods
    }
    serializer = ActivitySerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    activity = serializer.save()
    assert activity.name == "Skydiving"
    assert activity.description == "Jump from an airplane"
    assert activity.category == category
    assert activity.moods.count() == 2  # Ensure moods are assigned


@pytest.mark.django_db
def test_activity_serializer_missing_required_fields():
    """Test ActivitySerializer with missing required fields."""
    data = {}  # Missing name, category, and moods
    serializer = ActivitySerializer(data=data)
    assert not serializer.is_valid()
    assert "name" in serializer.errors
    assert "category" in serializer.errors
    assert "moods" in serializer.errors


@pytest.mark.django_db
def test_activity_serializer_duplicate_name():
    """Test ActivitySerializer with a duplicate name."""
    activity = ActivityFactory(name="Skydiving")
    data = {
        "name": "Skydiving",  # Duplicate name
        "description": "Jump from an airplane",
        "category": activity.category.id,
        "moods": [MoodFactory().id],  # Include at least one mood
    }
    serializer = ActivitySerializer(data=data)
    assert not serializer.is_valid()
    assert "name" in serializer.errors


@pytest.mark.django_db
def test_activity_serializer_invalid_category():
    """Test ActivitySerializer with an invalid category ID."""
    invalid_category_id = "00000000-0000-0000-0000-000000000000"  # Invalid UUID
    data = {
        "name": "Skydiving",
        "description": "Jump from an airplane",
        "category": invalid_category_id,
        "moods": [MoodFactory().id],  # Include at least one mood
    }
    serializer = ActivitySerializer(data=data)
    assert not serializer.is_valid()
    assert "category" in serializer.errors


@pytest.mark.django_db
def test_activity_serializer_invalid_moods():
    """Test ActivitySerializer with invalid mood IDs."""
    invalid_mood_id = "00000000-0000-0000-0000-000000000000"  # Invalid UUID
    data = {
        "name": "Skydiving",
        "description": "Jump from an airplane",
        "category": ActivityCategoryFactory().id,
        "moods": [invalid_mood_id],  # Invalid mood ID
    }
    serializer = ActivitySerializer(data=data)
    assert not serializer.is_valid()
    assert "moods" in serializer.errors
