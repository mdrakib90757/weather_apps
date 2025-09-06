String getBackgroundForWeather(String iconCode) {
  switch (iconCode) {
    case '01d':
      return 'assets/images/sam-schooler-E9aetBe2w40-unsplash.jpg';
    case '01n':
      return 'assets/images/night_bg.jpg.jpg';

    case '02d':
    case '03d':
    case '04d':
      return 'assets/images/cloudy_bg.jpg';
    case '02n':
    case '03n':
    case '04n':
      return 'assets/images/cloudy_night_bg.jpg';

    case '09d':
    case '10d':
      return 'assets/images/rainy_bg.jpg';
    case '09n':
    case '10n':
      return 'assets/images/rainy_night_bg.jpg';

    case '11d':
    case '11n':
      return 'assets/images/thunder_bg.jpg';

    case '13d':
    case '13n':
      return 'assets/images/snowy_bg.jpg';

    case '50d':
    case '50n':
      return 'assets/images/mist_bg.jpg';

    default:
      return 'assets/images/sunny_bg.jpg';
  }
}
