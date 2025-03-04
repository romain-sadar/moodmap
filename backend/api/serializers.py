from rest_framework import serializers
from django.contrib.auth import authenticate
from api.models import (
    User,
    Mood,
    MoodEntry,
    Place,
    VisitedPlace,
    FavouritePlace,
    Category,
    FeelingTag,
    ActivityCategory,
    Activity,
    FavouriteActivity,
)


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ("username", "email", "password")
        extra_kwargs = {
            "username": {"required": True},
            "email": {"required": True},
        }

    def validate_username(self, value):
        """
        Validate that the username is unique.
        """
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError(
                "A user with this username already exists."
            )
        return value

    def validate_email(self, value):
        """
        Validate that the email is unique.
        """
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value

    def create(self, validated_data):
        """
        Create and return a new User instance.
        """
        user = User.objects.create_user(
            username=validated_data["username"],
            email=validated_data["email"],
            password=validated_data["password"],
        )
        return user


class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        email = data.get("email")
        password = data.get("password")

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise serializers.ValidationError("Invalid credentials. Please try again.")

        if not user.is_active:
            raise serializers.ValidationError("User account is not active.")

        user = authenticate(email=email, password=password)
        if not user:
            raise serializers.ValidationError("Invalid credentials. Please try again.")

        data["user"] = user
        return data


class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("username", "email", "age", "gender", "premium")

    def validate_username(self, value):
        """
        Ensure the username is unique if modified.
        """
        if User.objects.filter(username=value).exclude(id=self.instance.id).exists():
            raise serializers.ValidationError(
                "A user with this username already exists."
            )
        return value

    def validate_email(self, value):
        """
        Ensure the email is unique if modified.
        """
        if User.objects.filter(email=value).exclude(id=self.instance.id).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
            "id",
            "username",
            "email",
            "premium",
            "gender",
            "age",
            "created_at",
            "updated_at",
        )
        read_only_fields = ("id", "created_at", "updated_at")


class MoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Mood
        fields = ("label",)


class FeelingTagSerializer(serializers.ModelSerializer):
    class Meta:
        model = FeelingTag
        fields = ["id", "label"]


class MoodEntrySerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    mood = serializers.PrimaryKeyRelatedField(queryset=Mood.objects.all())
    feelings = FeelingTagSerializer(many=True, required=False)

    class Meta:
        model = MoodEntry
        fields = [
            "id",
            "user",
            "mood",
            "feelings",
            "move_preference",
            "submitted_at",
        ]


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ("slug", "verbose_label")


class PlaceSerializer(serializers.ModelSerializer):
    category = serializers.SlugRelatedField(
        queryset=Category.objects.all(), slug_field="slug"
    )
    moods = serializers.SlugRelatedField(
        queryset=Mood.objects.all(), slug_field="label", many=True
    )

    class Meta:
        model = Place
        fields = (
            "label",
            "latitude",
            "longitude",
            "description",
            "category",
            "photo",
            "moods",
            "created_at",
            "updated_at",
        )


class VisitedPlaceSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    place = serializers.PrimaryKeyRelatedField(queryset=Place.objects.all())
    mood_feedback = serializers.PrimaryKeyRelatedField(
        queryset=Mood.objects.all(), required=False
    )

    class Meta:
        model = VisitedPlace
        fields = ("user", "place", "visited_time", "mood_feedback")


class FavouritePlaceSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    place = serializers.PrimaryKeyRelatedField(queryset=Place.objects.all())

    class Meta:
        model = FavouritePlace
        fields = ("user", "place", "added_at")


class ActivitySerializer(serializers.ModelSerializer):
    category = serializers.PrimaryKeyRelatedField(
        queryset=ActivityCategory.objects.all()
    )
    moods = serializers.PrimaryKeyRelatedField(queryset=Mood.objects.all(), many=True)

    class Meta:
        model = Activity
        fields = ("id", "name", "description", "category", "moods", "duration", "image")
        read_only_fields = ("id",)

    def validate_name(self, value):
        """
        Ensure the activity name is unique.
        """
        if Activity.objects.filter(name=value).exists():
            raise serializers.ValidationError(
                "An activity with this name already exists."
            )
        return value


class ActivityCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivityCategory
        fields = ("slug", "verbose_label")

    def validate_slug(self, value):
        """
        Ensure the slug is unique.
        """
        if ActivityCategory.objects.filter(slug=value).exists():
            raise serializers.ValidationError(
                "A category with this slug already exists."
            )
        return value


class FavouriteActivitySerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    activity = serializers.PrimaryKeyRelatedField(queryset=Activity.objects.all())

    class Meta:
        model = FavouriteActivity
        fields = ("user", "activity", "added_at")


class FavouritesGroupedByMoodSerializer(serializers.Serializer):
    mood = serializers.CharField()
    places = serializers.SerializerMethodField()
    activities = serializers.SerializerMethodField()

    def get_places(self, obj):
        place_serializer = PlaceSerializer(obj["places"], many=True)
        return place_serializer.data

    def get_activities(self, obj):
        activity_serializer = ActivitySerializer(obj["activities"], many=True)
        return activity_serializer.data
