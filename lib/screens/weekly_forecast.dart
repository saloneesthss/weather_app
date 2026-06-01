import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants/app_themes.dart';

class WeeklyForecast extends StatefulWidget {
  final Map<String, dynamic> currentValue;
  final String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7days;
  WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.pastWeek,
    required this.next7days
  });

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  String formatApiData(String dataString) {
    DateTime date = DateTime.parse(dataString);
    return DateFormat('d MMMM, EEEE').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.city,
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
                      "${widget.currentValue['temp_c']}°C",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 46,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "${widget.currentValue['condition']['text']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    Image.network("https:${widget.currentValue['condition']?['icon']}",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Next 7 Days Forecast",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ...widget.next7days.map((day) {
                final data = day['date'] ?? "";
                final condition = day['day']?['condition']?['text'] ?? "";
                final icon = day['day']?['condition']?['icon'] ?? "";
                final maxTemp = day['day']?['maxtemp_c'] ?? "";
                final minTemp = day['day']?['mintemp_c'] ?? "";
                return ListTile(
                  leading: Image.network("https:$icon", width: 40),
                  title: Text(formatApiData(data),
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                  subtitle: Text("$condition $minTemp°C - $maxTemp°C",
                    style: TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                );
              }),

              SizedBox(height: 20),
              Text(
                "Previous 7 Days Forecast",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ...widget.pastWeek.map((day) {
                final forecastDay = day['forecast']?['forecastday'];
                if (forecastDay == null || forecastDay.isEmpty) {
                  return SizedBox.shrink();
                }
                final forecast = forecastDay[0];
                final data = forecast['date'] ?? "";
                final condition = forecast['day']?['condition']?['text'] ?? "";
                final icon = forecast['day']?['condition']?['icon'] ?? "";
                final maxTemp = forecast['day']?['maxtemp_c'] ?? "";
                final minTemp = forecast['day']?['mintemp_c'] ?? "";
                return ListTile(
                  leading: Image.network("https:$icon", width: 40),
                  title: Text(formatApiData(data),
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                  subtitle: Text("$condition $minTemp°C - $maxTemp°C",
                    style: TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                );
              }),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
