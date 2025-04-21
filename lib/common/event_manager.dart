import 'package:event_bus/event_bus.dart';

// Create a global instance of EventBus
final EventBus eventBus = EventBus();

// Define your events
class CustomEvent {
  final String message;
  CustomEvent(this.message);
}

class AnotherEvent {
  final int value;
  AnotherEvent(this.value);
}

class EventManager {
  // Fire a custom event
  static void fireCustomEvent(String message) {
    eventBus.fire(CustomEvent(message));
  }

  // Fire another event
  static void fireAnotherEvent(int value) {
    eventBus.fire(AnotherEvent(value));
  }

  // Listen to custom events
  static void listenToCustomEvent(Function(CustomEvent) onData) {
    eventBus.on<CustomEvent>().listen(onData);
  }

  // Listen to another events
  static void listenToAnotherEvent(Function(AnotherEvent) onData) {
    eventBus.on<AnotherEvent>().listen(onData);
  }
}

//使用示例
//触发事件：
//  EventManager.fireCustomEvent('Hello EventBus!');
//  EventManager.fireAnotherEvent(42);

//监听事件：
//  EventManager.listenToCustomEvent((event) {
//    print('Received custom event: ${event.message}');
//  });

//  EventManager.listenToAnotherEvent((event) {
//    print('Received another event: ${event.value}');
//  });
