// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi User!`
  String get hiUser {
    return Intl.message(
      'Hi User!',
      name: 'hiUser',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: 'Label for changing the password',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: 'Label for the old password input field',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: 'Label for the new password input field',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Button label to cancel an action',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Button label to confirm an action',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get passwordUpdated {
    return Intl.message(
      'Password updated successfully',
      name: 'passwordUpdated',
      desc: 'Message shown when the password update is successful',
      args: [],
    );
  }

  /// `Error updating password`
  String get errorUpdatingPassword {
    return Intl.message(
      'Error updating password',
      name: 'errorUpdatingPassword',
      desc: 'Message shown when there is an error updating the password',
      args: [],
    );
  }

  /// `Token unavailable`
  String get tokenUnavailable {
    return Intl.message(
      'Token unavailable',
      name: 'tokenUnavailable',
      desc: 'Message shown when the authentication token is missing or invalid',
      args: [],
    );
  }


  /// `Welcome to Focused`
  String get welcomeMessage {
    return Intl.message(
      'Welcome to Focused',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }
  /// `Task Description`
  String get taskDescription {
    return Intl.message(
      'Task Description',
      name: 'taskDescription',
      desc: 'Label for the task description input field',
      args: [],
    );
  }

  /// `Task Priority`
  String get taskPriority {
    return Intl.message(
      'Task Priority',
      name: 'taskPriority',
      desc: 'Label for the task priority input field',
      args: [],
    );
  }
  /// `No due time`
  String get noDueTime {
    return Intl.message(
      'No due time',
      name: 'noDueTime',
      desc: 'Label indicating that there is no due time set for a task',
    );
  }

  /// `No notifications available.`
  String get noNotifications {
    return Intl.message(
      'No notifications available.',
      name: 'noNotifications',
      desc: 'Message displayed when there are no notifications',
      args: [],
    );
  }

  /// `Task Due Date`
  String get taskDueDate {
    return Intl.message(
      'Task Due Date',
      name: 'taskDueDate',
      desc: 'Label for the task due date input field',
      args: [],
    );
  }

  /// `Invalid input. Please check your entries.`
  String get invalidInput {
    return Intl.message(
      'Invalid input. Please check your entries.',
      name: 'invalidInput',
      desc: 'Error message for invalid input in task editing',
      args: [],
    );
  }
  /// `Tools`
  String get tools {
    return Intl.message(
      'Tools',
      name: 'tools',
      desc: '',
      args: [],
    );
  }

  /// `Pomodoro`
  String get pomodoro {
    return Intl.message(
      'Pomodoro',
      name: 'pomodoro',
      desc: '',
      args: [],
    );
  }

  /// `To-Do`
  String get toDo {
    return Intl.message(
      'To-Do',
      name: 'toDo',
      desc: '',
      args: [],
    );
  }

  /// `Meditation`
  String get meditation {
    return Intl.message(
      'Meditation',
      name: 'meditation',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get appointments {
    return Intl.message(
      'Appointments',
      name: 'appointments',
      desc: '',
      args: [],
    );
  }

  /// `Flashcards`
  String get flashcards {
    return Intl.message(
      'Flashcards',
      name: 'flashcards',
      desc: '',
      args: [],
    );
  }

  /// `Medication`
  String get medication {
    return Intl.message(
      'Medication',
      name: 'medication',
      desc: '',
      args: [],
    );
  }

  /// `Add Task`
  String get addTask {
    return Intl.message(
      'Add Task',
      name: 'addTask',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get editTask {
    return Intl.message(
      'Edit Task',
      name: 'editTask',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Pomodoro Settings`
  String get pomodoroSettings {
    return Intl.message(
      'Pomodoro Settings',
      name: 'pomodoroSettings',
      desc: '',
      args: [],
    );
  }

  /// `Work (minutes)`
  String get workMinutes {
    return Intl.message(
      'Work (minutes)',
      name: 'workMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Short Break (minutes)`
  String get shortBreakMinutes {
    return Intl.message(
      'Short Break (minutes)',
      name: 'shortBreakMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Long Break (minutes)`
  String get longBreakMinutes {
    return Intl.message(
      'Long Break (minutes)',
      name: 'longBreakMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Intervals`
  String get intervals {
    return Intl.message(
      'Intervals',
      name: 'intervals',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Enter {label}`
  String enterValue(Object label) {
    return Intl.message(
      'Enter $label',
      name: 'enterValue',
      desc: '',
      args: [label],
    );
  }

  /// `Filter by`
  String get filterBy {
    return Intl.message(
      'Filter by',
      name: 'filterBy',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pendingFilter {
    return Intl.message(
      'Pending',
      name: 'pendingFilter',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completedFilter {
    return Intl.message(
      'Completed',
      name: 'completedFilter',
      desc: '',
      args: [],
    );
  }

  /// `No appointments found`
  String get noAppointments {
    return Intl.message(
      'No appointments found',
      name: 'noAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load appointments.`
  String get errorLoadingAppointments {
    return Intl.message(
      'Unable to load appointments.',
      name: 'errorLoadingAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load appointments.`
  String get errorLoading {
    return Intl.message(
      'Unable to load.',
      name: 'errorLoading',
      desc: '',
      args: [],
    );
  }


  /// `Invalid or expired token.`
  String get invalidToken {
    return Intl.message(
      'Invalid or expired token.',
      name: 'invalidToken',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching appointments`
  String get errorFetchingAppointments {
    return Intl.message(
      'Error fetching appointments',
      name: 'errorFetchingAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Psychologist`
  String get psychologist {
    return Intl.message(
      'Psychologist',
      name: 'psychologist',
      desc: '',
      args: [],
    );
  }

  /// `Psychiatrist`
  String get psychiatrist {
    return Intl.message(
      'Psychiatrist',
      name: 'psychiatrist',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Dr.`
  String get doctor {
    return Intl.message(
      'Dr.',
      name: 'doctor',
      desc: '',
      args: [],
    );
  }

  /// `Virtual`
  String get virtual {
    return Intl.message(
      'Virtual',
      name: 'virtual',
      desc: '',
      args: [],
    );
  }

  /// `from`
  String get from {
    return Intl.message(
      'from',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `All Flashcards`
  String get allFlashcards {
    return Intl.message(
      'All Flashcards',
      name: 'allFlashcards',
      desc: '',
      args: [],
    );
  }

  /// `Edit Flashcard`
  String get editFlashcard {
    return Intl.message(
      'Edit Flashcard',
      name: 'editFlashcard',
      desc: '',
      args: [],
    );
  }

  /// `Delete Flashcard`
  String get deleteFlashcard {
    return Intl.message(
      'Delete Flashcard',
      name: 'deleteFlashcard',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this flashcard?`
  String get deleteFlashcardConfirmation {
    return Intl.message(
      'Are you sure you want to delete this flashcard?',
      name: 'deleteFlashcardConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No flashcards available`
  String get noFlashcardsAvailable {
    return Intl.message(
      'No flashcards available',
      name: 'noFlashcardsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get level {
    return Intl.message(
      'Level',
      name: 'level',
      desc: '',
      args: [],
    );
  }


  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `No Question`
  String get noQuestion {
    return Intl.message(
      'No Question',
      name: 'noQuestion',
      desc: '',
      args: [],
    );
  }

  /// `No Answer`
  String get noAnswer {
    return Intl.message(
      'No Answer',
      name: 'noAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Level Complete!`
  String get levelComplete {
    return Intl.message(
      'Level Complete!',
      name: 'levelComplete',
      desc: '',
      args: [],
    );
  }

  /// `You have reviewed all the cards at this level.`
  String get reviewComplete {
    return Intl.message(
      'You have reviewed all the cards at this level.',
      name: 'reviewComplete',
      desc: '',
      args: [],
    );
  }

  /// `Task Name`
  String get taskName {
    return Intl.message(
      'Task Name',
      name: 'taskName',
      desc: '',
      args: [],
    );
  }

  /// `Delete Task`
  String get deleteTask {
    return Intl.message(
      'Delete Task',
      name: 'deleteTask',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this task?`
  String get deleteTaskConfirmation {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'deleteTaskConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No tasks available`
  String get noTasks {
    return Intl.message(
      'No tasks available',
      name: 'noTasks',
      desc: 'Message displayed when there are no tasks in the list',
      args: [],
    );
  }

  String get selectDueDate {
    return Intl.message(
      'Date',
      name: 'selectDueDate',
      desc: 'Message displayed for selecting a due date in the task popup',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: 'Title for the delete confirmation dialog',
      args: [],
    );
  }

  String get selectDueDateError {
    return Intl.message(
      'Please select a due date.',
      name: 'selectDueDateError',
      desc: 'Error message when no due date is selected',
      args: [],
    );
  }

  /// `Back to Levels`
  String get backToLevels {
    return Intl.message(
      'Back to Levels',
      name: 'backToLevels',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect`
  String get incorrect {
    return Intl.message(
      'Incorrect',
      name: 'incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get correct {
    return Intl.message(
      'Correct',
      name: 'correct',
      desc: '',
      args: [],
    );
  }

  /// `There are no cards at this level.`
  String get noCardsInLevel {
    return Intl.message(
      'There are no cards at this level.',
      name: 'noCardsInLevel',
      desc: '',
      args: [],
    );
  }

  /// `Create New Flashcard`
  String get createNewFlashcard {
    return Intl.message(
      'Create New Flashcard',
      name: 'createNewFlashcard',
      desc: '',
      args: [],
    );
  }

  String get errorCreatingFlashcard {
    return Intl.message(
      'Creating Error',
      name: 'errorcreateNewFlashcard',
      desc: '',
      args: [],
    );
  }

  String get errorDeletingFlashcard {
    return Intl.message(
      'Deleting Error',
      name: 'errordeletingFlashcard',
      desc: '',
      args: [],
    );
  }

  String get errorUpdatingFlashcard {
    return Intl.message(
      'Updating Error',
      name: 'updatingFlashcard',
      desc: '',
      args: [],
    );
  }

  /// `Levels`
  String get levels {
    return Intl.message(
      'Levels',
      name: 'levels',
      desc: '',
      args: [],
    );
  }

  /// `Level 1`
  String get level1 {
    return Intl.message(
      'Level 1',
      name: 'level1',
      desc: '',
      args: [],
    );
  }

  /// `Level 2`
  String get level2 {
    return Intl.message(
      'Level 2',
      name: 'level2',
      desc: '',
      args: [],
    );
  }

  /// `Level 3`
  String get level3 {
    return Intl.message(
      'Level 3',
      name: 'level3',
      desc: '',
      args: [],
    );
  }

  /// `Review what you've learned`
  String get reviewWhatYouLearned {
    return Intl.message(
      'Review what you\'ve learned',
      name: 'reviewWhatYouLearned',
      desc: '',
      args: [],
    );
  }

  /// `View All Flashcards`
  String get viewAllFlashcards {
    return Intl.message(
      'View All Flashcards',
      name: 'viewAllFlashcards',
      desc: '',
      args: [],
    );
  }

  String get noFlashcardsFound {
    return Intl.message(
      'No Flashcards Found',
      name: 'viewFlashcardsNoFound',
      desc: '',
      args: [],
    );
  }

  /// `What is Flutter?`
  String get whatIsFlutter {
    return Intl.message(
      'What is Flutter?',
      name: 'whatIsFlutter',
      desc: '',
      args: [],
    );
  }

  /// `Explain Dart?`
  String get explainDart {
    return Intl.message(
      'Explain Dart?',
      name: 'explainDart',
      desc: '',
      args: [],
    );
  }

  /// `What is State Management?`
  String get whatIsStateManagement {
    return Intl.message(
      'What is State Management?',
      name: 'whatIsStateManagement',
      desc: '',
      args: [],
    );
  }

  /// `What is Widget tree in Flutter?`
  String get whatIsWidgetTree {
    return Intl.message(
      'What is Widget tree in Flutter?',
      name: 'whatIsWidgetTree',
      desc: '',
      args: [],
    );
  }

  /// `Explain Hot Reload in Flutter?`
  String get explainHotReload {
    return Intl.message(
      'Explain Hot Reload in Flutter?',
      name: 'explainHotReload',
      desc: '',
      args: [],
    );
  }

  /// `No flashcards available for this level`
  String get noFlashcardsForThisLevel {
    return Intl.message(
      'No flashcards available for this level',
      name: 'noFlashcardsForThisLevel',
      desc: '',
      args: [],
    );
  }

  /// `Flashcard Categories`
  String get flashcardCategories {
    return Intl.message(
      'Flashcard Categories',
      name: 'flashcardCategories',
      desc: '',
      args: [],
    );
  }

  /// `Save Category`
  String get saveCategory {
    return Intl.message(
      'Save Category',
      name: 'saveCategory',
      desc: '',
      args: [],
    );
  }

  /// `Math`
  String get math {
    return Intl.message(
      'Math',
      name: 'math',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get science {
    return Intl.message(
      'Science',
      name: 'science',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get logs {
    return Intl.message(
      'Logs',
      name: 'logs',
      desc: '',
      args: [],
    );
  }

  /// `No medications found.`
  String get noMedicationsFound {
    return Intl.message(
      'No medications found.',
      name: 'noMedicationsFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load medications.`
  String get medicationsLoadFailed {
    return Intl.message(
      'Failed to load medications.',
      name: 'medicationsLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while loading medications.`
  String get errorLoadingMedications {
    return Intl.message(
      'An error occurred while loading medications.',
      name: 'errorLoadingMedications',
      desc: '',
      args: [],
    );
  }

  /// `Medication status updated successfully.`
  String get medicationStatusUpdated {
    return Intl.message(
      'Medication status updated successfully.',
      name: 'medicationStatusUpdated',
      desc: '',
      args: [],
    );
  }

  String get flashcardUpdated {
    return Intl.message(
      'Flashcard updated successfully.',
      name: 'flashcardUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Already completed medication status.`
  String get medicationAlreadyCompleted {
    return Intl.message(
      'Already completed medication status.',
      name: 'medicationAlreadyCompleted',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while updating medication.`
  String get errorUpdatingMedication {
    return Intl.message(
      'An error occurred while updating medication.',
      name: 'errorUpdatingMedication',
      desc: '',
      args: [],
    );
  }

  /// `M,T,W,T,F,S,S`
  String get daysOfWeek {
    return Intl.message(
      'M,T,W,T,F,S,S',
      name: 'daysOfWeek',
      desc: '',
      args: [],
    );
  }

  /// `Error playing the audio.`
  String get audioPlayError {
    return Intl.message(
      'Error playing the audio.',
      name: 'audioPlayError',
      desc: '',
      args: [],
    );
  }

  /// `Meditation Selection`
  String get meditationSelection {
    return Intl.message(
      'Meditation Selection',
      name: 'meditationSelection',
      desc: '',
      args: [],
    );
  }

  /// `Select a Meditation`
  String get selectMeditation {
    return Intl.message(
      'Select a Meditation',
      name: 'selectMeditation',
      desc: '',
      args: [],
    );
  }

  /// `Guided Breathing`
  String get guidedBreathing {
    return Intl.message(
      'Guided Breathing',
      name: 'guidedBreathing',
      desc: '',
      args: [],
    );
  }

  /// `Mindfulness`
  String get mindfulness {
    return Intl.message(
      'Mindfulness',
      name: 'mindfulness',
      desc: '',
      args: [],
    );
  }

  /// `Body Scan`
  String get bodyScan {
    return Intl.message(
      'Body Scan',
      name: 'bodyScan',
      desc: '',
      args: [],
    );
  }

  /// `Loving-Kindness`
  String get lovingKindness {
    return Intl.message(
      'Loving-Kindness',
      name: 'lovingKindness',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Name of the Feature`
  String get featureName {
    return Intl.message(
      'Name of the Feature',
      name: 'featureName',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastname {
    return Intl.message(
      'Last Name',
      name: 'lastname',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message(
      'Birthdate',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }

  /// `Sex`
  String get sex {
    return Intl.message(
      'Sex',
      name: 'sex',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password`
  String get enterOldPassword {
    return Intl.message(
      'Enter your current password',
      name: 'enterOldPassword',
      desc: 'Message for missing old password',
      args: [],
    );
  }

  /// `Enter a new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter a new password',
      name: 'enterNewPassword',
      desc: 'Message for missing new password',
      args: [],
    );
  }

  /// `New password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'New password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: 'Message when new password is too short',
      args: [],
    );
  }

  /// `Unknown error occurred`
  String get unknownError {
    return Intl.message(
      'Unknown error occurred',
      name: 'unknownError',
      desc: 'Generic unknown error message',
      args: [],
    );
  }

  /// `Information updated successfully!`
  String get infoUpdated {
    return Intl.message(
      'Information updated successfully!',
      name: 'infoUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating information.`
  String get updateError {
    return Intl.message(
      'Error updating information.',
      name: 'updateError',
      desc: '',
      args: [],
    );
  }


  /// `No allergies`
  String get noAllergies {
    return Intl.message(
      'No allergies',
      name: 'noAllergies',
      desc: '',
      args: [],
    );
  }

  /// `No condition`
  String get noCondition {
    return Intl.message(
      'No condition',
      name: 'noCondition',
      desc: '',
      args: [],
    );
  }

  /// `No condition`
  String get encryptedPassword {
    return Intl.message(
      '*******',
      name: '*******',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching patient data.`
  String get errorFetchingPatient {
    return Intl.message(
      'Error fetching patient data.',
      name: 'errorFetchingPatient',
      desc: '',
      args: [],
    );
  }

  /// `All Tasks`
  String get allTasks {
    return Intl.message(
      'All Tasks',
      name: 'allTasks',
      desc: '',
      args: [],
    );
  }

  /// `To-Do`
  String get todo {
    return Intl.message(
      'To-Do',
      name: 'todo',
      desc: '',
      args: [],
    );
  }

  /// `To-Do Categories`
  String get todoCategories {
    return Intl.message(
      'To-Do Categories',
      name: 'todoCategories',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get dateTime {
    return Intl.message(
      'Date & Time',
      name: 'dateTime',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled`
  String get scheduled {
    return Intl.message(
      'Scheduled',
      name: 'scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Tap to flip and see the answer`
  String get questionPlaceholder {
    return Intl.message(
      'Tap to flip and see the answer',
      name: 'questionPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Tap to flip and see the question`
  String get answerPlaceholder {
    return Intl.message(
      'Tap to flip and see the question',
      name: 'answerPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get levelIndicator {
    return Intl.message(
      'Level',
      name: 'levelIndicator',
      desc: '',
      args: [],
    );
  }

  /// `No medications available for this time.`
  String get noMedications {
    return Intl.message(
      'No medications available for this time.',
      name: 'noMedications',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Focus on your task`
  String get focusOnTask {
    return Intl.message(
      'Focus on your task',
      name: 'focusOnTask',
      desc: '',
      args: [],
    );
  }

  /// `Take a short break`
  String get shortBreak {
    return Intl.message(
      'Take a short break',
      name: 'shortBreak',
      desc: '',
      args: [],
    );
  }

  /// `Take a long break`
  String get longBreak {
    return Intl.message(
      'Take a long break',
      name: 'longBreak',
      desc: '',
      args: [],
    );
  }

  String get sessionCompleted  {
    return Intl.message(
      'Session Completed',
      name: 'Finalized',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Task Manager`
  String get taskManager {
    return Intl.message(
      'Task Manager',
      name: 'taskManager',
      desc: '',
      args: [],
    );
  }

  /// `Add To-Do Category`
  String get toDoAddCategory {
    return Intl.message(
      'Add To-Do Category',
      name: 'toDoAddCategory',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Appointment`
  String get appointment {
    return Intl.message(
      'Appointment',
      name: 'appointment',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get editCategory {
    return Intl.message(
      'Edit Category',
      name: 'editCategory',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }
}

String get categoryDeleted {
  return Intl.message(
    'Delete Category',
    name: 'DeleteCategory',
    desc: '',
    args: [],
  );
}


class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
