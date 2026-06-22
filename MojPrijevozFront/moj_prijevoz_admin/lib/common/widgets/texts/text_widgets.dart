import 'package:flutter/material.dart';

class TextDisplayLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextDisplayLarge(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}

class TextDisplayMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextDisplayMedium(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }
}

class TextDisplaySmall extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextDisplaySmall(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}

class TextHeadlineMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextHeadlineMedium(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class TextHeadlineSmall extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextHeadlineSmall(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class TextTitleLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextTitleLarge(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class TextTitleMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextTitleMedium(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class TextTitleSmall extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextTitleSmall(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}

class TextBodyLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextBodyLarge(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class TextBodyMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  const TextBodyMedium(this.text, {super.key, this.textAlign, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(fontWeight: fontWeight),
    );
  }
}

class TextBodySmall extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextBodySmall(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class TextLabelLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextLabelLarge(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}

class TextLabelMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextLabelMedium(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}

class TextLabelSmall extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  const TextLabelSmall(this.text, {super.key, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
