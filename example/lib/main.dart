import 'package:easy_event_bus/easy_event_bus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final String _eventId = 'uniqueEvent';
  final String _subscriptionId = 'uniqueSubscriptionId';

  // Subscribe without an ID
  void _subscribeEvent() {
    EasyEventBus.on(_eventId, (event) {
      print('General Subscription: Event received: $event');
    });
  }

  // Subscribe with an ID
  void _subscribeEventWithId() {
    EasyEventBus.on(_eventId, (event) {
      print('Subscription with ID ($_subscriptionId): Event received: $event');
    }, id: _subscriptionId);
  }

  void _fireEvent() {
    EasyEventBus.fire(_eventId, 'Hello from EventBus!');
  }

  void _cancelSpecificSubscription() {
    EasyEventBus.cancel(_eventId, id: _subscriptionId);
  }

  void _cancelSubscriptionWithoutId() {
    // This will cancel all subscriptions for the event, including those with an ID
    EasyEventBus.cancel(_eventId);
  }

  void _cancelAllSubscriptions() {
    EasyEventBus.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EasyEventBus Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _subscribeEvent,
                child: const Text('Subscribe to Event'),
              ),
              ElevatedButton(
                onPressed: _subscribeEventWithId,
                child: const Text('Subscribe to Event With ID'),
              ),
              ElevatedButton(
                onPressed: _fireEvent,
                child: const Text('Fire Event'),
              ),
              ElevatedButton(
                onPressed: _cancelSpecificSubscription,
                child: const Text('Cancel Specific Subscription With ID'),
              ),
              ElevatedButton(
                onPressed: _cancelSubscriptionWithoutId,
                child: const Text('Cancel Subscription'),
              ),
              ElevatedButton(
                onPressed: _cancelAllSubscriptions,
                child: const Text('Cancel All Subscriptions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
