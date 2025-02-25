
  String getEmojiPlaces(String category) {
    switch (category.toLowerCase()) {
      case 'café':
        return '☕';
      case 'bar':
        return '🍻';
      case 'place of worship':
        return '⛪️';
      case 'park':
        return '🌳';
      case 'gym':
        return '🏋️‍♀️';
      case 'coworking':
        return '💻';
      case 'library':
        return '📚';
      default:
        return '📍';
    }
  }
  String getEmojiActivities(String category) {
    switch (category.toLowerCase()) {
      case 'yoga':
        return '🧘';
      case 'book':
        return '📚';
      case 'exercices':
        return '💪';
      
      default:
        return '🥇';
    }
  }

