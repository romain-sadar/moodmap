import factory
from django.utils.timezone import now
from api.models import (
    User,
    Mood,
    Place,
    VisitedPlace,
    FavouritePlace,
    Category,
    MoodEntry,
    FeelingTag,
    Activity,
    ActivityCategory,
    FavouriteActivity,
)


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


class FeelingTagFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = FeelingTag

    label = factory.Faker("pystr")


class MoodEntryFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = MoodEntry

    user = factory.SubFactory(UserFactory)
    mood = factory.SubFactory(MoodFactory)
    move_preference = factory.Iterator(["yes", "no"])
    submitted_at = factory.LazyFunction(now)


class PlaceFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Place

    label = factory.Faker("word")
    latitude = factory.Faker("latitude")
    longitude = factory.Faker("longitude")
    description = factory.Faker("paragraph")
    category = factory.SubFactory("api.tests.factories.CategoryFactory")
    photo = factory.Faker("image_url")

    @factory.post_generation
    def moods(self, create, extracted, **kwargs):
        if not create:
            return
        if extracted:
            self.moods.set(extracted)
        else:
            self.moods.set([MoodFactory.create() for _ in range(2)])


class VisitedPlaceFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = VisitedPlace

    user = factory.SubFactory("api.tests.factories.UserFactory")
    place = factory.SubFactory("api.tests.factories.PlaceFactory")
    visited_time = factory.Faker("date_time_this_year")
    mood_feedback = factory.SubFactory("api.tests.factories.MoodFactory")


class FavouritePlaceFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = FavouritePlace

    user = factory.SubFactory("api.tests.factories.UserFactory")
    place = factory.SubFactory("api.tests.factories.PlaceFactory")
    added_at = factory.Faker("date_time_this_year")


class CategoryFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Category

    slug = factory.Faker("slug")
    verbose_label = factory.Faker("word")


class ActivityFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Activity

    name = factory.Faker("word")
    description = factory.Faker("paragraph")
    category = factory.SubFactory("api.tests.factories.ActivityCategoryFactory")


class ActivityCategoryFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = ActivityCategory

    slug = factory.Faker("slug")
    verbose_label = factory.Faker("word")


class FavouriteActivityFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = FavouriteActivity

    user = factory.SubFactory("api.tests.factories.UserFactory")
    activity = factory.SubFactory("api.tests.factories.ActivityFactory")
    added_at = factory.Faker("date_time_this_year")
