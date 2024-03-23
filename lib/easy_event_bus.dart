library easy_event_bus;

import 'dart:async';

class EasyEventBus {
  static final EasyEventBus _instance = EasyEventBus._internal();
  final Map<String, StreamController<dynamic>> _eventControllers = {};
  final Map<String, List<StreamSubscription<dynamic>>> _anonymousSubscriptions = {};
  final Map<String, Map<String, StreamSubscription<dynamic>>> _identifiedSubscriptions = {};

  EasyEventBus._internal();

  static void on(String eventType, Function(dynamic event) onEvent, {String? id}) {
    var controller = _instance._eventControllers.putIfAbsent(
      eventType,
          () => StreamController<dynamic>.broadcast(),
    );

    var subscription = controller.stream.listen(onEvent);
    if (id == null) {
      _instance._anonymousSubscriptions.putIfAbsent(eventType, () => []).add(subscription);
    } else {
      var subscriptions = _instance._identifiedSubscriptions.putIfAbsent(eventType, () => {});
      subscriptions[id]?.cancel();
      subscriptions[id] = subscription;
    }
  }

  static void fire(String eventType, dynamic event) {
    _instance._eventControllers[eventType]?.add(event);
  }

  static void cancel(String eventType, {String? id}) {
    if (id == null) {
      _instance._anonymousSubscriptions[eventType]?.forEach((sub) => sub.cancel());
      _instance._anonymousSubscriptions.remove(eventType);
    } else {
      _instance._identifiedSubscriptions[eventType]?[id]?.cancel();
      _instance._identifiedSubscriptions[eventType]?.remove(id);
    }
    if ((_instance._anonymousSubscriptions[eventType]?.isEmpty ?? true) && (_instance._identifiedSubscriptions[eventType]?.isEmpty ?? true)) {
      _instance._eventControllers[eventType]?.close();
      _instance._eventControllers.remove(eventType);
    }
  }

  static void cancelAll() {
    _instance._anonymousSubscriptions.forEach((eventType, subscriptions) {
      for (var subscription in subscriptions) {
        subscription.cancel();
      }
    });
    _instance._anonymousSubscriptions.clear();

    _instance._identifiedSubscriptions.forEach((eventType, subscriptions) {
      for (var subscription in subscriptions.values) {
        subscription.cancel();
      }
    });
    _instance._identifiedSubscriptions.clear();

    for (var controller in _instance._eventControllers.values) {
      controller.close();
    }
    _instance._eventControllers.clear();
  }
}
