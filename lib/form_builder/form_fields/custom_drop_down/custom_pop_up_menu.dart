import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down/custom_pop_up_menu_item.dart';

class CustomPopUpMenu extends StatefulWidget {
  CustomPopUpMenu({
    super.key,
    required this.menuItems,
    this.maxWidth,
    this.onOptionSelected,
    this.initialSelection,
  });

  List<CustomPopUpMenuItem> menuItems;
  CustomPopUpMenuItem? initialSelection;
  double? maxWidth;
  String? Function(CustomPopUpMenuItem)? onOptionSelected;

  @override
  State<CustomPopUpMenu> createState() => _CustomPopUpMenuState();
}

class _CustomPopUpMenuState extends State<CustomPopUpMenu> {
  CustomPopUpMenuItem? selectedOption;

  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      builder: (BuildContext context, _menuController, Widget? child) {
        return InkWell(
          onTap: () {
            if (_menuController.isOpen) {
              _menuController.close();
            } else {
              _menuController.open();
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: dropDownCurrentSelection()
                .verticalPadding(10)
                .horizontalPadding(20),
          ),
        );
      },
      menuChildren: List<Container>.generate(
        widget.menuItems.length,
        (int index) => Container(
          width: widget.maxWidth,
          child: widget.menuItems[index].customDisplay != null
              ? InkWell(
                  child: widget.menuItems[index].customDisplay,
                  onTap: () {
                    if (widget.onOptionSelected != null) {
                      widget.onOptionSelected!(widget.menuItems[index]);
                    }
                    setState(() => selectedOption = widget.menuItems[index]);
                    if (_menuController.isOpen) {
                      _menuController.close();
                    } else {
                      _menuController.open();
                    }
                  },
                )
              : ListTile(
                  onTap: () {
                    if (widget.onOptionSelected != null) {
                      widget.onOptionSelected!(widget.menuItems[index]);
                    }
                    setState(() => selectedOption = widget.menuItems[index]);
                    if (_menuController.isOpen) {
                      _menuController.close();
                    } else {
                      _menuController.open();
                    }
                  },
                  title: Text(
                      "${widget.menuItems[index].label ?? widget.menuItems[index].value.toString()}")),
        ),
      ),
    );
  }

  Widget dropDownCurrentSelection() {
    if (selectedOption != null) {
      return selectedOption!.customDisplay ??
          Text(selectedOption!.label ?? selectedOption!.value!.toString());
    } else if (widget.initialSelection != null) {
      return widget.initialSelection!.customDisplay ??
          Text(widget.initialSelection!.label ??
              widget.initialSelection!.value!.toString());
    } else {
      return Text(
        'Select Option',
      );
    }
  }
}
