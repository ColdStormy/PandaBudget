// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'PandaBudget';

  @override
  String get aboutLine => 'PandaBudget · deine Daten bleiben auf diesem Gerät';

  @override
  String get navOverview => 'Übersicht';

  @override
  String get navPlanning => 'Planung';

  @override
  String get navTransactions => 'Umsätze';

  @override
  String get navAnalysis => 'Auswertung';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get clear => 'Leeren';

  @override
  String get change => 'Ändern';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get undo => 'Rückgängig';

  @override
  String get name => 'Name';

  @override
  String get color => 'Farbe';

  @override
  String get icon => 'Symbol';

  @override
  String get note => 'Notiz';

  @override
  String get amount => 'Betrag';

  @override
  String get total => 'Gesamt';

  @override
  String get and => 'und';

  @override
  String get or => 'oder';

  @override
  String get active => 'Aktiv';

  @override
  String get archived => 'Archiviert';

  @override
  String get paused => 'Pausiert';

  @override
  String get ended => 'Beendet';

  @override
  String get priority => 'Priorität';

  @override
  String get priorityHigh => 'Hoch';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityLow => 'Niedrig';

  @override
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get fieldRequired => 'Pflichtfeld';

  @override
  String get amountInvalid => 'Gültigen Betrag eingeben';

  @override
  String get previousMonth => 'Vorheriger Monat';

  @override
  String get nextMonth => 'Nächster Monat';

  @override
  String get income => 'Einnahmen';

  @override
  String get expense => 'Ausgabe';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get payment => 'Zahlung';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get spending => 'Ausgaben';

  @override
  String get net => 'Saldo';

  @override
  String get ofAmount => 'von';

  @override
  String get left => 'übrig';

  @override
  String get over => 'darüber';

  @override
  String get overspent => 'Überzogen';

  @override
  String get category => 'Kategorie';

  @override
  String get categories => 'Kategorien';

  @override
  String get account => 'Konto';

  @override
  String get accounts => 'Konten';

  @override
  String get allAccounts => 'Alle Konten';

  @override
  String get uncategorized => 'Ohne Kategorie';

  @override
  String get counterparty => 'Empfänger / Auftraggeber';

  @override
  String get purpose => 'Verwendungszweck';

  @override
  String get iban => 'IBAN';

  @override
  String get bookingDate => 'Buchungstag';

  @override
  String get valueDate => 'Wertstellung';

  @override
  String get noDescription => 'Keine Beschreibung';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Umsätze',
      one: '1 Umsatz',
    );
    return '$_temp0';
  }

  @override
  String get welcomeTitle => 'Willkommen bei PandaBudget';

  @override
  String get welcomeMessage =>
      'Drei Schritte, um zu sehen, wohin dein Geld fließt und was du sparen kannst.';

  @override
  String get stepAccountTitle => 'Konto anlegen';

  @override
  String get stepAccountMessage =>
      'Girokonto, Sparkonto, Bargeld oder Kreditkarte.';

  @override
  String get stepImportTitle => 'Umsätze importieren';

  @override
  String get stepImportMessage =>
      'Einen CSV- oder JSON-Export deiner Bank einlesen.';

  @override
  String get stepPlanTitle => 'Einnahmen und Zahlungen planen';

  @override
  String get stepPlanMessage =>
      'Gehalt, Miete, Versicherungen: alles, was absehbar ist.';

  @override
  String get overviewActual => 'Dieser Monat bisher';

  @override
  String get overviewPlan => 'Plan für diesen Monat';

  @override
  String get overviewUpcoming => 'Demnächst fällig';

  @override
  String uncategorizedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Umsätze brauchen eine Kategorie',
      one: '1 Umsatz braucht eine Kategorie',
    );
    return '$_temp0';
  }

  @override
  String get uncategorizedMany =>
      'Mehr als 100 Umsätze brauchen eine Kategorie';

  @override
  String get tabForecast => 'Vorschau';

  @override
  String get tabPlannedItems => 'Einnahmen & Zahlungen';

  @override
  String get tabBudgets => 'Budgets';

  @override
  String get tabGoals => 'Sparziele';

  @override
  String get forecastEmptyTitle => 'Noch nichts geplant';

  @override
  String get forecastEmptyMessage =>
      'Trage deine regelmäßigen Einnahmen und Zahlungen ein. Die Vorschau zeigt dann, was jeder Monat kostet und wie viel du sparen kannst.';

  @override
  String get forecastChartTitle => 'Was pro Monat übrig bleibt';

  @override
  String get yearlyPlus => 'Jahresplus';

  @override
  String get savingsPotential => 'Sparpotenzial';

  @override
  String savingsPotentialIn(String month) {
    return 'Sparpotenzial im $month';
  }

  @override
  String get fixedPayments => 'Feste Zahlungen';

  @override
  String get savingForGoals => 'Für Sparziele';

  @override
  String get freeAfterGoals => 'Frei verfügbar';

  @override
  String get budgetExceededByPlan =>
      'Geplante Zahlungen übersteigen dieses Budget';

  @override
  String get reserveHint => 'Für teurere Monate zurücklegen:';

  @override
  String get addPlannedItem => 'Posten planen';

  @override
  String get editPlannedItem => 'Geplanten Posten bearbeiten';

  @override
  String get deletePlannedItemTitle => 'Diesen geplanten Posten löschen?';

  @override
  String get plannedEmptyTitle => 'Keine Einnahmen oder Zahlungen geplant';

  @override
  String get plannedEmptyMessage =>
      'Trage ein, was sich wiederholt (Gehalt, Miete, Abos) und was einmalig ansteht (eine Reparatur, eine Prämie).';

  @override
  String get plannedIncome => 'Einnahmen';

  @override
  String get plannedPayments => 'Zahlungen';

  @override
  String get plannedIncomeHint => 'z. B. Gehalt';

  @override
  String get plannedPaymentHint => 'z. B. Miete';

  @override
  String get avgMonthlyIncome => 'Einnahmen pro Monat (Schnitt)';

  @override
  String get avgMonthlyPayments => 'Zahlungen pro Monat (Schnitt)';

  @override
  String get repeats => 'Wiederholung';

  @override
  String get recurrenceOnce => 'Einmalig';

  @override
  String get recurrenceWeekly => 'Wöchentlich';

  @override
  String get recurrenceMonthly => 'Monatlich';

  @override
  String get recurrenceQuarterly => 'Vierteljährlich';

  @override
  String get recurrenceHalfYearly => 'Halbjährlich';

  @override
  String get recurrenceYearly => 'Jährlich';

  @override
  String recurrenceEveryNWeeks(int count) {
    return 'Alle $count Wochen';
  }

  @override
  String recurrenceEveryNMonths(int count) {
    return 'Alle $count Monate';
  }

  @override
  String recurrenceEveryNYears(int count) {
    return 'Alle $count Jahre';
  }

  @override
  String nextOn(String date) {
    return 'nächste $date';
  }

  @override
  String get dueDate => 'Fällig am';

  @override
  String get firstDueDate => 'Erstmals fällig am';

  @override
  String get endDateOptional => 'Endet am (optional)';

  @override
  String get activePlannedHint => 'Pausierte Posten fehlen in der Vorschau.';

  @override
  String get addBudget => 'Budget anlegen';

  @override
  String get editBudget => 'Budget bearbeiten';

  @override
  String get deleteBudgetTitle => 'Dieses Budget löschen?';

  @override
  String get budgetsEmptyTitle => 'Noch keine Budgets';

  @override
  String get budgetsEmptyMessage =>
      'Ein Budget ist ein Monatslimit für eine oder mehrere Kategorien, etwa Lebensmittel.';

  @override
  String budgetsThisMonth(String month) {
    return '$month';
  }

  @override
  String get budgetNotActive => 'In diesem Monat nicht aktiv';

  @override
  String get budgetNoCategories => 'Keine Kategorien zugeordnet';

  @override
  String get budgetPerMonth => 'Limit pro Monat';

  @override
  String get budgetCategories => 'Kategorien';

  @override
  String get budgetCategoriesHint =>
      'Ausgaben in diesen Kategorien zählen zum Budget. Eine Hauptkategorie schließt ihre Unterkategorien ein.';

  @override
  String get validFrom => 'Ab';

  @override
  String get validUntilOptional => 'Bis (optional)';

  @override
  String get addGoal => 'Sparziel anlegen';

  @override
  String get editGoal => 'Sparziel bearbeiten';

  @override
  String get deleteGoalTitle => 'Dieses Sparziel löschen?';

  @override
  String get goalsEmptyTitle => 'Noch keine Sparziele';

  @override
  String get goalsEmptyMessage =>
      'Lege einen Betrag und einen Monat fest, etwa den Urlaub im nächsten Sommer. Der Plan zeigt, wie viel du monatlich zurücklegen solltest.';

  @override
  String get goalNameHint => 'z. B. Urlaub';

  @override
  String get goalTarget => 'Zielbetrag';

  @override
  String get goalAlreadySaved => 'Bereits gespart';

  @override
  String get goalNeededBy => 'Benötigt bis';

  @override
  String goalBy(String month) {
    return 'bis $month';
  }

  @override
  String get goalReached => 'Erreicht';

  @override
  String get goalOnTrack => 'Im Plan';

  @override
  String get goalBehind => 'Hinter dem Plan';

  @override
  String get goalMonthlyRate => 'Nötig pro Monat';

  @override
  String get goalOnTrackHint => 'Dein Plan lässt jeden Monat genug übrig.';

  @override
  String get goalFrontLoadedHint =>
      'Erreichbar, wenn du in den ersten Monaten mehr sparst.';

  @override
  String get goalShortBy => 'Es fehlen';

  @override
  String goalReachableIn(String month) {
    return 'erreichbar im $month';
  }

  @override
  String get addTransaction => 'Umsatz hinzufügen';

  @override
  String get editTransaction => 'Umsatz bearbeiten';

  @override
  String get deleteTransactionTitle => 'Diesen Umsatz löschen?';

  @override
  String get transactionNeedsAccount =>
      'Umsätze gehören zu einem Konto. Lege zuerst eines an.';

  @override
  String get searchTransactions => 'Umsätze durchsuchen';

  @override
  String get noTransactionsTitle => 'Noch keine Umsätze';

  @override
  String get noTransactionsMessage =>
      'Importiere einen Export deiner Bank oder trage Umsätze von Hand ein.';

  @override
  String get noTransactionsFound => 'Keine passenden Umsätze';

  @override
  String get importBankFile => 'Bankdatei importieren';

  @override
  String get importShort => 'Import';

  @override
  String get period => 'Zeitraum';

  @override
  String get periodAll => 'Gesamter Zeitraum';

  @override
  String get periodThisMonth => 'Dieser Monat';

  @override
  String get periodLastMonth => 'Letzter Monat';

  @override
  String get periodThisYear => 'Dieses Jahr';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get changeCategory => 'Kategorie ändern';

  @override
  String categorySetTo(String name) {
    return 'Kategorie auf $name gesetzt';
  }

  @override
  String get createRule => 'Regel anlegen';

  @override
  String get createRuleFromTransaction => 'Regel aus diesem Umsatz erstellen';

  @override
  String get suggested => 'vorgeschlagen';

  @override
  String get byCategory => 'Nach Kategorie';

  @override
  String get noTransactionsInMonth => 'Keine Umsätze in diesem Monat';

  @override
  String get trendTitle => 'Letzte 12 Monate';

  @override
  String get planVsActual => 'Plan und Wirklichkeit';

  @override
  String get planned => 'Geplant';

  @override
  String get actual => 'Tatsächlich';

  @override
  String get difference => 'Besser / schlechter';

  @override
  String get addAccount => 'Konto anlegen';

  @override
  String get editAccount => 'Konto bearbeiten';

  @override
  String get deleteAccountTitle => 'Dieses Konto löschen?';

  @override
  String get deleteAccountMessage =>
      'Alle Umsätze dieses Kontos werden mitgelöscht. Um sie zu behalten, archiviere das Konto stattdessen.';

  @override
  String get noAccountsTitle => 'Noch keine Konten';

  @override
  String get noAccountsMessage =>
      'Lege die Konten an, die du im Blick behalten möchtest.';

  @override
  String get accountKind => 'Art';

  @override
  String get accountKindChecking => 'Girokonto';

  @override
  String get accountKindSavings => 'Sparkonto';

  @override
  String get accountKindCash => 'Bargeld';

  @override
  String get accountKindCreditCard => 'Kreditkarte';

  @override
  String get accountKindInvestment => 'Depot';

  @override
  String get ibanOptional => 'IBAN (optional)';

  @override
  String get openingBalance => 'Anfangsbestand';

  @override
  String get openingDate => 'Stand vom';

  @override
  String get archivedAccountHint =>
      'In Listen ausgeblendet; die Umsätze bleiben erhalten.';

  @override
  String get addCategory => 'Kategorie anlegen';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get deleteCategoryTitle => 'Diese Kategorie löschen?';

  @override
  String get deleteCategoryMessage =>
      'Unterkategorien und Regeln werden mitgelöscht. Umsätze bleiben, verlieren aber ihre Kategorie.';

  @override
  String get categoryKind => 'Art';

  @override
  String get categoryKindExpense => 'Ausgaben';

  @override
  String get categoryKindIncome => 'Einnahmen';

  @override
  String get categoryKindTransfer => 'Umbuchungen zwischen eigenen Konten';

  @override
  String get parentCategory => 'Gehört zu';

  @override
  String get noParentCategory => 'Keine (Hauptkategorie)';

  @override
  String get archivedCategoryHint =>
      'Wird für neue Umsätze nicht mehr angeboten.';

  @override
  String get searchCategories => 'Kategorien durchsuchen';

  @override
  String get noCategoriesFound => 'Keine Kategorien gefunden';

  @override
  String get rules => 'Regeln';

  @override
  String get addRule => 'Regel anlegen';

  @override
  String get editRule => 'Regel bearbeiten';

  @override
  String get deleteRuleTitle => 'Diese Regel löschen?';

  @override
  String get noRulesTitle => 'Noch keine Regeln';

  @override
  String get noRulesMessage =>
      'Regeln ordnen Umsätze automatisch Kategorien zu, zum Beispiel alles von deinem Supermarkt zu Lebensmittel.';

  @override
  String get rulesOrderHint =>
      'Die erste passende Regel gewinnt. Zum Umsortieren ziehen.';

  @override
  String get applyRulesNow => 'Regeln jetzt anwenden';

  @override
  String recategorizedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Umsätze aktualisiert',
      one: '1 Umsatz aktualisiert',
      zero: 'Keine Umsätze geändert',
    );
    return '$_temp0';
  }

  @override
  String get ruleConditions => 'Ein Umsatz passt, wenn';

  @override
  String get ruleMatchAll => 'alle Bedingungen zutreffen';

  @override
  String get ruleMatchAny => 'eine Bedingung zutrifft';

  @override
  String get ruleField => 'Feld';

  @override
  String get ruleOperator => 'Bedingung';

  @override
  String get ruleValue => 'Wert';

  @override
  String get ruleAmountHint => 'Zahlungen sind negativ, z. B. -50';

  @override
  String get ruleFieldAnyText => 'Beliebiger Text';

  @override
  String get ruleOpContains => 'Enthält';

  @override
  String get ruleOpEquals => 'Ist genau';

  @override
  String get ruleOpStartsWith => 'Beginnt mit';

  @override
  String get ruleOpEndsWith => 'Endet mit';

  @override
  String get ruleOpRegex => 'Entspricht Muster';

  @override
  String get ruleOpGreaterThan => 'Ist größer als';

  @override
  String get ruleOpLessThan => 'Ist kleiner als';

  @override
  String get addCondition => 'Bedingung hinzufügen';

  @override
  String get ruleAssignCategory => 'Dann Kategorie zuweisen';

  @override
  String get ruleEnabled => 'Regel ist aktiv';

  @override
  String get importTitle => 'Umsätze importieren';

  @override
  String get importStepFile => 'Datei';

  @override
  String get importStepColumns => 'Spalten';

  @override
  String get importStepReview => 'Prüfen';

  @override
  String get chooseFile => 'Datei auswählen';

  @override
  String get chooseFileHint => 'CSV- oder JSON-Export deiner Bank';

  @override
  String get fileNotReadable => 'Diese Datei konnte nicht gelesen werden';

  @override
  String rowsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen gefunden',
      one: '1 Zeile gefunden',
    );
    return '$_temp0';
  }

  @override
  String get importNeedsAccount => 'Lege ein Konto an, in das importiert wird.';

  @override
  String get importIntoAccount => 'In Konto importieren';

  @override
  String get bankFormat => 'Bankformat';

  @override
  String get newBankFormat => 'Neues Format';

  @override
  String formatRecognised(String name) {
    return 'Als „$name“ erkannt. Die Spalten sind bereits zugeordnet.';
  }

  @override
  String get formatNew =>
      'Neues Format. Im nächsten Schritt prüfst du, welche Spalte was ist; PandaBudget merkt es sich fürs nächste Mal.';

  @override
  String get adjustColumns => 'Spalten anpassen';

  @override
  String get importPreview => 'Vorschau';

  @override
  String get importPreviewEmpty =>
      'Ordne Datum und Betrag zu, um eine Vorschau zu sehen.';

  @override
  String get rememberFormat => 'Dieses Format merken';

  @override
  String get rememberFormatHint =>
      'Dateien mit denselben Spalten werden dann automatisch erkannt.';

  @override
  String rowNumber(int count) {
    return 'Zeile $count';
  }

  @override
  String get issueMissingDate => 'Datum fehlt';

  @override
  String get issueInvalidDate => 'Datum nicht lesbar';

  @override
  String get issueMissingAmount => 'Betrag fehlt';

  @override
  String get issueInvalidAmount => 'Betrag nicht lesbar';

  @override
  String reviewNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neu',
      one: '1 neu',
      zero: 'Nichts Neues',
    );
    return '$_temp0';
  }

  @override
  String reviewCategorised(int count) {
    return '$count kategorisiert';
  }

  @override
  String reviewDuplicates(int count) {
    return '$count bereits importiert';
  }

  @override
  String reviewInvalid(int count) {
    return '$count nicht lesbar';
  }

  @override
  String get alreadyImported => 'bereits importiert';

  @override
  String importAction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Umsätze importieren',
      one: '1 Umsatz importieren',
      zero: 'Nichts zu importieren',
    );
    return '$_temp0';
  }

  @override
  String importedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Umsätze importiert',
      one: '1 Umsatz importiert',
    );
    return '$_temp0';
  }

  @override
  String get importProfiles => 'Bankformate';

  @override
  String get addImportProfile => 'Format anlegen';

  @override
  String get editImportProfile => 'Bankformat bearbeiten';

  @override
  String get deleteImportProfileTitle => 'Dieses Bankformat löschen?';

  @override
  String get noImportProfilesTitle => 'Keine Bankformate gespeichert';

  @override
  String get noImportProfilesMessage =>
      'Ein Format wird gespeichert, wenn du zum ersten Mal eine Datei einer Bank importierst.';

  @override
  String mappedColumns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spalten',
      one: '1 Spalte',
    );
    return '$_temp0';
  }

  @override
  String get mappingIncomplete => 'Ordne alle mit * markierten Spalten zu';

  @override
  String get profileName => 'Name des Formats';

  @override
  String get profileNameHint => 'Meist die Bank';

  @override
  String get fileFormat => 'Dateiformat';

  @override
  String get fileType => 'Dateityp';

  @override
  String get delimiter => 'Trennzeichen';

  @override
  String get detectAutomatically => 'Erkennen';

  @override
  String get delimiterSemicolon => 'Semikolon ;';

  @override
  String get delimiterComma => 'Komma ,';

  @override
  String get delimiterTab => 'Tabulator';

  @override
  String get delimiterPipe => 'Senkrechter Strich |';

  @override
  String get encoding => 'Zeichensatz';

  @override
  String get headerRow => 'Zeile der Kopfzeile';

  @override
  String get headerRowHint => 'Leer lassen, um sie zu erkennen';

  @override
  String get jsonRootPath => 'Pfad zu den Umsätzen';

  @override
  String get jsonRootPathHint =>
      'z. B. data.transactions; leer lassen, um ihn zu erkennen';

  @override
  String get dateFormat => 'Datumsformat';

  @override
  String get decimalSeparator => 'Dezimaltrennzeichen';

  @override
  String get decimalComma => 'Komma (1.234,56)';

  @override
  String get decimalPoint => 'Punkt (1,234.56)';

  @override
  String get amountLayout => 'Beträge stehen als';

  @override
  String get amountModeSigned => 'Eine Spalte mit Vorzeichen';

  @override
  String get amountModeDebitCredit => 'Getrennte Soll- und Haben-Spalten';

  @override
  String get amountModeIndicator => 'Betrag plus Soll/Haben-Kennzeichen';

  @override
  String get debitIndicators => 'Werte, die Soll bedeuten';

  @override
  String get debitIndicatorsHint => 'Durch Kommas getrennt';

  @override
  String get invertSign => 'Vorzeichen umkehren';

  @override
  String get invertSignHint =>
      'Für Exporte, die Zahlungen als positive Zahlen ausweisen.';

  @override
  String get columnMapping => 'Spalten';

  @override
  String get columnNameHint => 'Spaltenname in der Datei';

  @override
  String get notMapped => 'Nicht verwendet';

  @override
  String get importFieldDebit => 'Soll (Ausgang)';

  @override
  String get importFieldCredit => 'Haben (Eingang)';

  @override
  String get importFieldIndicator => 'Soll/Haben-Kennzeichen';

  @override
  String get importHistory => 'Importverlauf';

  @override
  String get noImportsTitle => 'Noch nichts importiert';

  @override
  String get noImportsMessage =>
      'Jeder Import wird hier aufgeführt und lässt sich als Ganzes rückgängig machen.';

  @override
  String get undoImportTitle => 'Diesen Import rückgängig machen?';

  @override
  String undoImportMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Die $count dabei hinzugefügten Umsätze werden gelöscht.',
      one: 'Der dabei hinzugefügte Umsatz wird gelöscht.',
    );
    return '$_temp0';
  }

  @override
  String get settingsData => 'Deine Daten';

  @override
  String get settingsAccountsHint => 'Girokonten, Sparkonten, Bargeld, Karten';

  @override
  String get settingsCategoriesHint =>
      'Wonach Einnahmen und Ausgaben sortiert werden';

  @override
  String get settingsRulesHint => 'Umsätze automatisch kategorisieren';

  @override
  String get settingsImportProfilesHint =>
      'Gespeicherte Spaltenzuordnungen je Bank';

  @override
  String get settingsImportHistoryHint =>
      'Importe ansehen und rückgängig machen';

  @override
  String get settingsCategorisation => 'Kategorisierung';

  @override
  String get categoriseUncategorised => 'Offene Umsätze kategorisieren';

  @override
  String get categoriseUncategorisedHint =>
      'Wendet Regeln und gelernte Vorschläge auf Umsätze ohne Kategorie an.';

  @override
  String get rebuildLearning => 'Vorschläge neu lernen';

  @override
  String get rebuildLearningHint =>
      'Baut neu auf, was PandaBudget aus deinen Regeln und manuellen Zuordnungen gelernt hat.';

  @override
  String get rebuildLearningDone => 'Vorschläge neu gelernt';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get currency => 'Währung';
}
