import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/string_extensions.dart';

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
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
  OptionListPicker({
    Key? key,
    required this.buttonText,
    required this.multiSelectEnabled,
    required this.options,
    required this.onSaved,
    this.addOption,
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
        child: Text(widget.buttonText),
        onPressed: () {
          _showOptionPicker(context, widget.multiSelectEnabled);
        },
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            elevation: 10,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: 200.00, maxWidth: 600.00, maxHeight: 700),
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Theme.of(context).primaryColor,
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
                    Container(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            )),
                        onChanged: searchOptions,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
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
                                  onChanged: (value) {
                                    setState(() {
                                      selectItem(
                                          widget.options.indexWhere((element) =>
                                              element.displayLabel ==
                                                  dialogOptions[index]
                                                      .displayLabel &&
                                              element.displayDescription ==
                                                  dialogOptions[index]
                                                      .displayDescription),
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
                                      widget.options.indexWhere((element) =>
                                          element.displayLabel ==
                                              dialogOptions[index]
                                                  .displayLabel &&
                                          element.displayDescription ==
                                              dialogOptions[index]
                                                  .displayDescription),
                                      dialogContext,
                                      setDialogState);
                                });
                                if (widget.multiSelectEnabled == false) {
                                  Navigator.pop(dialogContext);
                                }
                              },
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
                      })
                ],
              ),
            ),
          );
        });
      },
    );
  }

  selectItem(int index, BuildContext dialogContext, Function refreshState) {
    refreshState(() {
      if (widget.multiSelectEnabled == true) {
        // Toggle the selection state
        bool newSelectedState = !widget.options[index].selected;
        widget.options[index].selected = newSelectedState;

        // Find and update the corresponding dialogOption
        final dialogIndex = dialogOptions.indexWhere((element) =>
            element.displayLabel == widget.options[index].displayLabel &&
            element.displayDescription ==
                widget.options[index].displayDescription);
        if (dialogIndex != -1) {
          dialogOptions[dialogIndex].selected = newSelectedState;
        }

        // Update selectedItems list
        if (!newSelectedState) {
          selectedItems.removeWhere((element) =>
              element.displayLabel == widget.options[index].displayLabel &&
              element.displayDescription ==
                  widget.options[index].displayDescription);
        } else {
          if (!selectedItems.any((element) =>
              element.displayLabel == widget.options[index].displayLabel &&
              element.displayDescription ==
                  widget.options[index].displayDescription)) {
            selectedItems.add(widget.options[index]);
          }
        }

        // Call setState to ensure the parent widget updates
        setState(() {});
        widget.onSaved(selectedItems.isEmpty ? null : selectedItems);
      } else {
        // For single select, check if we're clicking the already selected item
        if (widget.options[index].selected) {
          // Unselect the item
          widget.options[index].selected = false;
          final dialogIndex = dialogOptions.indexWhere((element) =>
              element.displayLabel == widget.options[index].displayLabel &&
              element.displayDescription ==
                  widget.options[index].displayDescription);
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

          widget.options[index].selected = true;
          final dialogIndex = dialogOptions.indexWhere((element) =>
              element.displayLabel == widget.options[index].displayLabel &&
              element.displayDescription ==
                  widget.options[index].displayDescription);
          if (dialogIndex != -1) {
            dialogOptions[dialogIndex].selected = true;
          }

          selectedItems = [widget.options[index]];
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
