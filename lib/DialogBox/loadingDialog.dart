import 'package:flutter/material.dart';
import 'package:icar/widgets/loadingWidget.dart';

class LoadingAlertDialog extends StatelessWidget {

  final String? message;

  const LoadingAlertDialog({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(
            height: 10.0,

          ),
          Text('Authenticating, Please Wait'),
        ],
      ),
    );
  }
}
