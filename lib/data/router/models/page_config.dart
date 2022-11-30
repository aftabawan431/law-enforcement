import 'package:law_enforcement/data/router/models/page_keys.dart';
import 'package:law_enforcement/data/router/models/page_paths.dart';

import '../pages.dart';

class PageConfigs {
  static PageConfiguration splashPageConfig = PageConfiguration(key: PageKeys.splashPageKey, path: PagePaths.splashPagePath, uiPage: Pages.splashPage);

  static PageConfiguration loginPageConfig = PageConfiguration(key: PageKeys.loginPageKey, path: PagePaths.loginPagePath, uiPage: Pages.loginPage);
  static PageConfiguration homePageConfig = PageConfiguration(key: PageKeys.homePageKey, path: PagePaths.homePageKey, uiPage: Pages.homePage);
  static PageConfiguration googleMapPageConfig = PageConfiguration(key: PageKeys.googleMapPageKey, path: PagePaths.googleMapPageKey, uiPage: Pages.googleMapPage);
}
