import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/images.dart';
import 'package:weather_app/consts/strings.dart';
import 'package:weather_app/controllers/main_controller.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.changeTheme();
              },
              icon: Icon(
                controller.isDark.value ? Icons.light_mode : Icons.dark_mode,
                color: theme.iconTheme.color,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: theme.iconTheme.color,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoaded.value == true
            ? Container(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder(
                    future: controller.getCurrentWeatherData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        CurrentWeatherData data = snapshot.data;
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data.name}"
                                  .text
                                  .uppercase
                                  .size(32)
                                  .letterSpacing(3)
                                  .color(theme.primaryColor)
                                  .fontFamily("poppins_bold")
                                  .make(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/weather/${data.weather?[0].icon}.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${data.main?.temp}$degree",
                                        style: TextStyle(
                                          fontSize: 64,
                                          fontFamily: "poppins",
                                          color: theme.iconTheme.color,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${data.weather?[0].main}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "poppins",
                                          color: theme.iconTheme.color,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.expand_less_rounded,
                                      color: theme.iconTheme.color,
                                    ),
                                    label: "${data.main?.tempMax}$degree"
                                        .text
                                        .color(theme.iconTheme.color)
                                        .make(),
                                  ),
                                  TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.expand_less_rounded,
                                      color: theme.iconTheme.color,
                                    ),
                                    label: "${data.main?.tempMin}$degree"
                                        .text
                                        .color(
                                          theme.iconTheme.color,
                                        )
                                        .make(),
                                  ),
                                ],
                              ),
                              10.heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(3, (index) {
                                  var iconList = [clouds, humidity, windspeed];
                                  var values = [
                                    "${data.clouds?.all}%",
                                    "${data.main?.humidity}%",
                                    "${data.wind?.speed} km/hr"
                                  ];

                                  return Column(
                                    children: [
                                      Image.asset(
                                        iconList[index],
                                        width: 60,
                                        height: 60,
                                      )
                                          .box
                                          .padding(const EdgeInsets.all(8))
                                          .gray200
                                          .roundedSM
                                          .make(),
                                      10.heightBox,
                                      values[index]
                                          .text
                                          .color(theme.iconTheme.color
                                              ?.withOpacity(0.7))
                                          .make(),
                                    ],
                                  );
                                }),
                              ),
                              10.heightBox,
                              const Divider(),
                              10.heightBox,
                              FutureBuilder(
                                  future: controller.getHourlyWeatherData,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      HourlyWeatherData hourlyData =
                                          snapshot.data;

                                      return SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                hourlyData.list!.length > 6
                                                    ? 6
                                                    : hourlyData.list?.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var time = DateFormat.jm().format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          hourlyData
                                                                  .list![index]
                                                                  .dt!
                                                                  .toInt() *
                                                              1000));
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                decoration: BoxDecoration(
                                                  color: Vx.gray200,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Column(
                                                  children: [
                                                    time.text.make(),
                                                    Image.asset(
                                                      "assets/weather/${hourlyData.list![index].weather?[0].icon}.png",
                                                      width: 80,
                                                    ),
                                                    "${hourlyData.list![index].main?.temp}$degree"
                                                        .text
                                                        .make(),
                                                  ],
                                                ),
                                              );
                                            }),
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                              10.heightBox,
                              const Divider(),
                              10.heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Next 4 Days"
                                      .text
                                      .semiBold
                                      .size(16)
                                      .color(theme.primaryColor)
                                      .make(),
                                  TextButton(
                                      onPressed: () {},
                                      child: "View All".text.make()),
                                ],
                              ),
                              FutureBuilder(
                                future: controller.getHourlyWeatherData, 
                                builder: (BuildContext context, AsyncSnapshot snapshot){
                                  if(snapshot.hasData){
                                    HourlyWeatherData daysData = snapshot.data;
                                    return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:  4,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var days = DateFormat("EEEE").format(
                                        DateTime.now()
                                            .add(Duration(days: index + 1)));
                                    var date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            daysData.list![(index+1)*8].dt! * 1000);
                                    var dateString =
                                        DateFormat.yMd().format(date);
                                    return Card(
                                      color: theme.cardColor,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: days.text.semiBold
                                                    .color(theme.primaryColor)
                                                    .make()),
                                                    Expanded(child: dateString.text.make()),
                                            Expanded(
                                              child: TextButton.icon(
                                                onPressed: null,
                                                icon: Image.asset(
                                                  "assets/weather/${daysData.list![(index+1)*8].weather?[0].icon}.png",
                                                  width: 40,
                                                ),
                                                label: "${daysData.list![(index+1)*8].main?.temp}$degree"
                                                    .text
                                                    .color(theme.primaryColor)
                                                    .make(),
                                              ),
                                            ),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                text: "${daysData.list![(index+1)*8].main?.tempMax}$degree /",
                                                style: TextStyle(
                                                    fontFamily: "poppins",
                                                    fontSize: 16,
                                                    color: theme.primaryColor),
                                              ),
                                              TextSpan(
                                                text: " ${daysData.list![(index+1)*8].main?.tempMin}$degree",
                                                style: TextStyle(
                                                  fontFamily: "poppins",
                                                  fontSize: 16,
                                                  color: theme.iconTheme.color,
                                                ),
                                              ),
                                            ]))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                  } return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                })
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
