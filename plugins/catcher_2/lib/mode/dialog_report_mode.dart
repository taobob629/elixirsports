import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    _showDialog(report, context);
  }

  Future<void> _showDialog(Report report, BuildContext? context) async {
    await Future<void>.delayed(Duration.zero);
    if (context != null) {
      if (!context.mounted) {
        return;
      }
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => _buildErrorDialog(report, context),
      );
    }
  }

  Widget _buildErrorDialog(Report report, BuildContext context) =>
      WillPopScope(
        onWillPop: () async {
          super.onActionRejected(report);
          return true;
        },
        child: AlertDialog(
          title: Text(
            localizationOptions.dialogReportModeTitle,
            style: const TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Text(
              '${report.error}\n----------------------------\n${report.stackTrace}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => _onCancelReportClicked(context, report),
              child: Text(
                localizationOptions.dialogReportModeCancel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );

  void _onCancelReportClicked(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }

  @override
  bool isContextRequired() => true;

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}
