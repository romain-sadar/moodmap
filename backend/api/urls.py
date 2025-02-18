from django.urls import path, include
from rest_framework.routers import DefaultRouter
from api.views import AuthViewSet, MoodViewSet

router = DefaultRouter()
router.register(r"auth", AuthViewSet, basename="auth")
router.register(r"mood", MoodViewSet, basename="mood")

urlpatterns = [
    path("", include(router.urls)),
]
