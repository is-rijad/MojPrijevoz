import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/reports/report_period.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/reports/report_type.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/providers/report_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/report/generate_report_request.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsPageState();
}

class _ReportsPageState extends RouteAwareState<ReportsPage> {
  _ReportsPageState() : super(action: DrawerMenuAction.reports);
  final _generateReportRequest = GenerateReportRequest();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Izvještaji");
  }

  Widget _build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          DropdownMenuFormField<ReportType>(
            width: context.screenWidth * 0.2,
            onSaved: (value) => _generateReportRequest.type = value!,
            label: const TextHeadlineSmall("Tip izvještaja"),
            dropdownMenuEntries: reportTypeMap.entries
                .map((it) => DropdownMenuEntry(value: it.key, label: it.value))
                .toList(),
            validator: (value) {
              if (value == null) {
                return "Tip izvještaja ne može biti prazan";
              }
              return null;
            },
          ),
          DropdownMenuFormField<ReportPeriod>(
            width: context.screenWidth * 0.2,
            onSaved: (value) => _generateReportRequest.period = value!,
            onSelected: (value) => setState(() {
              _generateReportRequest.period = value!;
            }),
            label: const TextHeadlineSmall("Period"),
            dropdownMenuEntries: reportPeriodMap.entries
                .map((it) => DropdownMenuEntry(value: it.key, label: it.value))
                .toList(),
            validator: (value) {
              if (value == null) {
                return "Period ne može biti prazan";
              }
              return null;
            },
          ),
          if (_generateReportRequest.period == ReportPeriod.custom)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateRangePickerWidget(
                  doubleMonth: false,
                  minimumDateRangeLength: 1,
                  onDateRangeChanged: (range) {
                    _generateReportRequest.from = range?.start;
                    _generateReportRequest.to = range?.end;
                  },
                ),
              ],
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryButton(
                text: "Generiši",
                onPressed: () async => await _generateReport(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _generateReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await GetIt.I<ReportProvider>().getReport(_generateReportRequest);
    }
  }
}
