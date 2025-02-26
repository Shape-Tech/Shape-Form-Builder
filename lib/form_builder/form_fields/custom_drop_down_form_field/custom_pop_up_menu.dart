import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu_item.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomPopUpMenu extends StatefulWidget {
  CustomPopUpMenu({
    super.key,
    required this.menuItems,
    this.maxWidth,
    this.onOptionSelected,
    this.initialSelection,
    this.hintText,
    this.styling,
  });

  List<CustomPopUpMenuItem> menuItems;
  String? hintText;
  CustomPopUpMenuItem? initialSelection;
  double? maxWidth;
  String? Function(CustomPopUpMenuItem)? onOptionSelected;
  ShapeFormStyling? styling;

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
          borderRadius: BorderRadius.circular(10),
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
              color: widget.styling?.background ?? Colors.white,
              border: Border.all(
                  color: widget.styling?.secondary ?? Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(
                  widget.styling?.borderRadiusMedium ?? 10),
            ),
            child: dropDownCurrentSelection()
                .verticalPadding(widget.styling?.spacingSmall ?? spacing)
                .horizontalPadding(widget.styling?.spacingMedium ?? padding),
          ),
        );
      },
      menuChildren: List<Container>.generate(
        widget.menuItems.length,
        (int index) => Container(
          decoration: BoxDecoration(
            color: widget.styling?.background ?? Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: widget.styling?.border ?? Colors.grey, width: 1)),
            borderRadius: BorderRadius.only(
              topLeft: index == 0 ? Radius.circular(7) : Radius.zero,
              topRight: index == 0 ? Radius.circular(7) : Radius.zero,
              bottomLeft: index == widget.menuItems.length - 1
                  ? Radius.circular(7)
                  : Radius.zero,
              bottomRight: index == widget.menuItems.length - 1
                  ? Radius.circular(7)
                  : Radius.zero,
            ),
          ),
          width: widget.maxWidth,
          child: widget.menuItems[index].customDisplay != null
              ? InkWell(
                  borderRadius: BorderRadius.circular(7),
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
        widget.hintText ?? 'Select Option',
      );
    }
  }
}
