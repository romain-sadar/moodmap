import pytest
from django.contrib.auth import get_user_model
from api.tests.factories import UserFactory
from api.serializers import UserRegistrationSerializer, MoodSerializer

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
