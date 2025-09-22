import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/build_helper.dart';

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
    var padding = BuildHelper.getScreenWidth(context) * 0.05;
    return Form(
      key: formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: SizedBox(
            width: BuildHelper.getScreenWidth(context) * 0.7,
            height:
                BuildHelper.getScreenHeight(context) -
                (padding * 2) -
                (context
                        .findAncestorWidgetOfExactType<Scaffold>()
                        ?.appBar
                        ?.preferredSize
                        .height ??
                    0),
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
