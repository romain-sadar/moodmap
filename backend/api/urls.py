from django.urls import path
from api.views import UserRegistrationView

urlpatterns = [
    path("register/", UserRegistrationView.as_view(), name="register"),
]
