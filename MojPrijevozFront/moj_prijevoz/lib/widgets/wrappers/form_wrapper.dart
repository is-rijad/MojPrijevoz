import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';

class FormWrapper extends StatelessWidget {
  final List<Widget> children;
  final GlobalKey<FormState> formKey;
  final MainAxisAlignment mainAxisAlignment;

  const FormWrapper({
    super.key,
    required this.formKey,
    required this.children,
    required this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    var padding = context.screenWidth * 0.05;
    return Form(
      key: formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 0),
          child: SizedBox(
            width: context.screenWidth * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
