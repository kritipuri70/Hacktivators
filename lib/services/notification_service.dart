import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission for iOS
      await _requestPermission();

      // Get the FCM token
      await _getFCMToken();

      // Setup message handlers
      _setupMessageHandlers();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        notifyListeners();
        // TODO: Update token in Firestore if user is logged in
      });
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received foreground message: ${message.notification?.title}');
      }
      _handleForegroundMessage(message);
    });

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('App opened from background via message: ${message.notification?.title}');
      }
      _handleMessageOpenedApp(message);
    });

    // Handle messages when app is opened from terminated state
    _handleInitialMessage();
  }

  // Fixed method for handling initial message
  Future<void> _handleInitialMessage() async {
    try {
      final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        if (kDebugMode) {
          print('App opened from terminated state via message: ${initialMessage.notification?.title}');
        }
        _handleMessageOpenedApp(initialMessage);
      }
    } catch (e) {
      print('Error getting initial message: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Show in-app notification or update UI
    final notification = message.notification;
    if (notification != null) {
      // You can show a custom dialog or snackbar here
      _showInAppNotification(
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navigate to specific screen based on message data
    final data = message.data;

    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'booking':
          _navigateToBookings();
          break;
        case 'message':
          _navigateToMessages();
          break;
        default:
          _navigateToHome();
      }
    }
  }

  void _showInAppNotification({required String title, required String body}) {
    // This would typically show a custom notification widget
    // For now, we'll just print the notification
    if (kDebugMode) {
      print('In-app notification: $title - $body');
    }

    // You could emit an event here that UI widgets can listen to
    notifyListeners();
  }

  void _navigateToBookings() {
    // TODO: Implement navigation to bookings screen
    if (kDebugMode) {
      print('Navigate to bookings');
    }
  }

  void _navigateToMessages() {
    // TODO: Implement navigation to messages screen
    if (kDebugMode) {
      print('Navigate to messages');
    }
  }

  void _navigateToHome() {
    // TODO: Implement navigation to home screen
    if (kDebugMode) {
      print('Navigate to home');
    }
  }

  // Subscribe to topic (for broadcast notifications)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      print('Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      print('Error unsubscribing from topic $topic: $e');
    }
  }

  // Update FCM token in Firestore for the current user
  Future<void> updateTokenInFirestore(String userId) async {
    if (_fcmToken != null) {
      try {
        // TODO: Update FCM token in user document
        if (kDebugMode) {
          print('Updated FCM token for user $userId: $_fcmToken');
        }
      } catch (e) {
        print('Error updating FCM token in Firestore: $e');
      }
    }
  }

  // Clear notification badge (iOS)
  Future<void> clearBadge() async {
    try {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      print('Error clearing badge: $e');
    }
  }
}