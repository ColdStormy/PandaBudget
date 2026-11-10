import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pandabudget/app/app_shell.dart';
import 'package:pandabudget/app/routes.dart';
import 'package:pandabudget/features/accounts/presentation/account_edit_screen.dart';
import 'package:pandabudget/features/accounts/presentation/accounts_screen.dart';
import 'package:pandabudget/features/analysis/presentation/analysis_screen.dart';
import 'package:pandabudget/features/categories/presentation/categories_screen.dart';
import 'package:pandabudget/features/categories/presentation/category_edit_screen.dart';
import 'package:pandabudget/features/categorization/presentation/rule_edit_screen.dart';
import 'package:pandabudget/features/categorization/presentation/rules_screen.dart';
import 'package:pandabudget/features/dashboard/presentation/overview_screen.dart';
import 'package:pandabudget/features/importing/presentation/import_history_screen.dart';
import 'package:pandabudget/features/importing/presentation/import_profile_edit_screen.dart';
import 'package:pandabudget/features/importing/presentation/import_profiles_screen.dart';
import 'package:pandabudget/features/importing/presentation/import_wizard_screen.dart';
import 'package:pandabudget/features/planning/presentation/budget_edit_screen.dart';
import 'package:pandabudget/features/planning/presentation/goal_edit_screen.dart';
import 'package:pandabudget/features/planning/presentation/planned_item_edit_screen.dart';
import 'package:pandabudget/features/planning/presentation/planning_screen.dart';
import 'package:pandabudget/features/settings/presentation/settings_screen.dart';
import 'package:pandabudget/features/transactions/domain/ledger_transaction.dart';
import 'package:pandabudget/features/transactions/presentation/transaction_edit_screen.dart';
import 'package:pandabudget/features/transactions/presentation/transactions_screen.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

int? _id(GoRouterState state) =>
    int.tryParse(state.uri.queryParameters['id'] ?? '');

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.overview,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.overview,
                builder: (_, _) => const OverviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.planning,
                builder: (_, _) => const PlanningScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.transactions,
                builder: (_, _) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.analysis,
                builder: (_, _) => const AnalysisScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (_, _) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'accounts',
                    builder: (_, _) => const AccountsScreen(),
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (_, _) => const CategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'rules',
                    builder: (_, _) => const RulesScreen(),
                  ),
                  GoRoute(
                    path: 'import-profiles',
                    builder: (_, _) => const ImportProfilesScreen(),
                  ),
                  GoRoute(
                    path: 'import-history',
                    builder: (_, _) => const ImportHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Create/edit screens and the import wizard cover the whole window.
      GoRoute(
        path: '/edit/account',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => AccountEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/category',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => CategoryEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/rule',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => RuleEditScreen(
          id: _id(state),
          template: state.extra as LedgerTransaction?,
        ),
      ),
      GoRoute(
        path: '/edit/import-profile',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ImportProfileEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/transaction',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TransactionEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/planned-item',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => PlannedItemEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/budget',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => BudgetEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: '/edit/goal',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => GoalEditScreen(id: _id(state)),
      ),
      GoRoute(
        path: Routes.importWizard,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ImportWizardScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
