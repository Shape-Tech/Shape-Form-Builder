import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/string_extensions.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_text_field/custom_text_form_field.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class OptionsDataItem {
  String displayLabel;
  bool selected;
  Icon? icon;
  String? displayDescription;
  Object? object;

  OptionsDataItem({
    required this.displayLabel,
    this.selected = false,
    this.icon,
    this.displayDescription,
    this.object,
  });

  OptionsDataItem deepCopy(OptionsDataItem original) {
    return OptionsDataItem(
        displayLabel: original.displayLabel,
        selected: original.selected,
        icon: original.icon, // assuming Icon is immutable
        displayDescription: original.displayDescription,
        object: original.object); // handle deep copy if Object is complex
  }
}

class OptionFormField extends FormField<List<OptionsDataItem>> {
  OptionFormField({
    required String label,
    required String buttonText,
    String? labelDescription,
    bool multiSelectEnabled = false,
    required List<OptionsDataItem> options,
    required FormFieldSetter<List<OptionsDataItem>> onSaved,
    required FormFieldValidator<List<OptionsDataItem>> validator,
    Function()? addOption,
    List<OptionsDataItem>? originalValue,
    ShapeFormStyling? styling,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<List<OptionsDataItem>> state) {
            if (originalValue != null) {
              if (state.value == null) {
                state.setValue(originalValue);
              }
            }
            return Container(
              decoration: styling?.containerDecoration ??
                  BoxDecoration(
                    color: styling?.background ?? Colors.white,
                    border: Border.all(
                        color: styling?.border ?? Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(
                        styling?.borderRadiusMedium ?? 10),
                  ),
              child: Padding(
                padding: EdgeInsets.all(styling?.spacingMedium ?? 20.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label),
                          Spacer(),
                        ],
                      ),
                      if (labelDescription != null)
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(labelDescription)),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: OptionListPicker(
                            buttonText: buttonText,
                            multiSelectEnabled: multiSelectEnabled,
                            options: options,
                            onSaved: (value) {
                              state.setState(() {
                                state.setValue(value);
                              });
                              onSaved(value);
                            },
                            addOption: addOption,
                            styling: styling,
                          )),
                      if (originalValue != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text("Original Value:"),
                            ),
                            ListView.builder(
                                itemCount: originalValue.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return SelectedOptionsDataItem(
                                      selectedItem: originalValue[index]);
                                }),
                          ],
                        ),
                      if (state.hasError == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(state.errorText!,
                              style: TextStyle(color: Colors.red)),
                        ),
                    ]),
              ),
            );
          },
        );
}

class OptionListPicker extends StatefulWidget {
  String buttonText;
  bool multiSelectEnabled = false;
  List<OptionsDataItem> options;
  FormFieldSetter<List<OptionsDataItem>> onSaved;
  Function()? addOption;
  ShapeFormStyling? styling;
  OptionListPicker({
    Key? key,
    required this.buttonText,
    required this.multiSelectEnabled,
    required this.options,
    required this.onSaved,
    this.addOption,
    this.styling,
  }) : super(key: key);

  @override
  State<OptionListPicker> createState() => _OptionListPickerState();
}

