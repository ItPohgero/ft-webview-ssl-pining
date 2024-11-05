import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../../base/base_controller.dart';
import '../../../models/grid_menu_items.dart';
import '../../../models/view_data_model/login_dm.dart';
import '../../../utils/firebase/remote_config_utils.dart';

class HomeController extends BaseController {
  final RxList<String> items =
      List<String>.generate(30, (index) => "Item $index").obs;
  RxList<GridMenuItem> gridMenuItems = <GridMenuItem>[
    GridMenuItem(
        title: 'Menu 1',
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/3e/Android_logo_2019.png'),
    GridMenuItem(
        title: 'Menu 2',
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/3e/Android_logo_2019.png'),
    GridMenuItem(
        title: 'Menu 3',
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/3e/Android_logo_2019.png'),
    GridMenuItem(
        title: 'Menu 4',
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/3e/Android_logo_2019.png'),
    GridMenuItem(
        title: 'Menu 5',
        imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/3/3e/Android_logo_2019.png'),
  ].obs;

  late LoginDM loginDM;

  Map<String, bool>? _previousVisibilityMap;

  Future<void> _fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      final bool updated = await remoteConfig.fetchAndActivate();
      print('Remote Config fetched and activated: $updated');

      final String jsonString = remoteConfig.getString("grid_menu_visibility");
      print('Remote Config JSON: $jsonString');

      if (jsonString.isEmpty) {
        print('Remote config JSON is empty.');
        return;
      }

      final Map<String, bool> visibilityMap =
      await RemoteConfigUtils().parseJsonConfig(jsonString);

      if (_previousVisibilityMap == null || !_mapsEqual(_previousVisibilityMap!, visibilityMap)) {
        _updateGridMenuItems(visibilityMap);
        _previousVisibilityMap = visibilityMap;
      } else {
        print('No changes in remote config.');
      }
    } catch (e) {
      print("Error fetching remote config: $e");
    }
  }

  void _updateGridMenuItems(Map<String, bool> visibilityMap) {
    gridMenuItems.value = gridMenuItems
        .map((menuItem) {
      final visible = visibilityMap[menuItem.title] ?? true;
      return GridMenuItem(
        title: menuItem.title,
        imageUrl: menuItem.imageUrl,
        visible: visible,
      );
    })
        .where((menuItem) => menuItem.visible)
        .toList();
  }

  bool _mapsEqual(Map<String, bool> map1, Map<String, bool> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    if (arguments.containsKey('loginDM')) {
      loginDM = arguments['loginDM'] as LoginDM;
      print('Received LoginDM: $loginDM');
    }
    _fetchRemoteConfig();
  }
}
