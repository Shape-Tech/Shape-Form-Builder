import 'package:flutter/material.dart';

class ShapeFormStyling {
  // Text Sizes
  final double heading1;
  final double heading2;
  final double heading3;
  final double heading4;
  final double body;
  final double caption;
  final double small;

  // Spacing
  final double spacingSmall;
  final double spacingMedium;
  final double spacingLarge;
  final double spacingExtraLarge;

  // Border Radius
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;
  final double borderRadiusExtraLarge;

  // Colors
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color background;
  final Color surface;
  final Color error;
  final Color success;
  final Color warning;
  final Color neutral;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color border;

  // Text Styles
  final TextStyle heading1Style;
  final TextStyle heading1SmallStyle;
  final TextStyle heading2Style;
  final TextStyle heading3Style;
  final TextStyle heading4Style;
  final TextStyle bodyTextStyle;
  final TextStyle bodyTextBoldStyle;
  final TextStyle captionStyle;

  // Button Styles
  final ButtonStyle primaryButtonStyle;
  final ButtonStyle secondaryButtonStyle;
  final ButtonStyle outlinedButtonStyle;
  final ButtonStyle textButtonStyle;

  // Container Decorations
  final BoxDecoration containerDecoration;

  ShapeFormStyling({
    // Text Sizes
    this.heading1 = FormTextSizes.heading1,
    this.heading2 = FormTextSizes.heading2,
    this.heading3 = FormTextSizes.heading3,
    this.heading4 = FormTextSizes.heading4,
    this.body = FormTextSizes.body,
    this.caption = FormTextSizes.caption,
    this.small = FormTextSizes.small,

    // Spacing
    this.spacingSmall = FormSpacing.small,
    this.spacingMedium = FormSpacing.medium,
    this.spacingLarge = FormSpacing.large,
    this.spacingExtraLarge = FormSpacing.extraLarge,

    // Border Radius
    this.borderRadiusSmall = FormBorderRadius.small,
    this.borderRadiusMedium = FormBorderRadius.medium,
    this.borderRadiusLarge = FormBorderRadius.large,
    this.borderRadiusExtraLarge = FormBorderRadius.extraLarge,

    // Colors
    this.primary = FormColors.primary,
    this.primaryLight = FormColors.primaryLight,
    this.primaryDark = FormColors.primaryDark,
    this.secondary = FormColors.secondary,
    this.secondaryLight = FormColors.secondaryLight,
    this.secondaryDark = FormColors.secondaryDark,
    this.background = FormColors.background,
    this.surface = FormColors.surface,
    this.error = FormColors.error,
    this.success = FormColors.success,
    this.warning = FormColors.warning,
    this.neutral = FormColors.neutral,
    this.textPrimary = FormColors.textPrimary,
    this.textSecondary = FormColors.textSecondary,
    this.textDisabled = FormColors.textDisabled,
    this.border = FormColors.border,

    // Text Styles
    TextStyle? heading1Style,
    TextStyle? heading1SmallStyle,
    TextStyle? heading2Style,
    TextStyle? heading3Style,
    TextStyle? heading4Style,
    TextStyle? bodyTextStyle,
    TextStyle? bodyTextBoldStyle,
    TextStyle? captionStyle,

    // Button Styles
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? secondaryButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,

    // Container Decorations
    BoxDecoration? containerDecoration,
  })  : this.heading1Style = heading1Style ?? FormTextStyles.heading1,
        this.heading1SmallStyle =
            heading1SmallStyle ?? FormTextStyles.heading1small,
        this.heading2Style = heading2Style ?? FormTextStyles.heading2,
        this.heading3Style = heading3Style ?? FormTextStyles.heading3,
        this.heading4Style = heading4Style ?? FormTextStyles.heading4,
        this.bodyTextStyle = bodyTextStyle ?? FormTextStyles.bodyText,
        this.bodyTextBoldStyle =
            bodyTextBoldStyle ?? FormTextStyles.bodyTextBold,
        this.captionStyle = captionStyle ?? FormTextStyles.caption,
        this.primaryButtonStyle =
            primaryButtonStyle ?? FormButtonStyles.primaryButton,
        this.secondaryButtonStyle =
            secondaryButtonStyle ?? FormButtonStyles.secondaryButton,
        this.outlinedButtonStyle =
            outlinedButtonStyle ?? FormButtonStyles.outlinedButton,
        this.textButtonStyle = textButtonStyle ?? FormButtonStyles.textButton,
        this.containerDecoration =
            containerDecoration ?? FormContainerDecorations.containerDecoration;
}

