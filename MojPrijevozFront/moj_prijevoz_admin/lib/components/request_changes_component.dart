import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/providers/request_changes_provider.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:provider/provider.dart';

class RequestChangesComponent<T extends JsonResponse> extends StatefulWidget {
  final T entity;
  final GlobalKey<FormState> formKey;
  const RequestChangesComponent({
    super.key,
    required this.entity,
    required this.formKey,
  });

  @override
  State<StatefulWidget> createState() => _RequestChangesComponentState<T>();
}

class _RequestChangesComponentState<T extends JsonResponse>
    extends State<RequestChangesComponent<T>> {
  late final Iterable<MapEntry<String, dynamic>> entityEntries;
  @override
  void initState() {
    entityEntries = widget.entity.toJson().entries.where(
      (it) => it.key != "id" && it.key != "status" && it.key != "registeredAt",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestChangesProvider>().createControllers(entityEntries);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Consumer<RequestChangesProvider>(
        builder: (context, provider, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextTitleMedium("Zatraži izmjene"),
                      ...entityEntries.map(
                        (e) => CheckboxListTile(
                          value: provider.getValue(e.key),
                          onChanged: (val) => provider.toogleItem(e.key),
                          title: Text(fieldsMap<T>()[e.key]!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextTitleMedium("Napomene"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: entityEntries
                              .map(
                                (e) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextBodyLarge(fieldsMap<T>()[e.key]!),
                                    TextFormField(
                                      maxLength: 64,
                                      controller: provider
                                          .noteEditingControllers[e.key],
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          if (value.length > 64) {
                                            return "Maksimalan broj karaktera je 64";
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
