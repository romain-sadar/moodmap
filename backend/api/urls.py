from django.urls import path, include
from rest_framework.routers import DefaultRouter
from api.views import (
    AuthViewSet,
    MoodViewSet,
    MoodEntryViewSet,
    PlaceViewSet,
    VisitedPlaceViewSet,
    FavouritePlaceViewSet,
    CategoryViewSet,
    ActivityViewSet,
    ActivityCategoryViewSet,
    FavouritesGroupedByMoodViewSet,
)

router = DefaultRouter()
router.register(r"auth", AuthViewSet, basename="auth")
router.register(r"mood", MoodViewSet, basename="mood")
router.register(r"moodentry", MoodEntryViewSet, basename="moodentry")
router.register(r"place", PlaceViewSet, basename="place")
router.register(r"visited-place", VisitedPlaceViewSet, basename="visited-place")
router.register(r"favourite-place", FavouritePlaceViewSet, basename="favourite-place")
router.register(r"category", CategoryViewSet, basename="category")
router.register(r"activity", ActivityViewSet, basename="activity")
router.register(
    r"activity-category", ActivityCategoryViewSet, basename="activity-category"
)

urlpatterns = [
    path("", include(router.urls)),
    path(
        "favourites/grouped-by-mood/",
        FavouritesGroupedByMoodViewSet.as_view({"get": "list"}),
        name="favourites-grouped-by-mood",
    ),
]
