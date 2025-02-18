from rest_framework import serializers
from django.contrib.auth import authenticate
from api.models import User, Mood, Place, VisitedPlace, FavouritePlace, Category


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
            "address",
            "description",
            "category",
            "photo",
            "moods",
            "created_at",
            "updated_at",
        )


class VisitedPlaceSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), many=True)
    place = serializers.PrimaryKeyRelatedField(queryset=Place.objects.all(), many=True)
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
