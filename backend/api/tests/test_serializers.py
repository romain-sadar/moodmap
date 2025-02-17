import pytest
from django.contrib.auth import get_user_model
from api.tests.factories import UserFactory
from api.serializers import UserRegistrationSerializer

User = get_user_model()


@pytest.mark.django_db
def test_user_registration_serializer_valid_data():
    data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "testpassword123",
        "age": 30,
        "gender": "F",
    }
    serializer = UserRegistrationSerializer(data=data)
    assert serializer.is_valid(), serializer.errors
    user = serializer.save()
    assert user.username == "testuser"
    assert user.email == "test@example.com"
    assert user.age == 30
    assert user.gender == "F"


@pytest.mark.django_db
def test_user_registration_serializer_duplicate_email():
    UserFactory(email="duplicate@example.com")
    data = {
        "username": "testuser",
        "email": "duplicate@example.com",
        "password": "testpassword123",
        "age": 30,
        "gender": "M",
    }
    serializer = UserRegistrationSerializer(data=data)
    assert not serializer.is_valid()
    assert "email" in serializer.errors
