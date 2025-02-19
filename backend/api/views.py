from rest_framework import viewsets, status
from api.serializers import (
    UserRegistrationSerializer,
    UserLoginSerializer,
    UserUpdateSerializer,
    UserSerializer,
    MoodSerializer,
    MoodEntrySerializer,
    PlaceSerializer,
    VisitedPlaceSerializer,
    FavouritePlaceSerializer,
    CategorySerializer,
)
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import action
from api.models import Mood, Place, VisitedPlace, FavouritePlace, Category, MoodEntry


class AuthViewSet(viewsets.GenericViewSet):
    """
    A ViewSet that handles user registration, login, and profile updates.
    """

    @action(detail=False, methods=["post"], url_path="register")
    def register(self, request):
        """
        Handles user registration.
        """
        self.serializer_class = UserRegistrationSerializer
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            # Use UserSerializer to return the registered user's data
            return Response(
                {
                    "message": "User registered successfully",
                    "user": UserSerializer(user).data,
                },
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=["post"], url_path="login")
    def login(self, request):
        """
        Handles user login and returns JWT tokens.
        """
        self.serializer_class = UserLoginSerializer
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.validated_data["user"]

            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)

            return Response(
                {
                    "message": "Login successful",
                    "user": UserSerializer(user).data,  # Use UserSerializer here
                    "tokens": {
                        "refresh": str(refresh),
                        "access": access_token,
                    },
                },
                status=status.HTTP_200_OK,
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(
        detail=False,
        methods=["patch"],
        url_path="update-profile",
        permission_classes=[IsAuthenticated],
    )
    def update_profile(self, request):
        """
        Handles updating the user profile.
        """
        user = request.user
        serializer = UserUpdateSerializer(user, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(
                {
                    "message": "User profile updated successfully",
                    "user": serializer.data,
                },
                status=status.HTTP_200_OK,
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MoodViewSet(viewsets.ModelViewSet):
    serializer_class = MoodSerializer
    queryset = Mood.objects.all()


class MoodEntryViewSet(viewsets.ModelViewSet):
    serializer_class = MoodEntrySerializer
    queryset = MoodEntry.objects.all().select_related("user", "mood")


class PlaceViewSet(viewsets.ModelViewSet):
    """
    A ViewSet for handling Places.
    """

    serializer_class = PlaceSerializer
    queryset = Place.objects.all()

    @action(detail=True, methods=["get"], url_path="moods")
    def get_moods(self, request, pk=None):
        """
        Returns the moods associated with a place.
        """
        place = self.get_object()
        moods = place.moods.all()
        mood_serializer = MoodSerializer(moods, many=True)
        return Response(mood_serializer.data)


class VisitedPlaceViewSet(viewsets.ModelViewSet):
    """
    A ViewSet for handling VisitedPlaces.
    """

    serializer_class = VisitedPlaceSerializer
    queryset = VisitedPlace.objects.all()


class FavouritePlaceViewSet(viewsets.ModelViewSet):
    """
    A ViewSet for handling FavouritePlaces.
    """

    serializer_class = FavouritePlaceSerializer
    queryset = FavouritePlace.objects.all()

    def list(self, request, *args, **kwargs):
        user = request.user
        favourite_places = FavouritePlace.objects.filter(user=user).select_related(
            "place__category"
        )

        grouped_places = {}
        for fav in favourite_places:
            category = fav.place.category.verbose_label
            if category not in grouped_places:
                grouped_places[category] = []
            grouped_places[category].append(fav.place)

        grouped_places_serialized = {
            category: PlaceSerializer(places, many=True).data
            for category, places in grouped_places.items()
        }

        return Response(grouped_places_serialized)


class CategoryViewSet(viewsets.ModelViewSet):
    """
    A ViewSet for handling Categories.
    """

    serializer_class = CategorySerializer
    queryset = Category.objects.all()
