import '../utils/BaseView.dart';

abstract class DetailView extends BaseView {
  void showAlertDialog();

  void showDialogDownload();

  void hideDialogDownload();
}
