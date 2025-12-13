import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// An extension on [AppUserRole] to provide UI-related helpers.
extension AppUserRoleUI on AppUserRole {
  /// A convenience getter to check if the user role is premium.
  bool get isPremium => this == AppUserRole.premiumUser;

  /// Returns a premium indicator icon if the user is a premium user.
  ///
  /// Returns a gold star icon for premium users, otherwise returns null.
  Widget? get premiumIcon {
    if (isPremium) {
      return const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.star, color: Colors.amber, size: 16),
      );
    }
    return null;
  }
}
