import 'package:flutter/material.dart';

class FormWrapper extends StatelessWidget {
  final List<Widget> children;
  final AppBar? appBar;
  final GlobalKey<FormState> formKey;

  const FormWrapper({
    super.key,
    required this.formKey,
    required this.children,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Form(
        key: formKey,
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
