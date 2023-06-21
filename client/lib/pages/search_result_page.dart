import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/but_route.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final BusRoute route = argList[0];
    final String departureDate = argList[1];
    // final provider = Provider.of<AppDataProvider>(context);
    // Provider.of<AppDataProvider>(context).getScheduleByRouteName(
    //   route.routeName,
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Text(
            'Show results for ${route.cityFrom} to ${route.cityTo} on ${departureDate}',
            style: const TextStyle(fontSize: 20.0),
          ),
          Consumer<AppDataProvider>(
            builder: (context, provider, _) => FutureBuilder<List<BusSchedule>>(
              future: provider.getScheduleByRouteName(route.routeName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final scheduleList = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: scheduleList
                        .map((schedule) => ScheduleItemView(
                            schedule: schedule, date: departureDate))
                        .toList(),
                  );
                }
                if (snapshot.hasError) {
                  return const Text("Failed to fetch data");
                }
                return const Text("Please try again");
              },
            ),
          )
        ],
      ),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;

  ScheduleItemView({Key? key, required this.schedule, required this.date});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        routeNameSeatPlanPage,
        arguments: [schedule, date],
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(schedule.bus.busName),
              subtitle: Text(schedule.bus.busType),
              trailing: Text('$currency${schedule.ticketPrice}'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'From ${schedule.busRoute.cityFrom}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'From ${schedule.busRoute.cityTo}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Departure Time:  ${schedule.departureTime}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'Total Seats: ${schedule.bus.totalSeat}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
