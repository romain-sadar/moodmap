from rest_framework import viewsets, status
from api.serializers import (
    UserRegistrationSerializer,
    UserLoginSerializer,
    MoodSerializer,
)
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import action
from api.models import Mood


class AuthViewSet(viewsets.GenericViewSet):
    """
    A ViewSet that handles user registration and login.
    """

    serializer_class = None  # Will be set dynamically

    @action(detail=False, methods=["post"], url_path="register")
    def register(self, request):
        """
        Handles user registration.
        """
        self.serializer_class = UserRegistrationSerializer
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(
                {"message": "User registered successfully", "user_id": user.id},
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
                    "user": {
                        "id": user.id,
                        "username": user.username,
                        "email": user.email,
                    },
                    "tokens": {
                        "refresh": str(refresh),
                        "access": access_token,
                    },
                },
                status=status.HTTP_200_OK,
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MoodViewSet(viewsets.ModelViewSet):
    serializer_class = MoodSerializer
    queryset = Mood.objects.all()
