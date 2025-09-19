import 'package:flutter/material.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _buildHomePage(context));
  }

  Widget _buildHomePage(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ..._buildHeadingAndSearch(context),
            _buildNextFares(context),
            _buildSuggestedDrivers(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeadingAndSearch(BuildContext context) {
    return [
      Column(
        children: [
          const Text("Moj prijevoz"),
          const Text("Vožnja koja stiže kada Vama odgovara."),
        ],
      ),

      Form(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecorationWithIcon(iconData: Icons.location_on)
                    .copyWith(
                      hintText: "Gdje želite putovati?",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(onPressed: () => true, child: const Text("Započni")),
          ],
        ),
      ),
    ];
  }

  Widget _buildNextFares(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preporučene vožnje"),
        Container(color: Colors.amber, height: 200),
      ],
    );
  }

  Widget _buildSuggestedDrivers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preporučeni vozači"),
        Container(color: Colors.deepOrange, height: 200),
      ],
    );
  }
}
