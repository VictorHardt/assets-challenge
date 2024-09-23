import 'package:assets_challenge/design_system/tractian_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum TractianButtonType { elevated, outlined }

class TractianButton extends StatelessWidget {
  final TractianButtonType buttonType;
  final VoidCallback? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final String? prefixIconPath;
  final String? sufixIconPath;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? width;
  const TractianButton({
    super.key,
    this.buttonType = TractianButtonType.elevated,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.prefixIconPath,
    this.isLoading = false,
    this.sufixIconPath,
    this.padding,
    this.width,
  });

  Widget _getButtonType(BuildContext context) => switch (buttonType) {
        TractianButtonType.elevated => ElevatedButton(
            onPressed: onPressed,
            style: _elevatedButtonStyle(),
            child: _button(context),
          ),
        TractianButtonType.outlined => OutlinedButton(
            onPressed: onPressed,
            style: _outlinedButtonStyle(),
            child: _button(context),
          ),
      };

  WidgetStateProperty<Color> get _elevatedBackgroundColor => onPressed != null
      ? WidgetStateProperty.all<Color>(
          backgroundColor ?? TractianColors.buttonBlue,
        )
      : WidgetStateProperty.all<Color>(
          TractianColors.gray1,
        );

  WidgetStateProperty<Color> get _outlinedBackgroundColor => onPressed != null
      ? WidgetStateProperty.all<Color>(
          backgroundColor ?? TractianColors.white,
        )
      : WidgetStateProperty.all<Color>(
          TractianColors.gray1,
        );

  Color get _textColor => onPressed != null
      ? textColor ?? TractianColors.white
      : TractianColors.gray3;

  Color get _iconColor => onPressed != null
      ? textColor ?? TractianColors.white
      : TractianColors.gray3;

  ButtonStyle _elevatedButtonStyle() => ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: _elevatedBackgroundColor,
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
      );

  ButtonStyle _outlinedButtonStyle() => ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: _outlinedBackgroundColor,
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
        side: WidgetStateProperty.all<BorderSide?>(
          BorderSide(color: _textColor),
        ),
      );

  Widget _button(BuildContext context) => isLoading
      ? const CircularProgressIndicator()
      : Padding(
          padding: (prefixIconPath == null && sufixIconPath == null)
              ? padding ?? const EdgeInsets.symmetric(vertical: 3)
              : padding ?? EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixIconPath == null
                  ? const SizedBox()
                  : _buttonIcon(
                      iconPath: prefixIconPath!,
                      isPrefixIcon: true,
                      context: context,
                    ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: _textColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              sufixIconPath == null
                  ? const SizedBox()
                  : _buttonIcon(
                      iconPath: sufixIconPath!,
                      isPrefixIcon: false,
                      context: context,
                    ),
            ],
          ),
        );

  Widget _buttonIcon(
      {required String iconPath,
      required bool isPrefixIcon,
      required BuildContext context}) {
    return Row(
      children: [
        isPrefixIcon ? const SizedBox() : const SizedBox(width: 8),
        SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(_iconColor, BlendMode.srcIn),
          height: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.30,
          width: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.30,
        ),
        isPrefixIcon ? const SizedBox(width: 8) : const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: _getButtonType(context),
    );
  }
}
