import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants/app_themes.dart';
import 'package:weather_app/screens/weekly_forecast.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  String city = "Thimi";
  String country = '';
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getPastSevenDaysWeather(city);
      setState(() {
        currentValue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7days = [];
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "City not found or invalid. Please enter a valid city name.",
          ),
        ),
      );
    }
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    String iconPath = currentValue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : "";
    Widget imageWidgets = imageUrl.isNotEmpty
        ? Image.network(imageUrl, height: 200, width: 200, fit: BoxFit.cover)
        : SizedBox();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actions: [
          SizedBox(
            width: 350,
            height: 50,
            child: TextField(
              style: TextStyle(color: AppColors.secondary),
              onSubmitted: (value) {
                if (value.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a city name.")),
                  );
                  return;
                }
                city = value.trim();
                _fetchWeather();
              },
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: "Search City",
                hintStyle: TextStyle(color: AppColors.secondary, fontSize: 16),
                prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ),
          SizedBox(width: 25),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (currentValue.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$city${country.isNotEmpty ? ', $country' : ''}",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 38,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "${currentValue['temp_c']}°C",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 46,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "${currentValue['condition']['text']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    imageWidgets,
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        height: 100,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary,
                              offset: Offset(0, 0),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/256/4148/4148460.png",
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  "${currentValue['humidity']}%",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Humidity",
                                  style: TextStyle(color: AppColors.secondary),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/5918/5918654.png",
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  "${currentValue['wind_kph']} kph",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Wind",
                                  style: TextStyle(color: AppColors.secondary),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/6281/6281340.png",
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  "${hourly.isNotEmpty ? hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b) : "N/A"}",
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Max Temp",
                                  style: TextStyle(color: AppColors.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 250,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.primary),
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today Forecast",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeeklyForecast(
                                          city: city,
                                          currentValue: currentValue,
                                          pastWeek: pastWeek,
                                          next7days: next7days
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Weekly Forecast",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: AppColors.primary),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: hourly.length,
                              itemBuilder: (context, index) {
                                final hour = hourly[index];
                                final now = DateTime.now();
                                final hourTime = DateTime.parse(hour['time']);
                                final isCurrentHour =
                                    now.hour == hourTime.hour &&
                                    now.day == hourTime.day;

                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 70,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isCurrentHour
                                          ? Colors.orangeAccent
                                          : AppColors.cards,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          isCurrentHour
                                              ? "Now"
                                              : formatTime(hour['time']),
                                          style: TextStyle(
                                            color: isCurrentHour
                                                ? AppColors.background
                                                : AppColors.primary,
                                            fontWeight: isCurrentHour
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            fontSize: isCurrentHour ? 16 : 14,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Image.network(
                                          "https:${hour['condition']?['icon']}",
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "${hour['temp_c']}°C",
                                          style: TextStyle(
                                            color: isCurrentHour
                                                ? AppColors.background
                                                : AppColors.primary,
                                            fontWeight: isCurrentHour
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }
}
