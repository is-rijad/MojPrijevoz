import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/providers/http_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/resources/requests/report/generate_report_request.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ReportProvider {
  final httpProvider = GetIt.I<HttpProvider>();
  final uiProvider = GetIt.I<UIProvider>();
  static const String _apiUrl = "admin/report/";

  Future getReport(GenerateReportRequest request) async {
    final documentsDir = await getApplicationDocumentsDirectory();

    final filePath =
        '${documentsDir.path}/izvjestaj-${DateTime.now().millisecondsSinceEpoch}.pdf';

    await httpProvider.downloadFile(
      _apiUrl,
      filePath,
      queryParameters: request.toJson(),
    );

    Constants.messengerKey.currentState?.showSnackBar(
      SuccessSnackBar(message: "Uspješno ste preuzeli izvještaj"),
    );

    await OpenFilex.open(filePath);
  }
}
