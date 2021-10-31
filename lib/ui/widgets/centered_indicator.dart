import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenteredIndicator extends StatelessWidget {
  const CenteredIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isIOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator()
    );
  }

}