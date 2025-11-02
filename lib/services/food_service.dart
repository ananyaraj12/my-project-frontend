import 'dart:math';

class FoodService {
  static Map<String, List<Map<String, String>>> foodByCity = {
    'Paris': [
      {'name': 'Croissant', 'image': 'https://images.unsplash.com/photo-1589710751809-7e10d97f0298'},
      {'name': 'Baguette', 'image': 'https://images.unsplash.com/photo-1565958011703-44d4c2e3d61d'},
      {'name': 'Crêpe', 'image': 'https://images.unsplash.com/photo-1551024506-0bccd828d307'},
      {'name': 'Macaron', 'image': 'https://images.unsplash.com/photo-1606813909028-3d2c5bcb9e29'}
    ],
    'Delhi': [
      {'name': 'Chole Bhature', 'image': 'https://images.unsplash.com/photo-1650893195416-47bb46cd5b0e'},
      {'name': 'Butter Chicken', 'image': 'https://images.unsplash.com/photo-1617196037014-8ce5549f89bb'},
      {'name': 'Paratha', 'image': 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc'},
      {'name': 'Gulab Jamun', 'image': 'https://images.unsplash.com/photo-1668236545337-44517c55858d'}
    ],
    'Tokyo': [
      {'name': 'Sushi', 'image': 'https://images.unsplash.com/photo-1553621042-f6e147245754'},
      {'name': 'Ramen', 'image': 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092'},
      {'name': 'Tempura', 'image': 'https://images.unsplash.com/photo-1590080875839-19bb90e81a3d'},
      {'name': 'Takoyaki', 'image': 'https://images.unsplash.com/photo-1620912189860-bb06d4f8aafe'}
    ]
  };

  static List<Map<String, String>> getFoodForCity(String city) {
    return foodByCity[city] ??
        [
          {
            'name': 'No food data available',
            'image': 'https://images.unsplash.com/photo-1499028344343-cd173ffc68a9'
          }
        ];
  }

  // For fun: return a random food suggestion
  static Map<String, String> getRandomFood(String city) {
    var list = getFoodForCity(city);
    return list[Random().nextInt(list.length)];
  }
}
