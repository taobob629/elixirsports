import 'dart:async';
import 'dart:isolate';

import 'package:catcher_2/core/application_profile_manager.dart';
import 'package:catcher_2/mode/report_mode_action_confirmed.dart';
import 'package:catcher_2/model/application_profile.dart';
import 'package:catcher_2/model/catcher_2_options.dart';
import 'package:catcher_2/model/localization_options.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/model/report_mode.dart';
import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Catcher2 implements ReportModeAction {
  /// Builds catcher 2 instance
  Catcher2({
    this.rootWidget,
    this.runAppFunction,
    this.releaseConfig,
    this.debugConfig,
    this.profileConfig,
    this.enableLogger = true,
    this.ensureInitialized = false,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : assert(
          rootWidget != null || runAppFunction != null,
          'You need to provide rootWidget or runAppFunction',
        ) {
    _configure(navigatorKey);
  }

  static late Catcher2 _instance;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Root widget that is run using [runApp], see also [runAppFunction] if you
  /// want to customise how the widget is run
  final Widget? rootWidget;

  /// The function to be executed after setup, should at least call [runApp].
  /// See also [rootWidget] if no special configuration is necessary and only a
  /// call to [runApp] is enough.
  final void Function()? runAppFunction;

  /// Instance of catcher 2 config used in release mode
  Catcher2Options? releaseConfig;

  /// Instance of catcher 2 config used in debug mode
  Catcher2Options? debugConfig;

  /// Instance of catcher 2 config used in profile mode
  Catcher2Options? profileConfig;

  /// Should catcher 2 logs be enabled
  final bool enableLogger;

  /// Should catcher 2 run WidgetsFlutterBinding.ensureInitialized() during
  /// initialization.
  final bool ensureInitialized;

  late Catcher2Options _currentConfig;
  late Catcher2Logger _logger;
  final Map<String, dynamic> _deviceParameters = <String, dynamic>{};
  final Map<String, dynamic> _applicationParameters = <String, dynamic>{};
  final List<Report> _cachedReports = [];
  final Map<DateTime, String> _reportsOccurrenceMap = {};
  LocalizationOptions? _localizationOptions;

  /// Instance of navigator key
  static GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  void _configure(GlobalKey<NavigatorState>? navigatorKey) {
    _instance = this;
    _configureNavigatorKey(navigatorKey);
    _setupCurrentConfig();
    _setupLogger();
    _configureLogger();
    _setupReportModeActionInReportMode();

    _setupErrorHooks();

    _initWidgetsBindingAndRunApp();

    // Loading device and application info requires that the widgets binding is
    // initialized so we need to run it after we init WidgetsFlutterBinding.
    if (_currentConfig.handlers.isEmpty) {
      _logger.warning(
        'Handlers list is empty. Configure at least one handler to '
        'process error reports.',
      );
    } else {
      _logger.fine('Catcher 2 configured successfully.');
    }
  }

  void _configureNavigatorKey(GlobalKey<NavigatorState>? navigatorKey) {
    if (navigatorKey != null) {
      _navigatorKey = navigatorKey;
    } else {
      _navigatorKey = GlobalKey<NavigatorState>();
    }
  }

  void _setupCurrentConfig() {
    switch (ApplicationProfileManager.getApplicationProfile()) {
      case ApplicationProfile.release:
        _currentConfig =
            releaseConfig ?? Catcher2Options.getDefaultReleaseOptions();
      case ApplicationProfile.debug:
        _currentConfig =
            debugConfig ?? Catcher2Options.getDefaultDebugOptions();
      case ApplicationProfile.profile:
        _currentConfig =
            profileConfig ?? Catcher2Options.getDefaultProfileOptions();
    }
  }

  /// Update config after initialization
  void updateConfig({
    Catcher2Options? debugConfig,
    Catcher2Options? profileConfig,
    Catcher2Options? releaseConfig,
  }) {
    if (debugConfig != null) {
      this.debugConfig = debugConfig;
    }
    if (profileConfig != null) {
      this.profileConfig = profileConfig;
    }
    if (releaseConfig != null) {
      this.releaseConfig = releaseConfig;
    }
    _setupCurrentConfig();
    _configureLogger();
    _setupReportModeActionInReportMode();
    _localizationOptions = null;
  }

  void _setupReportModeActionInReportMode() {
    _currentConfig.reportMode.reportModeAction = this;
    _currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.reportModeAction = this;
      },
    );
  }

  void _setupLocalizationsOptionsInReportMode() {
    _currentConfig.reportMode.localizationOptions = _localizationOptions;
    _currentConfig.explicitExceptionReportModesMap.forEach(
      (error, reportMode) {
        reportMode.localizationOptions = _localizationOptions;
      },
    );
  }

  void _setupLocalizationsOptionsInReportsHandler() {
    for (final handler in _currentConfig.handlers) {
      handler.localizationOptions = _localizationOptions;
    }
  }

  Future<void> _setupErrorHooks() async {
    // FlutterError.onError catches SYNCHRONOUS errors for all platforms
    FlutterError.onError = (details) async {
      await _reportError(
        details.exception,
        details.stack,
        errorDetails: details,
      );
      _currentConfig.onFlutterError?.call(details);
    };

    // PlatformDispatcher.instance.onError catches ASYNCHRONOUS errors, but it
    // currently does not work for Web, most likely due to this issue:
    // https://github.com/flutter/flutter/issues/100277
    PlatformDispatcher.instance.onError = (error, stack) {
      _reportError(error, stack);
      _currentConfig.onPlatformError?.call(error, stack);
      return true;
    };

    // Web doesn't have Isolate error listener support
    if (!kIsWeb) {
      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final isolateError = pair as List<dynamic>;
          await _reportError(
            isolateError.first.toString(),
            isolateError.last.toString(),
          );
        }).sendPort,
      );
    }
  }

  void _initWidgetsBindingAndRunApp() {
    if (kIsWeb) {
      // Due to https://github.com/flutter/flutter/issues/100277
      // this is still needed... As soon as proper error catching support
      // for Web is implemented, this branch should be merged with the other.
      unawaited(
        runZonedGuarded<Future<void>>(
          () async {
            // It is important that we run init widgets binding inside the
            // runZonedGuarded call to be able to catch the async exceptions.
            _initWidgetsBinding();
            _runApp();
          },
          (error, stack) {
            _reportError(error, stack);
            _currentConfig.onPlatformError?.call(error, stack);
          },
        ),
      );
    } else {
      // This isn't Web, we can just run the app, no need for runZoneGuarded
      // since async errors are caught by PlatformDispatcher.instance.onError.
      _initWidgetsBinding();
      _runApp();
    }
  }

  void _runApp() {
    if (rootWidget != null) {
      runApp(rootWidget!);
    } else if (runAppFunction != null) {
      runAppFunction!();
    } else {
      throw ArgumentError('Provide rootWidget or runAppFunction to Catcher 2.');
    }
  }

  void _initWidgetsBinding() {
    if (ensureInitialized) {
      WidgetsFlutterBinding.ensureInitialized();
    }
  }

  void _setupLogger() {
    _logger = _currentConfig.logger ?? Catcher2Logger();
    if (enableLogger) {
      _logger.setup();
    }
  }

  void _configureLogger() {
    for (final handler in _currentConfig.handlers) {
      handler.logger = _logger;
    }
  }

  /// Remove excluded parameters from device parameters.
  void _removeExcludedParameters() =>
      _currentConfig.excludedParameters.forEach(_deviceParameters.remove);

  /// We need to setup localizations lazily because context needed to setup
  /// these localizations can be used after app was build for the first time.
  void _setupLocalization() {
    var locale = const Locale('en', 'US');
    if (_isContextValid()) {
      final context = _getContext();
      if (context != null) {
        locale = Localizations.localeOf(context);
      }
      if (_currentConfig.localizationOptions.isNotEmpty) {
        for (final options in _currentConfig.localizationOptions) {
          if (options.languageCode.toLowerCase() ==
              locale.languageCode.toLowerCase()) {
            _localizationOptions = options;
          }
        }
      }
    }

    _localizationOptions ??=
        _getDefaultLocalizationOptionsForLanguage(locale.languageCode);
    _setupLocalizationsOptionsInReportMode();
    _setupLocalizationsOptionsInReportsHandler();
  }

  LocalizationOptions _getDefaultLocalizationOptionsForLanguage(
    String language,
  ) {
    switch (language.toLowerCase()) {
      case 'ar':
        return LocalizationOptions.buildDefaultArabicOptions();
      case 'zh':
        return LocalizationOptions.buildDefaultChineseOptions();
      case 'hi':
        return LocalizationOptions.buildDefaultHindiOptions();
      case 'es':
        return LocalizationOptions.buildDefaultSpanishOptions();
      case 'ms':
        return LocalizationOptions.buildDefaultMalayOptions();
      case 'ru':
        return LocalizationOptions.buildDefaultRussianOptions();
      case 'pt':
        return LocalizationOptions.buildDefaultPortugueseOptions();
      case 'fr':
        return LocalizationOptions.buildDefaultFrenchOptions();
      case 'pl':
        return LocalizationOptions.buildDefaultPolishOptions();
      case 'it':
        return LocalizationOptions.buildDefaultItalianOptions();
      case 'ko':
        return LocalizationOptions.buildDefaultKoreanOptions();
      case 'nl':
        return LocalizationOptions.buildDefaultDutchOptions();
      case 'de':
        return LocalizationOptions.buildDefaultGermanOptions();
      case 'tr':
        return LocalizationOptions.buildDefaultTurkishOptions();
      default: // Also covers 'en'
        return LocalizationOptions.buildDefaultEnglishOptions();
    }
  }

  /// Report checked error (error caught in try-catch block). Catcher 2 will
  /// treat this as normal exception and pass it to handlers.
  static void reportCheckedError(error, stackTrace) {
    dynamic errorValue = error;
    dynamic stackTraceValue = stackTrace;
    errorValue ??= 'undefined error';
    stackTraceValue ??= StackTrace.current;
    _instance._reportError(error, stackTrace);
  }

  Future<void> _reportError(
    error,
    stackTrace, {
    FlutterErrorDetails? errorDetails,
  }) async {
    if ((errorDetails?.silent ?? false) && !_currentConfig.handleSilentError) {
      _logger.info(
        'Report error skipped for error: $error. HandleSilentError is false.',
      );
      return;
    }

    if (_localizationOptions == null) {
      _logger.info('Setup localization lazily!');
      _setupLocalization();
    }

    _cleanPastReportsOccurrences();

    final report = Report(
      error,
      stackTrace,
      DateTime.now(),
      _deviceParameters,
      _applicationParameters,
      _currentConfig.customParameters,
      errorDetails,
      _getPlatformType(),
    );

    if (_isReportInReportsOccurrencesMap(report)) {
      _logger.fine(
        "Error: '$error' has been skipped to due to duplication occurrence "
        'within ${_currentConfig.reportOccurrenceTimeout} ms.',
      );
      return;
    }

    if (_currentConfig.filterFunction != null &&
        !_currentConfig.filterFunction!(report)) {
      _logger.fine(
        "Error: '$error' has been filtered from Catcher 2 logs. "
        'Report will be skipped.',
      );
      return;
    }
    _cachedReports.add(report);
    var reportMode = _getReportModeFromExplicitExceptionReportModeMap(error);
    if (reportMode != null) {
      _logger.info('Using explicit report mode for error');
    } else {
      reportMode = _currentConfig.reportMode;
    }
    if (!isReportModeSupportedInPlatform(report, reportMode)) {
      _logger.warning(
        '$reportMode is not supported for ${report.platformType.name} platform',
      );
      return;
    }

    _addReportInReportsOccurrencesMap(report);

    if (reportMode.isContextRequired()) {
      if (_isContextValid()) {
        reportMode.requestAction(report, _getContext());
      } else {
        _logger.warning(
          "Couldn't use report mode because you didn't provide navigator key. "
          'Add navigator key to use this report mode.',
        );
      }
    } else {
      reportMode.requestAction(report, null);
    }
  }

  /// Check if given report mode is enabled in current platform. Only supported
  /// handlers in given report mode can be used.
  bool isReportModeSupportedInPlatform(Report report, ReportMode reportMode) =>
      reportMode.getSupportedPlatforms().contains(report.platformType);

  ReportMode? _getReportModeFromExplicitExceptionReportModeMap(error) {
    final errorName = error != null ? error.toString().toLowerCase() : '';
    ReportMode? reportMode;
    _currentConfig.explicitExceptionReportModesMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportMode = value;
        return;
      }
    });
    return reportMode;
  }

  ReportHandler? _getReportHandlerFromExplicitExceptionHandlerMap(
    error,
  ) {
    final errorName = error != null ? error.toString().toLowerCase() : '';
    ReportHandler? reportHandler;
    _currentConfig.explicitExceptionHandlersMap.forEach((key, value) {
      if (errorName.contains(key.toLowerCase())) {
        reportHandler = value;
        return;
      }
    });
    return reportHandler;
  }

  @override
  void onActionConfirmed(Report report) {
    final reportHandler =
        _getReportHandlerFromExplicitExceptionHandlerMap(report.error);
    if (reportHandler != null) {
      _logger.info('Using explicit report handler');
      _handleReport(report, reportHandler);
      return;
    }

    for (final handler in _currentConfig.handlers) {
      _handleReport(report, handler);
    }
  }

  void _handleReport(Report report, ReportHandler reportHandler) {
    if (!isReportHandlerSupportedInPlatform(report, reportHandler)) {
      _logger.warning('$reportHandler in not supported for '
          '${report.platformType.name} platform');
      return;
    }

    if (reportHandler.isContextRequired() && !_isContextValid()) {
      _logger.warning(
        "Couldn't use report handler because you didn't provide navigator key. "
        'Add navigator key to use this report mode.',
      );
      return;
    }

    reportHandler.handle(report, _getContext()).catchError((handlerError) {
      _logger.warning('Error occurred in $reportHandler: $handlerError');
      return true; // Shut up warnings
    }).then((result) {
      if (result) {
        _logger.info('$reportHandler successfully reported an error');
        _cachedReports.remove(report);
      } else {
        _logger.warning('$reportHandler failed to report an error');
      }
    }).timeout(
      Duration(milliseconds: _currentConfig.handlerTimeout),
      onTimeout: () {
        _logger.warning(
          '$reportHandler failed to report an error because of timeout',
        );
      },
    );
  }

  /// Checks is report handler is supported in given platform. Only supported
  /// report handlers in given platform can be used.
  bool isReportHandlerSupportedInPlatform(
    Report report,
    ReportHandler reportHandler,
  ) {
    if (reportHandler.getSupportedPlatforms().isEmpty) {
      return false;
    }
    return reportHandler.getSupportedPlatforms().contains(report.platformType);
  }

  @override
  void onActionRejected(Report report) {
    _currentConfig.handlers
        .where((handler) => handler.shouldHandleWhenRejected())
        .forEach((handler) {
      _handleReport(report, handler);
    });

    _cachedReports.remove(report);
  }

  BuildContext? _getContext() => navigatorKey?.currentState?.overlay?.context;

  bool _isContextValid() => navigatorKey?.currentState?.overlay != null;

  /// Get currently used config.
  Catcher2Options? getCurrentConfig() => _currentConfig;

  /// Send text exception. Used to test Catcher 2 configuration.
  static void sendTestException() {
    throw const FormatException('Test exception generated by Catcher 2');
  }

  /// Get platform type based on device.
  PlatformType _getPlatformType() {
    if (ApplicationProfileManager.isWeb()) {
      return PlatformType.web;
    }
    if (ApplicationProfileManager.isAndroid()) {
      return PlatformType.android;
    }
    if (ApplicationProfileManager.isIos()) {
      return PlatformType.iOS;
    }
    if (ApplicationProfileManager.isLinux()) {
      return PlatformType.linux;
    }
    if (ApplicationProfileManager.isWindows()) {
      return PlatformType.windows;
    }
    if (ApplicationProfileManager.isMacOS()) {
      return PlatformType.macOS;
    }

    return PlatformType.unknown;
  }

  /// Clean report occurrences from the past.
  void _cleanPastReportsOccurrences() {
    final occurrenceTimeout = _currentConfig.reportOccurrenceTimeout;
    final nowDateTime = DateTime.now();
    _reportsOccurrenceMap.removeWhere((key, value) {
      final occurrenceWithTimeout =
          key.add(Duration(milliseconds: occurrenceTimeout));
      return nowDateTime.isAfter(occurrenceWithTimeout);
    });
  }

  /// Check whether reports occurrence map contains given report.
  bool _isReportInReportsOccurrencesMap(Report report) {
    if (report.error != null) {
      return _reportsOccurrenceMap.containsValue(report.error.toString());
    } else {
      return false;
    }
  }

  /// Add report in reports occurrences map. Report will be added only when
  /// error is not null and report occurrence timeout is greater than 0.
  void _addReportInReportsOccurrencesMap(Report report) {
    if (report.error != null && _currentConfig.reportOccurrenceTimeout > 0) {
      _reportsOccurrenceMap[DateTime.now()] = report.error.toString();
    }
  }

  /// Get current Catcher 2 instance.
  static Catcher2 getInstance() => _instance;
}
