import 'package:example/common/base_scaffold.dart';
import 'package:example/common/properties/bool_property.dart';
import 'package:example/common/properties/enum_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum NotifyAbout {
  all,
  mentions,
  nothing;

  String get message {
    return switch (this) {
      all => 'All new messages',
      mentions => 'Direct messages and mentions',
      nothing => 'Nothing',
    };
  }
}

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  NotifyAbout? value;
  bool enabled = true;
  Axis axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'RadioGroup',
      crossAxisAlignment: CrossAxisAlignment.start,
      editable: [
        MyBoolProperty(
          label: 'Enabled',
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        MyEnumProperty(
          label: 'Axis',
          value: axis,
          onChanged: (value) => setState(() => axis = value),
          values: Axis.values,
        ),
      ],
      children: [
        ShadRadioGroup<NotifyAbout>(
          enabled: enabled,
          initialValue: value,
          onChanged: (v) {
            print('onChange $v');
          },
          axis: axis,
          items: NotifyAbout.values.map(
            (e) => ShadRadio(
              value: e,
              label: Text(e.message),
            ),
          ),
        ),
      ],
    );
  }
}
