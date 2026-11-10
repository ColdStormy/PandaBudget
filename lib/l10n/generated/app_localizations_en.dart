// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PandaBudget';

  @override
  String get aboutLine => 'PandaBudget · your data stays on this device';

  @override
  String get navOverview => 'Overview';

  @override
  String get navPlanning => 'Planning';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAnalysis => 'Analysis';

  @override
  String get navSettings => 'Settings';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get clear => 'Clear';

  @override
  String get change => 'Change';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get undo => 'Undo';

  @override
  String get name => 'Name';

  @override
  String get color => 'Colour';

  @override
  String get icon => 'Icon';

  @override
  String get note => 'Note';

  @override
  String get amount => 'Amount';

  @override
  String get total => 'Total';

  @override
  String get and => 'and';

  @override
  String get or => 'or';

  @override
  String get active => 'Active';

  @override
  String get archived => 'Archived';

  @override
  String get paused => 'Paused';

  @override
  String get ended => 'Ended';

  @override
  String get priority => 'Priority';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityLow => 'Low';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get fieldRequired => 'Required';

  @override
  String get amountInvalid => 'Enter a valid amount';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get expenses => 'Expenses';

  @override
  String get payment => 'Payment';

  @override
  String get spent => 'Spent';

  @override
  String get spending => 'Spending';

  @override
  String get net => 'Balance';

  @override
  String get ofAmount => 'of';

  @override
  String get left => 'left';

  @override
  String get over => 'over';

  @override
  String get overspent => 'Overspent';

  @override
  String get category => 'Category';

  @override
  String get categories => 'Categories';

  @override
  String get account => 'Account';

  @override
  String get accounts => 'Accounts';

  @override
  String get allAccounts => 'All accounts';

  @override
  String get uncategorized => 'Uncategorised';

  @override
  String get counterparty => 'Payee / payer';

  @override
  String get purpose => 'Purpose';

  @override
  String get iban => 'IBAN';

  @override
  String get bookingDate => 'Booking date';

  @override
  String get valueDate => 'Value date';

  @override
  String get noDescription => 'No description';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String get welcomeTitle => 'Welcome to PandaBudget';

  @override
  String get welcomeMessage =>
      'Three steps to see where your money goes and what you can save.';

  @override
  String get stepAccountTitle => 'Add an account';

  @override
  String get stepAccountMessage =>
      'Your current account, savings, cash or a credit card.';

  @override
  String get stepImportTitle => 'Import transactions';

  @override
  String get stepImportMessage => 'Load a CSV or JSON export from your bank.';

  @override
  String get stepPlanTitle => 'Plan income and payments';

  @override
  String get stepPlanMessage =>
      'Salary, rent, insurance: everything you can foresee.';

  @override
  String get overviewActual => 'This month so far';

  @override
  String get overviewPlan => 'Plan for this month';

  @override
  String get overviewUpcoming => 'Coming up';

  @override
  String uncategorizedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions need a category',
      one: '1 transaction needs a category',
    );
    return '$_temp0';
  }

  @override
  String get uncategorizedMany => 'More than 100 transactions need a category';

  @override
  String get tabForecast => 'Forecast';

  @override
  String get tabPlannedItems => 'Income & payments';

  @override
  String get tabBudgets => 'Budgets';

  @override
  String get tabGoals => 'Savings goals';

  @override
  String get forecastEmptyTitle => 'Nothing planned yet';

  @override
  String get forecastEmptyMessage =>
      'Add your regular income and payments. The forecast then shows what each month costs and how much you can save.';

  @override
  String get forecastChartTitle => 'What each month leaves over';

  @override
  String get yearlyPlus => 'Plus for the year';

  @override
  String get savingsPotential => 'Can be saved';

  @override
  String savingsPotentialIn(String month) {
    return 'Can be saved in $month';
  }

  @override
  String get fixedPayments => 'Fixed payments';

  @override
  String get savingForGoals => 'For savings goals';

  @override
  String get freeAfterGoals => 'Free';

  @override
  String get budgetExceededByPlan => 'Planned payments exceed this budget';

  @override
  String get reserveHint => 'Keep back for more expensive months ahead:';

  @override
  String get addPlannedItem => 'Plan item';

  @override
  String get editPlannedItem => 'Edit planned item';

  @override
  String get deletePlannedItemTitle => 'Delete this planned item?';

  @override
  String get plannedEmptyTitle => 'No income or payments planned';

  @override
  String get plannedEmptyMessage =>
      'Add what recurs (salary, rent, subscriptions) and what comes once (a repair, a bonus).';

  @override
  String get plannedIncome => 'Income';

  @override
  String get plannedPayments => 'Payments';

  @override
  String get plannedIncomeHint => 'e.g. Salary';

  @override
  String get plannedPaymentHint => 'e.g. Rent';

  @override
  String get avgMonthlyIncome => 'Income per month (average)';

  @override
  String get avgMonthlyPayments => 'Payments per month (average)';

  @override
  String get repeats => 'Repeats';

  @override
  String get recurrenceOnce => 'Once';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get recurrenceQuarterly => 'Quarterly';

  @override
  String get recurrenceHalfYearly => 'Every six months';

  @override
  String get recurrenceYearly => 'Yearly';

  @override
  String recurrenceEveryNWeeks(int count) {
    return 'Every $count weeks';
  }

  @override
  String recurrenceEveryNMonths(int count) {
    return 'Every $count months';
  }

  @override
  String recurrenceEveryNYears(int count) {
    return 'Every $count years';
  }

  @override
  String nextOn(String date) {
    return 'next $date';
  }

  @override
  String get dueDate => 'Due date';

  @override
  String get firstDueDate => 'First due date';

  @override
  String get endDateOptional => 'Ends on (optional)';

  @override
  String get activePlannedHint => 'Paused items are left out of the forecast.';

  @override
  String get addBudget => 'Add budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get deleteBudgetTitle => 'Delete this budget?';

  @override
  String get budgetsEmptyTitle => 'No budgets yet';

  @override
  String get budgetsEmptyMessage =>
      'A budget is a monthly limit for one or more categories, such as groceries.';

  @override
  String budgetsThisMonth(String month) {
    return '$month';
  }

  @override
  String get budgetNotActive => 'Not active this month';

  @override
  String get budgetNoCategories => 'No categories assigned';

  @override
  String get budgetPerMonth => 'Limit per month';

  @override
  String get budgetCategories => 'Categories';

  @override
  String get budgetCategoriesHint =>
      'Spending in these categories counts against the budget. A main category includes its sub-categories.';

  @override
  String get validFrom => 'From';

  @override
  String get validUntilOptional => 'Until (optional)';

  @override
  String get addGoal => 'Add goal';

  @override
  String get editGoal => 'Edit savings goal';

  @override
  String get deleteGoalTitle => 'Delete this savings goal?';

  @override
  String get goalsEmptyTitle => 'No savings goals yet';

  @override
  String get goalsEmptyMessage =>
      'Set a target and a month, such as a vacation next summer. The plan shows how much to put aside each month.';

  @override
  String get goalNameHint => 'e.g. Vacation';

  @override
  String get goalTarget => 'Target amount';

  @override
  String get goalAlreadySaved => 'Already saved';

  @override
  String get goalNeededBy => 'Needed by';

  @override
  String goalBy(String month) {
    return 'by $month';
  }

  @override
  String get goalReached => 'Reached';

  @override
  String get goalOnTrack => 'On track';

  @override
  String get goalBehind => 'Behind plan';

  @override
  String get goalMonthlyRate => 'Needed per month';

  @override
  String get goalOnTrackHint => 'Your plan leaves enough each month.';

  @override
  String get goalFrontLoadedHint =>
      'Reachable if you save more in the early months.';

  @override
  String get goalShortBy => 'Short by';

  @override
  String goalReachableIn(String month) {
    return 'reachable in $month';
  }

  @override
  String get addTransaction => 'Add transaction';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get deleteTransactionTitle => 'Delete this transaction?';

  @override
  String get transactionNeedsAccount =>
      'Transactions belong to an account. Add one first.';

  @override
  String get searchTransactions => 'Search transactions';

  @override
  String get noTransactionsTitle => 'No transactions yet';

  @override
  String get noTransactionsMessage =>
      'Import an export from your bank or add transactions by hand.';

  @override
  String get noTransactionsFound => 'No transactions match';

  @override
  String get importBankFile => 'Import bank file';

  @override
  String get importShort => 'Import';

  @override
  String get period => 'Period';

  @override
  String get periodAll => 'All time';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodLastMonth => 'Last month';

  @override
  String get periodThisYear => 'This year';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get changeCategory => 'Change category';

  @override
  String categorySetTo(String name) {
    return 'Category set to $name';
  }

  @override
  String get createRule => 'Create rule';

  @override
  String get createRuleFromTransaction => 'Create a rule from this transaction';

  @override
  String get suggested => 'suggested';

  @override
  String get byCategory => 'By category';

  @override
  String get noTransactionsInMonth => 'No transactions in this month';

  @override
  String get trendTitle => 'Last 12 months';

  @override
  String get planVsActual => 'Plan and reality';

  @override
  String get planned => 'Planned';

  @override
  String get actual => 'Actual';

  @override
  String get difference => 'Better / worse';

  @override
  String get addAccount => 'Add account';

  @override
  String get editAccount => 'Edit account';

  @override
  String get deleteAccountTitle => 'Delete this account?';

  @override
  String get deleteAccountMessage =>
      'All transactions of this account are deleted with it. To keep them, archive the account instead.';

  @override
  String get noAccountsTitle => 'No accounts yet';

  @override
  String get noAccountsMessage =>
      'Add the accounts you want to keep an eye on.';

  @override
  String get accountKind => 'Type';

  @override
  String get accountKindChecking => 'Current account';

  @override
  String get accountKindSavings => 'Savings account';

  @override
  String get accountKindCash => 'Cash';

  @override
  String get accountKindCreditCard => 'Credit card';

  @override
  String get accountKindInvestment => 'Investments';

  @override
  String get ibanOptional => 'IBAN (optional)';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get openingDate => 'As of';

  @override
  String get archivedAccountHint =>
      'Hidden from lists; its transactions are kept.';

  @override
  String get addCategory => 'Add category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get deleteCategoryTitle => 'Delete this category?';

  @override
  String get deleteCategoryMessage =>
      'Its sub-categories and rules are deleted too. Transactions stay, but lose their category.';

  @override
  String get categoryKind => 'Type';

  @override
  String get categoryKindExpense => 'Expenses';

  @override
  String get categoryKindIncome => 'Income';

  @override
  String get categoryKindTransfer => 'Transfers between own accounts';

  @override
  String get parentCategory => 'Belongs to';

  @override
  String get noParentCategory => 'None (main category)';

  @override
  String get archivedCategoryHint => 'No longer offered for new transactions.';

  @override
  String get searchCategories => 'Search categories';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get rules => 'Rules';

  @override
  String get addRule => 'Add rule';

  @override
  String get editRule => 'Edit rule';

  @override
  String get deleteRuleTitle => 'Delete this rule?';

  @override
  String get noRulesTitle => 'No rules yet';

  @override
  String get noRulesMessage =>
      'Rules put transactions into categories automatically, for example everything from your supermarket into Groceries.';

  @override
  String get rulesOrderHint =>
      'The first matching rule wins. Drag to change the order.';

  @override
  String get applyRulesNow => 'Apply rules now';

  @override
  String recategorizedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions updated',
      one: '1 transaction updated',
      zero: 'No transactions changed',
    );
    return '$_temp0';
  }

  @override
  String get ruleConditions => 'A transaction matches if';

  @override
  String get ruleMatchAll => 'all conditions apply';

  @override
  String get ruleMatchAny => 'any condition applies';

  @override
  String get ruleField => 'Field';

  @override
  String get ruleOperator => 'Condition';

  @override
  String get ruleValue => 'Value';

  @override
  String get ruleAmountHint => 'Payments are negative, e.g. -50';

  @override
  String get ruleFieldAnyText => 'Any text';

  @override
  String get ruleOpContains => 'Contains';

  @override
  String get ruleOpEquals => 'Is exactly';

  @override
  String get ruleOpStartsWith => 'Starts with';

  @override
  String get ruleOpEndsWith => 'Ends with';

  @override
  String get ruleOpRegex => 'Matches pattern';

  @override
  String get ruleOpGreaterThan => 'Is greater than';

  @override
  String get ruleOpLessThan => 'Is less than';

  @override
  String get addCondition => 'Add condition';

  @override
  String get ruleAssignCategory => 'Then assign category';

  @override
  String get ruleEnabled => 'Rule is active';

  @override
  String get importTitle => 'Import transactions';

  @override
  String get importStepFile => 'File';

  @override
  String get importStepColumns => 'Columns';

  @override
  String get importStepReview => 'Review';

  @override
  String get chooseFile => 'Choose a file';

  @override
  String get chooseFileHint => 'CSV or JSON export from your bank';

  @override
  String get fileNotReadable => 'This file could not be read';

  @override
  String rowsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows found',
      one: '1 row found',
    );
    return '$_temp0';
  }

  @override
  String get importNeedsAccount => 'Add an account to import into.';

  @override
  String get importIntoAccount => 'Import into account';

  @override
  String get bankFormat => 'Bank format';

  @override
  String get newBankFormat => 'New format';

  @override
  String formatRecognised(String name) {
    return 'Recognised as “$name”. Columns are mapped already.';
  }

  @override
  String get formatNew =>
      'New format. On the next step you check which column is what; PandaBudget remembers it for next time.';

  @override
  String get adjustColumns => 'Adjust columns';

  @override
  String get importPreview => 'Preview';

  @override
  String get importPreviewEmpty =>
      'Map the date and amount columns to see a preview.';

  @override
  String get rememberFormat => 'Remember this format';

  @override
  String get rememberFormatHint =>
      'Files with the same columns are then recognised automatically.';

  @override
  String rowNumber(int count) {
    return 'Row $count';
  }

  @override
  String get issueMissingDate => 'date missing';

  @override
  String get issueInvalidDate => 'date not readable';

  @override
  String get issueMissingAmount => 'amount missing';

  @override
  String get issueInvalidAmount => 'amount not readable';

  @override
  String reviewNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new',
      one: '1 new',
      zero: 'Nothing new',
    );
    return '$_temp0';
  }

  @override
  String reviewCategorised(int count) {
    return '$count categorised';
  }

  @override
  String reviewDuplicates(int count) {
    return '$count already imported';
  }

  @override
  String reviewInvalid(int count) {
    return '$count not readable';
  }

  @override
  String get alreadyImported => 'already imported';

  @override
  String importAction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count transactions',
      one: 'Import 1 transaction',
      zero: 'Nothing to import',
    );
    return '$_temp0';
  }

  @override
  String importedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions imported',
      one: '1 transaction imported',
    );
    return '$_temp0';
  }

  @override
  String get importProfiles => 'Bank formats';

  @override
  String get addImportProfile => 'Add format';

  @override
  String get editImportProfile => 'Edit bank format';

  @override
  String get deleteImportProfileTitle => 'Delete this bank format?';

  @override
  String get noImportProfilesTitle => 'No bank formats saved';

  @override
  String get noImportProfilesMessage =>
      'A format is saved the first time you import a file from a bank.';

  @override
  String mappedColumns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count columns',
      one: '1 column',
    );
    return '$_temp0';
  }

  @override
  String get mappingIncomplete => 'Map all columns marked with *';

  @override
  String get profileName => 'Name of the format';

  @override
  String get profileNameHint => 'Usually the bank';

  @override
  String get fileFormat => 'File format';

  @override
  String get fileType => 'File type';

  @override
  String get delimiter => 'Separator';

  @override
  String get detectAutomatically => 'Detect';

  @override
  String get delimiterSemicolon => 'Semicolon ;';

  @override
  String get delimiterComma => 'Comma ,';

  @override
  String get delimiterTab => 'Tab';

  @override
  String get delimiterPipe => 'Pipe |';

  @override
  String get encoding => 'Encoding';

  @override
  String get headerRow => 'Line of the header row';

  @override
  String get headerRowHint => 'Leave empty to detect it';

  @override
  String get jsonRootPath => 'Path to the transactions';

  @override
  String get jsonRootPathHint =>
      'e.g. data.transactions; leave empty to detect it';

  @override
  String get dateFormat => 'Date format';

  @override
  String get decimalSeparator => 'Decimal separator';

  @override
  String get decimalComma => 'Comma (1.234,56)';

  @override
  String get decimalPoint => 'Point (1,234.56)';

  @override
  String get amountLayout => 'Amounts are given as';

  @override
  String get amountModeSigned => 'One column with sign';

  @override
  String get amountModeDebitCredit => 'Separate debit and credit columns';

  @override
  String get amountModeIndicator => 'Amount plus debit/credit marker';

  @override
  String get debitIndicators => 'Values that mean debit';

  @override
  String get debitIndicatorsHint => 'Separated by commas';

  @override
  String get invertSign => 'Invert sign';

  @override
  String get invertSignHint =>
      'For exports that list payments as positive numbers.';

  @override
  String get columnMapping => 'Columns';

  @override
  String get columnNameHint => 'Column name in the file';

  @override
  String get notMapped => 'Not used';

  @override
  String get importFieldDebit => 'Debit (money out)';

  @override
  String get importFieldCredit => 'Credit (money in)';

  @override
  String get importFieldIndicator => 'Debit/credit marker';

  @override
  String get importHistory => 'Import history';

  @override
  String get noImportsTitle => 'Nothing imported yet';

  @override
  String get noImportsMessage =>
      'Every import is listed here and can be undone as a whole.';

  @override
  String get undoImportTitle => 'Undo this import?';

  @override
  String undoImportMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The $count transactions it added are deleted.',
      one: 'The transaction it added is deleted.',
    );
    return '$_temp0';
  }

  @override
  String get settingsData => 'Your data';

  @override
  String get settingsAccountsHint => 'Current accounts, savings, cash, cards';

  @override
  String get settingsCategoriesHint => 'What you sort income and spending into';

  @override
  String get settingsRulesHint => 'Categorise transactions automatically';

  @override
  String get settingsImportProfilesHint => 'Saved column mappings per bank';

  @override
  String get settingsImportHistoryHint => 'Review and undo imports';

  @override
  String get settingsCategorisation => 'Categorisation';

  @override
  String get categoriseUncategorised => 'Categorise open transactions';

  @override
  String get categoriseUncategorisedHint =>
      'Runs rules and learned suggestions over transactions without a category.';

  @override
  String get rebuildLearning => 'Relearn suggestions';

  @override
  String get rebuildLearningHint =>
      'Rebuilds what PandaBudget learned from your rules and manual choices.';

  @override
  String get rebuildLearningDone => 'Suggestions relearned';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System language';

  @override
  String get currency => 'Currency';
}
