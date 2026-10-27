class AppRoutes {
  const AppRoutes._();
  // Route Names
  static const String root = 'root';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String stateWithMe = 'state-with-me';

  // Main Shell Tab Route Names
  static const String map = 'map';
  static const String friends = 'friends';
  static const String session = 'session';
  static const String profile = 'profile';

  // Sub-route Names
  static const String locationDetails = 'locationDetails';
  static const String createSchedule = 'createSchedule';
  static const String createRoom = 'createRoom';
  static const String settings = 'settings';
  static const String editProfile = 'edit-profile';
  static const String chatDetail = 'chat-detail';
  static const String userDetail = 'user-detail';
  static const String topSpotsList = 'top-spots-list';

  // Route Paths
  static const String rootPath = '/';
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String stateWithMePath = '/state-with-me';

  static const String mapPath = '/map';
  static const String friendsPath = '/friends';
  static const String sessionPath = '/session';
  static const String profilePath = '/profile';

  static const String locationDetailsPath = '/location-details/:id';
  static const String topSpotsListPath = '/map/spots';
  static const String createSchedulePath = '/create-schedule';
  static const String createRoomPath = '/create-room';
  static const String settingsPath = '/settings';
  static const String editProfilePath = '/settings/edit-profile';
  static const String chatDetailPath = '/chat/:userId';
  static const String userDetailPath = '/profile/user/:userId';
}