import 'package:flutter/material.dart';

class FormWrapper extends StatelessWidget {
  final List<Widget> children;
  final AppBar? appBar;

  const FormWrapper({super.key, required this.children, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Form(
        key: key,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
      ),
    );
  }
}
