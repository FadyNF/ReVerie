//one clean place to read the signed-in user id

import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentUserService {
  CurrentUserService._();

  static String requireUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    return user.id;
  }

  static String? get userId => Supabase.instance.client.auth.currentUser?.id;
}