// Text Sizes
abstract class FormTextSizes {
  static const double heading1 = 32.0;
  static const double heading2 = 24.0;
  static const double heading3 = 20.0;
  static const double heading4 = 18.0;
  static const double body = 16.0;
  static const double caption = 14.0;
  static const double small = 12.0;
}

abstract class FormSpacing {
  static const double small = 5.0;
  static const double medium = 10.0;
  static const double large = 20.0;
  static const double extraLarge = 40.0;
}

// Border Radius
abstract class FormBorderRadius {
  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 12.0;
  static const double extraLarge = 16.0;
  static BorderRadius smallRadius = BorderRadius.circular(small);
  static BorderRadius mediumRadius = BorderRadius.circular(medium);
  static BorderRadius largeRadius = BorderRadius.circular(large);
  static BorderRadius extraLargeRadius = BorderRadius.circular(extraLarge);
}

// Colors
abstract class FormColors {
  // Primary Colors
  static const Color primary = Color.fromARGB(255, 60, 0, 255);
  static const Color primaryLight = Color.fromARGB(255, 117, 148, 239);
  static const Color primaryDark = Color.fromARGB(255, 19, 34, 79);

  // Secondary Colors
  static const Color secondary = Color.fromARGB(255, 0, 179, 255);
  static const Color secondaryLight = Color.fromARGB(255, 192, 230, 255);
  static const Color secondaryDark = Color.fromARGB(255, 0, 57, 103);

  // Neutral Colors
  static const Color background = Color.fromARGB(255, 245, 247, 251);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF5350);
  static const Color success = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFA726);
  static const Color neutral = Color(0xFF676767);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Border Colors
  static const Color border = Color(0xFFE6E6E6);
}

// Text Styles
abstract class FormTextStyles {
  static TextStyle heading1 = TextStyle(
    fontSize: FormTextSizes.heading1,
    fontWeight: FontWeight.bold,
    color: FormColors.primary,
    fontFamily: "Arial Black",
  );

  static TextStyle heading1small = TextStyle(
    fontSize: FormTextSizes.heading2,
    fontWeight: FontWeight.bold,
    color: FormColors.primary,
    fontFamily: "Arial Black",
  );

  static TextStyle heading2 = TextStyle(
    fontSize: FormTextSizes.heading2,
    fontWeight: FontWeight.bold,
    color: FormColors.textPrimary,
  );

  static TextStyle heading3 = TextStyle(
    fontSize: FormTextSizes.heading3,
    fontWeight: FontWeight.w600,
    color: FormColors.textPrimary,
  );

  static TextStyle heading4 = TextStyle(
    fontSize: FormTextSizes.heading4,
    fontWeight: FontWeight.w600,
    color: FormColors.textPrimary,
  );

  static TextStyle bodyText = TextStyle(
    fontSize: FormTextSizes.body,
    color: FormColors.textPrimary,
  );

  static TextStyle bodyTextBold = TextStyle(
    fontSize: FormTextSizes.body,
    fontWeight: FontWeight.bold,
    color: FormColors.textPrimary,
  );

  static TextStyle caption = TextStyle(
    fontSize: FormTextSizes.caption,
    color: FormColors.textSecondary,
  );
}

// Button Styles
abstract class FormButtonStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: FormColors.secondary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
        horizontal: FormSpacing.large, vertical: FormSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: FormBorderRadius.mediumRadius,
    ),
    elevation: 0,
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: FormColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
        horizontal: FormSpacing.large, vertical: FormSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: FormBorderRadius.mediumRadius,
    ),
    elevation: 0,
  );

  static ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: FormColors.primary,
    side: const BorderSide(color: FormColors.primary),
    padding: const EdgeInsets.symmetric(
        horizontal: FormSpacing.large, vertical: FormSpacing.medium),
    shape: RoundedRectangleBorder(
      borderRadius: FormBorderRadius.mediumRadius,
    ),
    elevation: 0,
  );

  static ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: FormColors.secondary,
    backgroundColor: FormColors.secondary.withOpacity(0.05),
    padding: const EdgeInsets.symmetric(
        horizontal: FormSpacing.large, vertical: FormSpacing.large),
    shape: RoundedRectangleBorder(
      borderRadius: FormBorderRadius.mediumRadius,
    ),
  );
}

// Container Decorations
abstract class FormContainerDecorations {
  static BoxDecoration containerDecoration = BoxDecoration(
    color: FormColors.surface,
    borderRadius: FormBorderRadius.mediumRadius,
    border: Border.all(
      color: FormColors.border,
      width: 1,
    ),
  );
}