class _OptionListPickerState extends State<OptionListPicker> {
  List<OptionsDataItem> selectedItems = [];
  List<OptionsDataItem> dialogOptions = [];
  @override
  void initState() {
    super.initState();
    selectedItems =
        widget.options.where((element) => element.selected == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (selectedItems.isNotEmpty)
        ListView.builder(
            itemCount: selectedItems.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SelectedOptionsDataItem(
                  selectedItem: selectedItems[index]);
            }),
      ElevatedButton(
        child: Container(
            width: double.infinity,
            child: Center(child: Text(widget.buttonText))),
        onPressed: () {
          _showOptionPicker(context, widget.multiSelectEnabled);
        },
        style: widget.styling?.secondaryButtonStyle ??
            FormButtonStyles.secondaryButton,
      ),
    ]);
  }

  _showOptionPicker(BuildContext context, bool multiSelectEnabled) {
    // widget.options.sort(((a, b) => a.displayLabel.compareTo(b.displayLabel)));
    widget.options.sort((a, b) {
      // First, compare selected items. Selected items come first.
      if (b.selected && !a.selected) {
        return 1;
      } else if (a.selected && !b.selected) {
        return -1;
      }

      // If both are selected or both are not selected, sort alphabetically.
      return a.displayLabel.compareTo(b.displayLabel);
    });

    for (var option in widget.options) {
      bool inSelectedOptions = selectedItems
          .where((element) =>
              element.displayLabel == option.displayLabel &&
              element.displayDescription == option.displayDescription)
          .isNotEmpty;
      bool containsOption = dialogOptions
          .where((dialoOption) =>
              dialoOption.displayLabel == option.displayLabel &&
              dialoOption.displayDescription == option.displayDescription)
          .isNotEmpty;

      if (containsOption == false) {
        dialogOptions.add(OptionsDataItem(
          displayLabel: option.displayLabel,
          selected:
              inSelectedOptions == false ? option.selected : inSelectedOptions,
          object: option.object,
        ));
      } else {
        dialogOptions
                .where((dialoOption) =>
                    dialoOption.displayLabel == option.displayLabel &&
                    dialoOption.displayDescription == option.displayDescription)
                .first
                .selected =
            inSelectedOptions == false ? option.selected : inSelectedOptions;
      }
    }
    TextEditingController searchController = TextEditingController();

    return showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (context, setDialogState) {
          void searchOptions(String query) {
            if (query.isEmpty) {
              final searchedOptions = widget.options;

              setDialogState(() {
                dialogOptions = searchedOptions;
              });
            } else {
              final searchedOptions = dialogOptions.where((option) {
                final optionLabel = option.displayLabel.toLowerCase();
                final input = query.toLowerCase();

                return optionLabel.contains(input);
              }).toList();

              setDialogState(() {
                dialogOptions = searchedOptions;
              });
            }
          }

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    widget.styling?.borderRadiusMedium ?? 10)),
            elevation: 10,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 200.00, maxWidth: 600.00, maxHeight: 700),
              child: Scaffold(
                backgroundColor: widget.styling?.background ?? Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor:
                      widget.styling?.primary ?? FormColors.primary,
                  foregroundColor: Colors.white,
                  title: Text(widget.buttonText),
                  actions: [
                    if (widget.multiSelectEnabled == true)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            setDialogState(() {
                              for (var element in widget.options) {
                                element.selected = true;
                              }
                            });
                            selectedItems = widget.options
                                .where((element) => element.selected == true)
                                .toList();
                            widget.onSaved(selectedItems);
                          });
                        },
                        child: Text('Select All'),
                      ),
                    if (widget.multiSelectEnabled == true)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            setDialogState(() {
                              for (var element in widget.options) {
                                element.selected = false;
                              }
                            });
                            selectedItems = [];
                            widget.onSaved(null);
                          });
                        },
                        child: Text('Clear'),
                      ),
                    if (widget.addOption != null)
                      IconButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            widget.addOption!();
                          },
                          icon: Icon(Icons.add)),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.all(widget.styling?.spacingMedium ?? 10),
                      child: CustomTextFormField(
                        textfieldController: searchController,
                        hintText: "Search",
                        onChanged: searchOptions,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: widget.styling?.spacingMedium ?? 10),
                            child: Container(
                              decoration: widget.styling?.containerDecoration ??
                                  BoxDecoration(
                                    color: widget.styling?.background ??
                                        Colors.white,
                                    border: Border.all(
                                        color: widget.styling?.border ??
                                            Colors.grey,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(
                                        widget.styling?.borderRadiusMedium ??
                                            10),
                                  ),
                              child: ListTile(
                                title: Text(dialogOptions[index]
                                    .displayLabel
                                    .capitalizeLabelCase()),
                                subtitle:
                                    dialogOptions[index].displayDescription !=
                                            null
                                        ? Text((dialogOptions[index]
                                                    .displayDescription ??
                                                "")
                                            .capitalizeLabelCase())
                                        : null,
                                trailing: Checkbox(
                                    value: dialogOptions[index].selected,
                                    activeColor: widget.styling?.secondary ??
                                        FormColors.secondary,
                                    onChanged: (value) {
                                      setState(() {
                                        selectItem(
                                            widget.options
                                                .firstWhere((element) =>
                                                    element.displayLabel ==
                                                    dialogOptions[index]
                                                        .displayLabel)
                                                .displayLabel,
                                            dialogContext,
                                            setDialogState);
                                      });
                                      if (widget.multiSelectEnabled == false) {
                                        Navigator.pop(dialogContext);
                                      }
                                    }),
                                onTap: () {
                                  setState(() {
                                    selectItem(
                                        widget.options
                                            .firstWhere((element) =>
                                                element.displayLabel ==
                                                dialogOptions[index]
                                                    .displayLabel)
                                            .displayLabel,
                                        dialogContext,
                                        setDialogState);
                                  });
                                  if (widget.multiSelectEnabled == false) {
                                    Navigator.pop(dialogContext);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        itemCount: dialogOptions.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  ],
                ),
                persistentFooterButtons: [
                  ElevatedButton(
                      child: Text("Save Selection"),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: widget.styling?.secondaryButtonStyle ??
                          FormButtonStyles.secondaryButton)
                ],
              ),
            ),
          );
        });
      },
    );
  }

  selectItem(
      String displayLabel, BuildContext dialogContext, Function refreshState) {
    refreshState(() {
      if (widget.multiSelectEnabled == true) {
        // Toggle the selection state
        bool newSelectedState = !dialogOptions
            .where((element) => element.displayLabel == displayLabel)
            .first
            .selected;
        dialogOptions
            .where((element) => element.displayLabel == displayLabel)
            .first
            .selected = newSelectedState;

        // Update selectedItems list
        if (!newSelectedState) {
          selectedItems
              .removeWhere((element) => element.displayLabel == displayLabel);
        } else {
          if (!selectedItems
              .any((element) => element.displayLabel == displayLabel)) {
            selectedItems.add(widget.options
                .where((element) => element.displayLabel == displayLabel)
                .first);
          }
        }

        // Call setState to ensure the parent widget updates
        setState(() {});
        widget.onSaved(selectedItems.isEmpty ? null : selectedItems);
      } else {
        // For single select, check if we're clicking the already selected item
        if (widget.options
            .where((element) => element.displayLabel == displayLabel)
            .first
            .selected) {
          // Unselect the item
          widget.options
              .where((element) => element.displayLabel == displayLabel)
              .first
              .selected = false;
          final dialogIndex = dialogOptions
              .indexWhere((element) => element.displayLabel == displayLabel);
          if (dialogIndex != -1) {
            dialogOptions[dialogIndex].selected = false;
          }
          selectedItems = [];
          setState(() {});
          widget.onSaved(null);
        } else {
          // Select new item
          for (var element in widget.options) {
            element.selected = false;
          }
          for (var element in dialogOptions) {
            element.selected = false;
          }

          widget.options
              .where((element) => element.displayLabel == displayLabel)
              .first
              .selected = true;
          final dialogIndex = dialogOptions
              .indexWhere((element) => element.displayLabel == displayLabel);
          if (dialogIndex != -1) {
            dialogOptions[dialogIndex].selected = true;
          }

          selectedItems = [
            widget.options
                .where((element) => element.displayLabel == displayLabel)
                .first
          ];
          setState(() {});
          widget.onSaved(selectedItems);
        }
      }
    });
  }
}

class SelectedOptionsDataItem extends StatelessWidget {
  const SelectedOptionsDataItem({
    Key? key,
    required this.selectedItem,
  }) : super(key: key);

  final OptionsDataItem selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid, color: Colors.grey, width: 2),
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedItem.displayLabel.capitalizeLabelCase()),
            ],
          ),
        ),
      ),
    );
  }
}
