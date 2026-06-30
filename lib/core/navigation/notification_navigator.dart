import 'package:flutter/material.dart';

import 'app_link_navigator.dart';

/// Ключ корневого навигатора для deep-link из уведомлений и App Links.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Открыть экран по payload локального уведомления.
void navigateFromNotificationPayload(String? payload) =>
    dispatchNotificationPayload(payload);
