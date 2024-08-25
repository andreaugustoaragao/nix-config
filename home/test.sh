#!/bin/bash

# Function to return Weather Icons symbol based on OpenWeatherMap weather condition code
get_weather_icon() {
  local condition_code=$1
  case $condition_code in
  200 | 201 | 202 | 230 | 231 | 232) echo "" ;;                   # Thunderstorm with rain
  210 | 211 | 212 | 221) echo "" ;;                               # Thunderstorm
  300 | 301 | 302 | 310 | 311 | 312 | 313 | 314 | 321) echo "" ;; # Drizzle
  500 | 501) echo "" ;;                                           # Light rain
  502 | 503 | 504) echo "" ;;                                     # Heavy rain
  511) echo "" ;;                                                 # Freezing rain
  520 | 521 | 522 | 531) echo "" ;;                               # Shower rain
  600 | 601) echo "" ;;                                           # Light/Moderate snow
  602) echo "" ;;                                                 # Heavy snow
  611 | 612) echo "" ;;                                           # Sleet
  615 | 616) echo "" ;;                                           # Rain and snow
  620 | 621 | 622) echo "" ;;                                     # Snow shower
  701) echo "" ;;                                                 # Mist
  711) echo "" ;;                                                 # Smoke
  721) echo "" ;;                                                 # Haze
  731 | 751) echo "" ;;                                           # Dust/Sand
  741) echo "" ;;                                                 # Fog
  761) echo "" ;;                                                 # Dust
  762) echo "" ;;                                                 # Volcanic ash
  771) echo "" ;;                                                 # Squall
  781) echo "" ;;                                                 # Tornado
  800) echo "" ;;                                                 # Clear sky
  801) echo "" ;;                                                 # Few clouds
  802) echo "" ;;                                                 # Scattered clouds
  803) echo "" ;;                                                 # Broken clouds
  804) echo "" ;;                                                 # Overcast clouds
  900 | 901 | 902) echo "" ;;                                     # Extreme weather
  903) echo "" ;;                                                 # Cold
  904) echo "" ;;                                                 # Hot
  905) echo "" ;;                                                 # Windy
  906) echo "" ;;                                                 # Hail
  951) echo "" ;;                                                 # Calm
  952 | 953 | 954 | 955 | 956) echo "" ;;                         # Breeze/Light/Moderate wind
  957 | 958 | 959 | 960 | 961 | 962) echo "" ;;                   # High wind/Gale/Storm/Hurricane
  *) echo "" ;;                                                   # Default: Clear sky (useful for unknown codes)
  esac
}

# Main script logic
if [ -z "$1" ]; then
  echo "Usage: $0 <weather_condition_code>"
  exit 1
fi

weather_code=$1
weather_icon=$(get_weather_icon $weather_code)

echo "$weather_icon"
