import csv
import os
from django.core.management.base import BaseCommand
from api.models import Place, Category, Mood


class Command(BaseCommand):
    help = "Import places from a CSV file"

    def add_arguments(self, parser):
        parser.add_argument("file_path", type=str, help="Path to the CSV file")

    def handle(self, *args, **kwargs):
        file_path = kwargs["file_path"]

        if not os.path.exists(file_path):
            self.stderr.write(self.style.ERROR(f"File not found: {file_path}"))
            return

        with open(file_path, newline="", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                category, _ = Category.objects.get_or_create(
                    slug=row["category"].lower(),
                    defaults={"verbose_label": row["category"]},
                )

                place = Place.objects.create(
                    label=row["label"],
                    latitude=row["latitude"],
                    longitude=row["longitude"],
                    description=row.get("description", ""),
                    category=category,
                )

                if row.get("mood"):
                    mood, _ = Mood.objects.get_or_create(label=row["mood"])
                    place.moods.add(mood)

                self.stdout.write(self.style.SUCCESS(f"Imported: {place.label}"))

        self.stdout.write(self.style.SUCCESS("Import completed successfully!"))
