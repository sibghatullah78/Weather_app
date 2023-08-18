import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'additional_information.dart';
import 'hourlyforecaster.dart';
import 'package:http/http.dart' as http;
import 'secret.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});
  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Haripur';
    try {
      final resp = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$apiKey'),
      );
      final jsondata = jsonDecode(resp.body);
      //  temp =jsondata['list'][0]['main']['temo'];
      if (jsondata['cod'] != '200') {
        throw 'an error occured';
      }
      return jsondata;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              // Add your refresh logic here
            },
          ),
          //gesture can also be used here
          // we also have ink well but it have less properties but gives splash
          //effect
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(), //we can also have variable here that 
        //we can sue the here and in set state method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final jsondata = snapshot.data!;
          final select = jsondata['list'][0];
          double currenttemp = select['main']['temp'];
          double kelvinToCelsius(double kelvin) {
            return kelvin - 273.15;
          }

          currenttemp = kelvinToCelsius(currenttemp);
          dynamic celsi = currenttemp.toStringAsFixed(3);
          final currentsky = select['weather'][0]['main'];
          final currentpressure = select['main']['pressure'];
          final currenthumidity = select['main']['humidity'];
          final currentwindspeed = select['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //we cannot use container reason is that doesnot have elevation property
              //so for that i will use card widghet but for covering
              //wholespace i am gonna use wraping of container
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    //backdrop filter is available for giving blurring and shadow to
                    //the background also cliprrect for giving

                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            '$celsi C',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          Icon(
                            currentsky == 'Cloud' || currentsky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 60,
                          ),
                          Text(
                            currentsky,
                            style: const TextStyle(fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //container also has alignment property but allign widget also has
                //allignment property in all direction
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                const SizedBox(
                  height: 6,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       //the problem is that we are creating
                //       //all widget in atonce which is causing performance
                //       //issue now for that i will use list builder
                //       for (int i = 0; i < 39; i++)  //no need to mention
                //       //the {} in flutter code if you have more than
                //       //one widget you can use ...[,,]
                //         HourlyForecaster(
                //           time: jsondata['list'][i + 1]['dt'].toString(),
                //           icon: jsondata['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   jsondata['list'][i + 1]['weather'][0]
                //                           ['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temp: jsondata['list'][i + 1]['main']['temp']
                //               .toString(),
                //         ),
                //     ],
                //
                // ),
                //sized box is used for lsitview buider because listview and text has
                //tendency to use the full screen so for that we are restricting it

                SizedBox(
                  height: 150,
                  //max line we can assign to text ,
                  //we also have textoverflow.clip if it
                  //exceed that we have ........
                  child: ListView.builder(
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final time = DateTime.parse(
                            jsondata['list'][index + 1]['dt_txt'].toString());
                        return HourlyForecaster(
                          temp: jsondata['list'][index + 1]['main']['temp']
                              .toString(),
                          icon: jsondata['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      'Clouds' ||
                                  jsondata['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          // temp: DateFormat.j().format(time),
                          time: DateFormat('h a').format(time),
                        );
                      }),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'Additional information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currenthumidity.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind speed',
                      value: currentwindspeed.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentpressure.toString(),
                    ),
                  ],
                ),
              ], //column']'.
            ),
          );
        },
      ), // scafold';'.
    );
  }
}
