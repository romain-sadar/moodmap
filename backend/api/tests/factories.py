import factory
from api.models import User, Mood


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User

    username = factory.Sequence(lambda n: f"user{n}")
    email = factory.Sequence(lambda n: f"user{n}@example.com")
    password = factory.PostGenerationMethodCall("set_password", "testpassword123")
    age = 25
    gender = "M"
    premium = False


class MoodFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Mood

    label = factory.Faker("pystr")
