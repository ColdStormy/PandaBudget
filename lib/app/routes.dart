/// Paths of the app's screens.
abstract final class Routes {
  static const overview = '/overview';
  static const planning = '/planning';
  static const transactions = '/transactions';
  static const analysis = '/analysis';
  static const settings = '/settings';

  static const settingsAccounts = '/settings/accounts';
  static const settingsCategories = '/settings/categories';
  static const settingsRules = '/settings/rules';
  static const settingsImportProfiles = '/settings/import-profiles';
  static const settingsImportHistory = '/settings/import-history';

  static const importWizard = '/import';

  static String accountEdit([int? id]) => _edit('/edit/account', id);
  static String categoryEdit([int? id]) => _edit('/edit/category', id);
  static String ruleEdit([int? id]) => _edit('/edit/rule', id);
  static String importProfileEdit([int? id]) =>
      _edit('/edit/import-profile', id);
  static String transactionEdit([int? id]) => _edit('/edit/transaction', id);
  static String plannedItemEdit([int? id]) => _edit('/edit/planned-item', id);
  static String budgetEdit([int? id]) => _edit('/edit/budget', id);
  static String goalEdit([int? id]) => _edit('/edit/goal', id);

  static String _edit(String path, int? id) =>
      id == null ? path : '$path?id=$id';
}
