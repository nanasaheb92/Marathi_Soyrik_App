import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../common/color_pallete.dart';
import '../../../../common/utils.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_field.dart';
import '../../../components/ui/text_view.dart';
import 'package:dropdown_search/dropdown_search.dart';

enum InputType { TEXT, DATE, TIME, DROP_DOWN, MULTI_SELECT, DROP_DOWN_SEARCHABLE }

class MyFormField extends StatelessWidget {
  final String fieldName;
  late String? initialValue;
  final InputType type;
  final TextInputType keyboard;
  final String? Function(String? value)? validator;
  final List? dropDownOptions;
  final List<String>? dropDownSearchableOptions;
  final Function(String value) onChanged;
  final bool? required;
  final bool? showFieldName;
  final TextEditingController? controller;

  MyFormField({
    super.key,
    required this.fieldName,
    required this.type,
    required this.keyboard,
    this.validator,
    this.dropDownOptions,
    this.dropDownSearchableOptions,
    required this.onChanged,
    this.required,
    this.showFieldName,
    this.initialValue, this.controller
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: MyListView(
        children: [
          if (showFieldName ?? true)
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: TextView(
                text: "$fieldName${(required ?? false) ? "*" : ""}",
                fontSize: 14,
                weight: FontWeight.w600,
              ),
            ),
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                color: ColorPallete.theme,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: ColorPallete.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))]),
            child: RoundedContainer(
              radius: 10,
              // borderColor: ColorPallete.grey,
              // borderColor: ColorPallete.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: type == InputType.DROP_DOWN
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                key: UniqueKey(),
                                isExpanded: true,
                                // selectedItemBuilder: (context) {
                                //   return dropDownOptions!
                                //       .map((e) => TextView(
                                //             text: e,
                                //             overflow: TextOverflow.ellipsis,
                                //           ))
                                //       .toList();
                                // },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: fieldName,
                                  hintStyle: SafeGoogleFont('Roboto', fontSize: 14, fontWeight: FontWeight.w400, color: ColorPallete.grey),
                                  errorStyle: SafeGoogleFont('Roboto', fontSize: 14, fontWeight: FontWeight.w400, color: ColorPallete.red),
                                ),
                                value: dropDownOptions!.contains(initialValue ?? "") ? initialValue : null,
                                style: const TextStyle(
                                  color: ColorPallete.primary,
                                ),
                                items: dropDownOptions!
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: TextView(
                                          text: e,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    onChanged(value);
                                  }
                                },
                                validator: required ?? false
                                    ? validator ??
                                        (value) {
                                          return value == null || value.isEmpty ? "$fieldName is required" : null;
                                        }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )
                : type == InputType.DROP_DOWN_SEARCHABLE
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownSearch<String>(
                          key: UniqueKey(),
                          popupProps: PopupProps.menu(
                            showSearchBox: true, // Enables search
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "Search...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          items: dropDownSearchableOptions ?? [],
                          selectedItem: dropDownSearchableOptions!.contains(initialValue ?? "") ? initialValue : null,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: fieldName,
                              hintStyle: SafeGoogleFont(
                                'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPallete.grey,
                              ),
                              errorStyle: SafeGoogleFont(
                                'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorPallete.red,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              onChanged(value);
                            }
                          },
                          validator: required ?? false
                              ? validator ??
                                  (value) {
                                return value == null || value.isEmpty
                                    ? "$fieldName is required"
                                    : null;
                              }
                              : null,
                        ),
                      ),
                    ],
                  ),
                )
                    : type == InputType.DATE
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: MyTextField(
                              controller: controller,
                              readOnly: true,
                              //initialValue: initialValue,
                              hintText: fieldName,
                              hintColor: ColorPallete.grey,
                              textColor: ColorPallete.primary,
                              onChanged: (value) {
                                //onChanged(DateFormat("dd-MM-yyyy").format(value!));
                                onChanged(value);
                              },
                              validator: required ?? false
                                  ? (value) {
                                      return value!.isEmpty ? "${fieldName} is required" : null;
                                    }
                                  : null,
                              onTap: () async {
                                print("initialValue $initialValue");
                                //DateTime? date = initialValue == null ? null : DateFormat("yyyy-MM-dd").parse(initialValue!);

                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900), // Adjust as per your requirement
                                  lastDate: DateTime.now(),
                                );
                                print("selectedDate $selectedDate");

                                if (selectedDate != null) {
                                  // Format date if required (e.g., dd/MM/yyyy)
                                  String formattedDate = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

                                  initialValue = formattedDate; // Update your model
                                  controller?.text = formattedDate;
                                  print("selectedDate $formattedDate");
                                  //onChanged(formattedDate);
                                }
                              },
                            ),
                          )
                        : type == InputType.TIME
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: TimePickerField(
                                  intialValue: initialValue,
                                  fieldName: fieldName,
                                  isRequired: required ?? false,
                                  onChanged: (value) {
                                    onChanged(value);
                                  },
                                ),
                              )
                            : type == InputType.MULTI_SELECT
                                ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                    child: MultiSelectDialogField(
                                      title: TextView(
                                        text: "Select $fieldName",
                                        fontSize: 16,
                                      ),
                                      initialValue: (initialValue ?? "").split(",").toList(),
                                      backgroundColor: ColorPallete.theme,
                                      selectedColor: ColorPallete.primary,
                                      selectedItemsTextStyle: const TextStyle(color: ColorPallete.primary, fontSize: 15),
                                      buttonIcon: Icon(Icons.check),
                                      itemsTextStyle: const TextStyle(color: ColorPallete.secondary, fontSize: 15),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      items: dropDownOptions!.map((e) => MultiSelectItem(e, e)).toList(),
                                      listType: MultiSelectListType.LIST,
                                      confirmText: const Text(
                                        "CONFIRM",
                                        style: TextStyle(color: ColorPallete.primary),
                                      ),
                                      cancelText: const Text(
                                        "CANCEL",
                                        style: TextStyle(color: ColorPallete.secondary),
                                      ),
                                      onConfirm: (values) {
                                        onChanged(
                                          values.length == 1 ? values.first : values.reduce((value, element) => "$value,$element"),
                                        );
                                      },
                                      searchable: true,
                                      searchHintStyle: TextStyle(color: ColorPallete.grey),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.5),
                                    child: MyTextField(
                                      initialValue: initialValue,
                                      keyboardType: keyboard,
                                      hintText: fieldName,
                                      textColor: ColorPallete.primary,
                                      hintColor: ColorPallete.grey,
                                      onChanged: onChanged,
                                      validator: required ?? false
                                          ? keyboard == TextInputType.emailAddress
                                              ? (value) {
                                                  return getEmailValidator(fieldName, value);
                                                }
                                              : keyboard == TextInputType.phone
                                                  ? (value) {
                                                      return getPhoneNumberValidator(fieldName, value);
                                                    }
                                                  : validator ??
                                                      (value) {
                                                        return value == null || value.isEmpty ? "$fieldName is required" : null;
                                                      }
                                          : null,
                                    ),
                                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimePickerField extends StatefulWidget {
  final String fieldName;
  final String? intialValue;
  final bool isRequired;
  final Function(String value) onChanged;

  const TimePickerField({super.key, required this.fieldName, required this.isRequired, required this.onChanged, this.intialValue});

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = widget.intialValue == null || widget.intialValue == "" ? null : TimeOfDay(hour: int.parse(widget.intialValue!.split(":")[0]), minute: int.parse(widget.intialValue!.split(":")[1]));
  }

  getTimeFromInitial(String time) {
    String date = DateFormat("HH:mm").format(DateFormat("hh:mma").parse(time.replaceAll(" ", "")));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.intialValue == null || widget.intialValue == "") {
      time = null;
    } else {
      String date = getTimeFromInitial(widget.intialValue!);
      time = TimeOfDay(hour: int.parse(date.split(":")[0]), minute: int.parse(date.split(":")[1]));
    }

    return StatefulBuilder(
      builder: (context, updateState) {
        return InkWell(
          onTap: () async {
            var result = await showTimePicker(context: context, initialTime: time ?? TimeOfDay.now());
            time = result;
            widget.onChanged(DateFormat("hh:mma").format(DateFormat("HH:mm").parse("${time!.hour}:${time!.minute}")));
            updateState(() {});
            // if (Focus.of(context).hasFocus) Focus.of(context).unfocus();
          },
          child: MyListView(
            children: [
              MyTextField(
                enabled: false,
                initialValue: time == null ? "" : DateFormat("hh:mma").format(DateFormat("HH:mm").parse("${time!.hour}:${time!.minute}")),
                hintText: widget.fieldName,
                hintColor: ColorPallete.grey,
                textColor: ColorPallete.primary,
                onChanged: (value) {},
                validator: widget.isRequired
                    ? (value) {
                        return value!.isEmpty ? "${widget.fieldName} is required" : null;
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

String? getEmailValidator(String fieldName, String? value) {
  RegExp emailValidation = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return value == null || value.isEmpty || !emailValidation.hasMatch(value) ? "Invalid $fieldName !" : null;
}

String? getPhoneNumberValidator(String fieldName, String? value) {
  return value == null || value.isEmpty || value.length != 10 ? "Invalid $fieldName ! Must contain 10 digits !" : null;
}
