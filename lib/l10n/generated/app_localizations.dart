import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PandaBudget'**
  String get appTitle;

  /// No description provided for @aboutLine.
  ///
  /// In en, this message translates to:
  /// **'PandaBudget · your data stays on this device'**
  String get aboutLine;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get navPlanning;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get navAnalysis;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get color;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get amountInvalid;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @spending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spending;

  /// No description provided for @net.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get net;

  /// No description provided for @ofAmount.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofAmount;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @over.
  ///
  /// In en, this message translates to:
  /// **'over'**
  String get over;

  /// No description provided for @overspent.
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get overspent;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @allAccounts.
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get allAccounts;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorised'**
  String get uncategorized;

  /// No description provided for @counterparty.
  ///
  /// In en, this message translates to:
  /// **'Payee / payer'**
  String get counterparty;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get iban;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking date'**
  String get bookingDate;

  /// No description provided for @valueDate.
  ///
  /// In en, this message translates to:
  /// **'Value date'**
  String get valueDate;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction} other{{count} transactions}}'**
  String transactionCount(int count);

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PandaBudget'**
  String get welcomeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Three steps to see where your money goes and what you can save.'**
  String get welcomeMessage;

  /// No description provided for @stepAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Add an account'**
  String get stepAccountTitle;

  /// No description provided for @stepAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Your current account, savings, cash or a credit card.'**
  String get stepAccountMessage;

  /// No description provided for @stepImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import transactions'**
  String get stepImportTitle;

  /// No description provided for @stepImportMessage.
  ///
  /// In en, this message translates to:
  /// **'Load a CSV or JSON export from your bank.'**
  String get stepImportMessage;

  /// No description provided for @stepPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan income and payments'**
  String get stepPlanTitle;

  /// No description provided for @stepPlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Salary, rent, insurance: everything you can foresee.'**
  String get stepPlanMessage;

  /// No description provided for @overviewActual.
  ///
  /// In en, this message translates to:
  /// **'This month so far'**
  String get overviewActual;

  /// No description provided for @overviewPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan for this month'**
  String get overviewPlan;

  /// No description provided for @overviewUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get overviewUpcoming;

  /// No description provided for @uncategorizedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction needs a category} other{{count} transactions need a category}}'**
  String uncategorizedCount(int count);

  /// No description provided for @uncategorizedMany.
  ///
  /// In en, this message translates to:
  /// **'More than 100 transactions need a category'**
  String get uncategorizedMany;

  /// No description provided for @tabForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get tabForecast;

  /// No description provided for @tabPlannedItems.
  ///
  /// In en, this message translates to:
  /// **'Income & payments'**
  String get tabPlannedItems;

  /// No description provided for @tabBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get tabBudgets;

  /// No description provided for @tabGoals.
  ///
  /// In en, this message translates to:
  /// **'Savings goals'**
  String get tabGoals;

  /// No description provided for @forecastEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned yet'**
  String get forecastEmptyTitle;

  /// No description provided for @forecastEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your regular income and payments. The forecast then shows what each month costs and how much you can save.'**
  String get forecastEmptyMessage;

  /// No description provided for @forecastChartTitle.
  ///
  /// In en, this message translates to:
  /// **'What each month leaves over'**
  String get forecastChartTitle;

  /// No description provided for @yearlyPlus.
  ///
  /// In en, this message translates to:
  /// **'Plus for the year'**
  String get yearlyPlus;

  /// No description provided for @savingsPotential.
  ///
  /// In en, this message translates to:
  /// **'Can be saved'**
  String get savingsPotential;

  /// No description provided for @savingsPotentialIn.
  ///
  /// In en, this message translates to:
  /// **'Can be saved in {month}'**
  String savingsPotentialIn(String month);

  /// No description provided for @fixedPayments.
  ///
  /// In en, this message translates to:
  /// **'Fixed payments'**
  String get fixedPayments;

  /// No description provided for @savingForGoals.
  ///
  /// In en, this message translates to:
  /// **'For savings goals'**
  String get savingForGoals;

  /// No description provided for @freeAfterGoals.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeAfterGoals;

  /// No description provided for @budgetExceededByPlan.
  ///
  /// In en, this message translates to:
  /// **'Planned payments exceed this budget'**
  String get budgetExceededByPlan;

  /// No description provided for @reserveHint.
  ///
  /// In en, this message translates to:
  /// **'Keep back for more expensive months ahead:'**
  String get reserveHint;

  /// No description provided for @addPlannedItem.
  ///
  /// In en, this message translates to:
  /// **'Plan item'**
  String get addPlannedItem;

  /// No description provided for @editPlannedItem.
  ///
  /// In en, this message translates to:
  /// **'Edit planned item'**
  String get editPlannedItem;

  /// No description provided for @deletePlannedItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this planned item?'**
  String get deletePlannedItemTitle;

  /// No description provided for @plannedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No income or payments planned'**
  String get plannedEmptyTitle;

  /// No description provided for @plannedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add what recurs (salary, rent, subscriptions) and what comes once (a repair, a bonus).'**
  String get plannedEmptyMessage;

  /// No description provided for @plannedIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get plannedIncome;

  /// No description provided for @plannedPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get plannedPayments;

  /// No description provided for @plannedIncomeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Salary'**
  String get plannedIncomeHint;

  /// No description provided for @plannedPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rent'**
  String get plannedPaymentHint;

  /// No description provided for @avgMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Income per month (average)'**
  String get avgMonthlyIncome;

  /// No description provided for @avgMonthlyPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments per month (average)'**
  String get avgMonthlyPayments;

  /// No description provided for @repeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get repeats;

  /// No description provided for @recurrenceOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get recurrenceOnce;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurrenceMonthly;

  /// No description provided for @recurrenceQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get recurrenceQuarterly;

  /// No description provided for @recurrenceHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Every six months'**
  String get recurrenceHalfYearly;

  /// No description provided for @recurrenceYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurrenceYearly;

  /// No description provided for @recurrenceEveryNWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {count} weeks'**
  String recurrenceEveryNWeeks(int count);

  /// No description provided for @recurrenceEveryNMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {count} months'**
  String recurrenceEveryNMonths(int count);

  /// No description provided for @recurrenceEveryNYears.
  ///
  /// In en, this message translates to:
  /// **'Every {count} years'**
  String recurrenceEveryNYears(int count);

  /// No description provided for @nextOn.
  ///
  /// In en, this message translates to:
  /// **'next {date}'**
  String nextOn(String date);

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @firstDueDate.
  ///
  /// In en, this message translates to:
  /// **'First due date'**
  String get firstDueDate;

  /// No description provided for @endDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Ends on (optional)'**
  String get endDateOptional;

  /// No description provided for @activePlannedHint.
  ///
  /// In en, this message translates to:
  /// **'Paused items are left out of the forecast.'**
  String get activePlannedHint;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add budget'**
  String get addBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @deleteBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this budget?'**
  String get deleteBudgetTitle;

  /// No description provided for @budgetsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get budgetsEmptyTitle;

  /// No description provided for @budgetsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'A budget is a monthly limit for one or more categories, such as groceries.'**
  String get budgetsEmptyMessage;

  /// No description provided for @budgetsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{month}'**
  String budgetsThisMonth(String month);

  /// No description provided for @budgetNotActive.
  ///
  /// In en, this message translates to:
  /// **'Not active this month'**
  String get budgetNotActive;

  /// No description provided for @budgetNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories assigned'**
  String get budgetNoCategories;

  /// No description provided for @budgetPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Limit per month'**
  String get budgetPerMonth;

  /// No description provided for @budgetCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get budgetCategories;

  /// No description provided for @budgetCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Spending in these categories counts against the budget. A main category includes its sub-categories.'**
  String get budgetCategoriesHint;

  /// No description provided for @validFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get validFrom;

  /// No description provided for @validUntilOptional.
  ///
  /// In en, this message translates to:
  /// **'Until (optional)'**
  String get validUntilOptional;

  /// No description provided for @addGoal.
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get addGoal;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit savings goal'**
  String get editGoal;

  /// No description provided for @deleteGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this savings goal?'**
  String get deleteGoalTitle;

  /// No description provided for @goalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No savings goals yet'**
  String get goalsEmptyTitle;

  /// No description provided for @goalsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Set a target and a month, such as a vacation next summer. The plan shows how much to put aside each month.'**
  String get goalsEmptyMessage;

  /// No description provided for @goalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vacation'**
  String get goalNameHint;

  /// No description provided for @goalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get goalTarget;

  /// No description provided for @goalAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'Already saved'**
  String get goalAlreadySaved;

  /// No description provided for @goalNeededBy.
  ///
  /// In en, this message translates to:
  /// **'Needed by'**
  String get goalNeededBy;

  /// No description provided for @goalBy.
  ///
  /// In en, this message translates to:
  /// **'by {month}'**
  String goalBy(String month);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get goalReached;

  /// No description provided for @goalOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get goalOnTrack;

  /// No description provided for @goalBehind.
  ///
  /// In en, this message translates to:
  /// **'Behind plan'**
  String get goalBehind;

  /// No description provided for @goalMonthlyRate.
  ///
  /// In en, this message translates to:
  /// **'Needed per month'**
  String get goalMonthlyRate;

  /// No description provided for @goalOnTrackHint.
  ///
  /// In en, this message translates to:
  /// **'Your plan leaves enough each month.'**
  String get goalOnTrackHint;

  /// No description provided for @goalFrontLoadedHint.
  ///
  /// In en, this message translates to:
  /// **'Reachable if you save more in the early months.'**
  String get goalFrontLoadedHint;

  /// No description provided for @goalShortBy.
  ///
  /// In en, this message translates to:
  /// **'Short by'**
  String get goalShortBy;

  /// No description provided for @goalReachableIn.
  ///
  /// In en, this message translates to:
  /// **'reachable in {month}'**
  String goalReachableIn(String month);

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteTransactionTitle;

  /// No description provided for @transactionNeedsAccount.
  ///
  /// In en, this message translates to:
  /// **'Transactions belong to an account. Add one first.'**
  String get transactionNeedsAccount;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchTransactions;

  /// No description provided for @noTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsTitle;

  /// No description provided for @noTransactionsMessage.
  ///
  /// In en, this message translates to:
  /// **'Import an export from your bank or add transactions by hand.'**
  String get noTransactionsMessage;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions match'**
  String get noTransactionsFound;

  /// No description provided for @importBankFile.
  ///
  /// In en, this message translates to:
  /// **'Import bank file'**
  String get importBankFile;

  /// No description provided for @importShort.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importShort;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @periodAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get periodAll;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @periodLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get periodLastMonth;

  /// No description provided for @periodThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get periodThisYear;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @changeCategory.
  ///
  /// In en, this message translates to:
  /// **'Change category'**
  String get changeCategory;

  /// No description provided for @categorySetTo.
  ///
  /// In en, this message translates to:
  /// **'Category set to {name}'**
  String categorySetTo(String name);

  /// No description provided for @createRule.
  ///
  /// In en, this message translates to:
  /// **'Create rule'**
  String get createRule;

  /// No description provided for @createRuleFromTransaction.
  ///
  /// In en, this message translates to:
  /// **'Create a rule from this transaction'**
  String get createRuleFromTransaction;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'suggested'**
  String get suggested;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @noTransactionsInMonth.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this month'**
  String get noTransactionsInMonth;

  /// No description provided for @trendTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get trendTitle;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'All transactions of this account are deleted with it. To keep them, archive the account instead.'**
  String get deleteAccountMessage;

  /// No description provided for @noAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccountsTitle;

  /// No description provided for @noAccountsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the accounts you want to keep an eye on.'**
  String get noAccountsMessage;

  /// No description provided for @accountKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get accountKind;

  /// No description provided for @accountKindChecking.
  ///
  /// In en, this message translates to:
  /// **'Current account'**
  String get accountKindChecking;

  /// No description provided for @accountKindSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings account'**
  String get accountKindSavings;

  /// No description provided for @accountKindCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountKindCash;

  /// No description provided for @accountKindCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get accountKindCreditCard;

  /// No description provided for @accountKindInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get accountKindInvestment;

  /// No description provided for @ibanOptional.
  ///
  /// In en, this message translates to:
  /// **'IBAN (optional)'**
  String get ibanOptional;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @openingDate.
  ///
  /// In en, this message translates to:
  /// **'As of'**
  String get openingDate;

  /// No description provided for @archivedAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Hidden from lists; its transactions are kept.'**
  String get archivedAccountHint;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Its sub-categories and rules are deleted too. Transactions stay, but lose their category.'**
  String get deleteCategoryMessage;

  /// No description provided for @categoryKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get categoryKind;

  /// No description provided for @categoryKindExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get categoryKindExpense;

  /// No description provided for @categoryKindIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get categoryKindIncome;

  /// No description provided for @categoryKindTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfers between own accounts'**
  String get categoryKindTransfer;

  /// No description provided for @parentCategory.
  ///
  /// In en, this message translates to:
  /// **'Belongs to'**
  String get parentCategory;

  /// No description provided for @noParentCategory.
  ///
  /// In en, this message translates to:
  /// **'None (main category)'**
  String get noParentCategory;

  /// No description provided for @archivedCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'No longer offered for new transactions.'**
  String get archivedCategoryHint;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get searchCategories;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get addRule;

  /// No description provided for @editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get editRule;

  /// No description provided for @deleteRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this rule?'**
  String get deleteRuleTitle;

  /// No description provided for @noRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'No rules yet'**
  String get noRulesTitle;

  /// No description provided for @noRulesMessage.
  ///
  /// In en, this message translates to:
  /// **'Rules put transactions into categories automatically, for example everything from your supermarket into Groceries.'**
  String get noRulesMessage;

  /// No description provided for @rulesOrderHint.
  ///
  /// In en, this message translates to:
  /// **'The first matching rule wins. Drag to change the order.'**
  String get rulesOrderHint;

  /// No description provided for @applyRulesNow.
  ///
  /// In en, this message translates to:
  /// **'Apply rules now'**
  String get applyRulesNow;

  /// No description provided for @recategorizedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions changed} =1{1 transaction updated} other{{count} transactions updated}}'**
  String recategorizedCount(int count);

  /// No description provided for @ruleConditions.
  ///
  /// In en, this message translates to:
  /// **'A transaction matches if'**
  String get ruleConditions;

  /// No description provided for @ruleMatchAll.
  ///
  /// In en, this message translates to:
  /// **'all conditions apply'**
  String get ruleMatchAll;

  /// No description provided for @ruleMatchAny.
  ///
  /// In en, this message translates to:
  /// **'any condition applies'**
  String get ruleMatchAny;

  /// No description provided for @ruleField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get ruleField;

  /// No description provided for @ruleOperator.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get ruleOperator;

  /// No description provided for @ruleValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get ruleValue;

  /// No description provided for @ruleAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Payments are negative, e.g. -50'**
  String get ruleAmountHint;

  /// No description provided for @ruleFieldAnyText.
  ///
  /// In en, this message translates to:
  /// **'Any text'**
  String get ruleFieldAnyText;

  /// No description provided for @ruleOpContains.
  ///
  /// In en, this message translates to:
  /// **'Contains'**
  String get ruleOpContains;

  /// No description provided for @ruleOpEquals.
  ///
  /// In en, this message translates to:
  /// **'Is exactly'**
  String get ruleOpEquals;

  /// No description provided for @ruleOpStartsWith.
  ///
  /// In en, this message translates to:
  /// **'Starts with'**
  String get ruleOpStartsWith;

  /// No description provided for @ruleOpEndsWith.
  ///
  /// In en, this message translates to:
  /// **'Ends with'**
  String get ruleOpEndsWith;

  /// No description provided for @ruleOpRegex.
  ///
  /// In en, this message translates to:
  /// **'Matches pattern'**
  String get ruleOpRegex;

  /// No description provided for @ruleOpGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'Is greater than'**
  String get ruleOpGreaterThan;

  /// No description provided for @ruleOpLessThan.
  ///
  /// In en, this message translates to:
  /// **'Is less than'**
  String get ruleOpLessThan;

  /// No description provided for @addCondition.
  ///
  /// In en, this message translates to:
  /// **'Add condition'**
  String get addCondition;

  /// No description provided for @ruleAssignCategory.
  ///
  /// In en, this message translates to:
  /// **'Then assign category'**
  String get ruleAssignCategory;

  /// No description provided for @ruleEnabled.
  ///
  /// In en, this message translates to:
  /// **'Rule is active'**
  String get ruleEnabled;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import transactions'**
  String get importTitle;

  /// No description provided for @importStepFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get importStepFile;

  /// No description provided for @importStepColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get importStepColumns;

  /// No description provided for @importStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get importStepReview;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseFile;

  /// No description provided for @chooseFileHint.
  ///
  /// In en, this message translates to:
  /// **'CSV or JSON export from your bank'**
  String get chooseFileHint;

  /// No description provided for @fileNotReadable.
  ///
  /// In en, this message translates to:
  /// **'This file could not be read'**
  String get fileNotReadable;

  /// No description provided for @rowsFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 row found} other{{count} rows found}}'**
  String rowsFound(int count);

  /// No description provided for @importNeedsAccount.
  ///
  /// In en, this message translates to:
  /// **'Add an account to import into.'**
  String get importNeedsAccount;

  /// No description provided for @importIntoAccount.
  ///
  /// In en, this message translates to:
  /// **'Import into account'**
  String get importIntoAccount;

  /// No description provided for @bankFormat.
  ///
  /// In en, this message translates to:
  /// **'Bank format'**
  String get bankFormat;

  /// No description provided for @newBankFormat.
  ///
  /// In en, this message translates to:
  /// **'New format'**
  String get newBankFormat;

  /// No description provided for @formatRecognised.
  ///
  /// In en, this message translates to:
  /// **'Recognised as “{name}”. Columns are mapped already.'**
  String formatRecognised(String name);

  /// No description provided for @formatNew.
  ///
  /// In en, this message translates to:
  /// **'New format. On the next step you check which column is what; PandaBudget remembers it for next time.'**
  String get formatNew;

  /// No description provided for @adjustColumns.
  ///
  /// In en, this message translates to:
  /// **'Adjust columns'**
  String get adjustColumns;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get importPreview;

  /// No description provided for @importPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Map the date and amount columns to see a preview.'**
  String get importPreviewEmpty;

  /// No description provided for @rememberFormat.
  ///
  /// In en, this message translates to:
  /// **'Remember this format'**
  String get rememberFormat;

  /// No description provided for @rememberFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Files with the same columns are then recognised automatically.'**
  String get rememberFormatHint;

  /// No description provided for @rowNumber.
  ///
  /// In en, this message translates to:
  /// **'Row {count}'**
  String rowNumber(int count);

  /// No description provided for @issueMissingDate.
  ///
  /// In en, this message translates to:
  /// **'date missing'**
  String get issueMissingDate;

  /// No description provided for @issueInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'date not readable'**
  String get issueInvalidDate;

  /// No description provided for @issueMissingAmount.
  ///
  /// In en, this message translates to:
  /// **'amount missing'**
  String get issueMissingAmount;

  /// No description provided for @issueInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'amount not readable'**
  String get issueInvalidAmount;

  /// No description provided for @reviewNew.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing new} =1{1 new} other{{count} new}}'**
  String reviewNew(int count);

  /// No description provided for @reviewCategorised.
  ///
  /// In en, this message translates to:
  /// **'{count} categorised'**
  String reviewCategorised(int count);

  /// No description provided for @reviewDuplicates.
  ///
  /// In en, this message translates to:
  /// **'{count} already imported'**
  String reviewDuplicates(int count);

  /// No description provided for @reviewInvalid.
  ///
  /// In en, this message translates to:
  /// **'{count} not readable'**
  String reviewInvalid(int count);

  /// No description provided for @alreadyImported.
  ///
  /// In en, this message translates to:
  /// **'already imported'**
  String get alreadyImported;

  /// No description provided for @importAction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to import} =1{Import 1 transaction} other{Import {count} transactions}}'**
  String importAction(int count);

  /// No description provided for @importedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction imported} other{{count} transactions imported}}'**
  String importedCount(int count);

  /// No description provided for @importProfiles.
  ///
  /// In en, this message translates to:
  /// **'Bank formats'**
  String get importProfiles;

  /// No description provided for @addImportProfile.
  ///
  /// In en, this message translates to:
  /// **'Add format'**
  String get addImportProfile;

  /// No description provided for @editImportProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit bank format'**
  String get editImportProfile;

  /// No description provided for @deleteImportProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this bank format?'**
  String get deleteImportProfileTitle;

  /// No description provided for @noImportProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'No bank formats saved'**
  String get noImportProfilesTitle;

  /// No description provided for @noImportProfilesMessage.
  ///
  /// In en, this message translates to:
  /// **'A format is saved the first time you import a file from a bank.'**
  String get noImportProfilesMessage;

  /// No description provided for @mappedColumns.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 column} other{{count} columns}}'**
  String mappedColumns(int count);

  /// No description provided for @mappingIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Map all columns marked with *'**
  String get mappingIncomplete;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name of the format'**
  String get profileName;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Usually the bank'**
  String get profileNameHint;

  /// No description provided for @fileFormat.
  ///
  /// In en, this message translates to:
  /// **'File format'**
  String get fileFormat;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get fileType;

  /// No description provided for @delimiter.
  ///
  /// In en, this message translates to:
  /// **'Separator'**
  String get delimiter;

  /// No description provided for @detectAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Detect'**
  String get detectAutomatically;

  /// No description provided for @delimiterSemicolon.
  ///
  /// In en, this message translates to:
  /// **'Semicolon ;'**
  String get delimiterSemicolon;

  /// No description provided for @delimiterComma.
  ///
  /// In en, this message translates to:
  /// **'Comma ,'**
  String get delimiterComma;

  /// No description provided for @delimiterTab.
  ///
  /// In en, this message translates to:
  /// **'Tab'**
  String get delimiterTab;

  /// No description provided for @delimiterPipe.
  ///
  /// In en, this message translates to:
  /// **'Pipe |'**
  String get delimiterPipe;

  /// No description provided for @encoding.
  ///
  /// In en, this message translates to:
  /// **'Encoding'**
  String get encoding;

  /// No description provided for @headerRow.
  ///
  /// In en, this message translates to:
  /// **'Line of the header row'**
  String get headerRow;

  /// No description provided for @headerRowHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to detect it'**
  String get headerRowHint;

  /// No description provided for @jsonRootPath.
  ///
  /// In en, this message translates to:
  /// **'Path to the transactions'**
  String get jsonRootPath;

  /// No description provided for @jsonRootPathHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. data.transactions; leave empty to detect it'**
  String get jsonRootPathHint;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get dateFormat;

  /// No description provided for @decimalSeparator.
  ///
  /// In en, this message translates to:
  /// **'Decimal separator'**
  String get decimalSeparator;

  /// No description provided for @decimalComma.
  ///
  /// In en, this message translates to:
  /// **'Comma (1.234,56)'**
  String get decimalComma;

  /// No description provided for @decimalPoint.
  ///
  /// In en, this message translates to:
  /// **'Point (1,234.56)'**
  String get decimalPoint;

  /// No description provided for @amountLayout.
  ///
  /// In en, this message translates to:
  /// **'Amounts are given as'**
  String get amountLayout;

  /// No description provided for @amountModeSigned.
  ///
  /// In en, this message translates to:
  /// **'One column with sign'**
  String get amountModeSigned;

  /// No description provided for @amountModeDebitCredit.
  ///
  /// In en, this message translates to:
  /// **'Separate debit and credit columns'**
  String get amountModeDebitCredit;

  /// No description provided for @amountModeIndicator.
  ///
  /// In en, this message translates to:
  /// **'Amount plus debit/credit marker'**
  String get amountModeIndicator;

  /// No description provided for @debitIndicators.
  ///
  /// In en, this message translates to:
  /// **'Values that mean debit'**
  String get debitIndicators;

  /// No description provided for @debitIndicatorsHint.
  ///
  /// In en, this message translates to:
  /// **'Separated by commas'**
  String get debitIndicatorsHint;

  /// No description provided for @invertSign.
  ///
  /// In en, this message translates to:
  /// **'Invert sign'**
  String get invertSign;

  /// No description provided for @invertSignHint.
  ///
  /// In en, this message translates to:
  /// **'For exports that list payments as positive numbers.'**
  String get invertSignHint;

  /// No description provided for @columnMapping.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get columnMapping;

  /// No description provided for @columnNameHint.
  ///
  /// In en, this message translates to:
  /// **'Column name in the file'**
  String get columnNameHint;

  /// No description provided for @notMapped.
  ///
  /// In en, this message translates to:
  /// **'Not used'**
  String get notMapped;

  /// No description provided for @importFieldDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit (money out)'**
  String get importFieldDebit;

  /// No description provided for @importFieldCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit (money in)'**
  String get importFieldCredit;

  /// No description provided for @importFieldIndicator.
  ///
  /// In en, this message translates to:
  /// **'Debit/credit marker'**
  String get importFieldIndicator;

  /// No description provided for @importHistory.
  ///
  /// In en, this message translates to:
  /// **'Import history'**
  String get importHistory;

  /// No description provided for @noImportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing imported yet'**
  String get noImportsTitle;

  /// No description provided for @noImportsMessage.
  ///
  /// In en, this message translates to:
  /// **'Every import is listed here and can be undone as a whole.'**
  String get noImportsMessage;

  /// No description provided for @undoImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Undo this import?'**
  String get undoImportTitle;

  /// No description provided for @undoImportMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{The transaction it added is deleted.} other{The {count} transactions it added are deleted.}}'**
  String undoImportMessage(int count);

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsData;

  /// No description provided for @settingsAccountsHint.
  ///
  /// In en, this message translates to:
  /// **'Current accounts, savings, cash, cards'**
  String get settingsAccountsHint;

  /// No description provided for @settingsCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'What you sort income and spending into'**
  String get settingsCategoriesHint;

  /// No description provided for @settingsRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Categorise transactions automatically'**
  String get settingsRulesHint;

  /// No description provided for @settingsImportProfilesHint.
  ///
  /// In en, this message translates to:
  /// **'Saved column mappings per bank'**
  String get settingsImportProfilesHint;

  /// No description provided for @settingsImportHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Review and undo imports'**
  String get settingsImportHistoryHint;

  /// No description provided for @settingsCategorisation.
  ///
  /// In en, this message translates to:
  /// **'Categorisation'**
  String get settingsCategorisation;

  /// No description provided for @categoriseUncategorised.
  ///
  /// In en, this message translates to:
  /// **'Categorise open transactions'**
  String get categoriseUncategorised;

  /// No description provided for @categoriseUncategorisedHint.
  ///
  /// In en, this message translates to:
  /// **'Runs rules and learned suggestions over transactions without a category.'**
  String get categoriseUncategorisedHint;

  /// No description provided for @rebuildLearning.
  ///
  /// In en, this message translates to:
  /// **'Relearn suggestions'**
  String get rebuildLearning;

  /// No description provided for @rebuildLearningHint.
  ///
  /// In en, this message translates to:
  /// **'Rebuilds what PandaBudget learned from your rules and manual choices.'**
  String get rebuildLearningHint;

  /// No description provided for @rebuildLearningDone.
  ///
  /// In en, this message translates to:
  /// **'Suggestions relearned'**
  String get rebuildLearningDone;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
