import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopin/apiservices/rideService/muRideServices/my_rides_service.dart';
import 'package:hopin/models/ride.dart';
import 'package:hopin/widgets/loading_widget.dart'; // import your loader

class Myrides extends StatefulWidget {
  const Myrides({super.key});

  @override
  State<Myrides> createState() => _MyridesState();
}

class _MyridesState extends State<Myrides> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Ride>> _publishedRidesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _publishedRidesFuture = fetchPublishedRides();
  }

  Future<List<Ride>> fetchPublishedRides() async {
    final service = MyRidesService();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    final response = await service.getMyPublishedRides(uid);
    print('Fetched rides count: ${response.length}');

    final rides = response.map<Ride>((json) => Ride.fromJson(json)).toList();
    print('Parsed rides count: ${rides.length}');
    return rides;
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Widget buildRideCard(Ride ride) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                ride.startLocation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.arrow_forward, size: 16),
            ),
            Expanded(
              child: Text(
                ride.endLocation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        subtitle: Text('Date: ${formatDate(ride.rideDateTime)}'),
        trailing: Text(
          ride.status.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                ride.status == RideStatus.completed
                    ? Colors.green
                    : ride.status == RideStatus.active
                    ? Colors.blue
                    : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/ride/details', arguments: ride);
        },
      ),
    );
  }

  Widget buildPublishedRidesTab() {
    return FutureBuilder<List<Ride>>(
      future: _publishedRidesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No published rides.'));
        }

        final rides = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _publishedRidesFuture = fetchPublishedRides();
            });
            await _publishedRidesFuture; // await completion so pull-to-refresh finishes
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), // Add this line

            itemCount: rides.length,
            itemBuilder: (context, index) {
              return buildRideCard(rides[index]);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('My Rides'),
              bottom: TabBar(
                unselectedLabelColor: Colors.blueGrey,
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                controller: _tabController,
                tabs: const [Tab(text: 'Published'), Tab(text: 'Scheduled')],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildPublishedRidesTab(),
                  const Center(
                    child: Text('Scheduled rides will be added here.'),
                  ), // to be implemented
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
