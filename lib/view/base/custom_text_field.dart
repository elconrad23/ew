import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enviroewatch/provider/theme_provider.dart';
import 'package:enviroewatch/utill/color_resources.dart';
import 'package:enviroewatch/utill/dimensions.dart';
import 'package:enviroewatch/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function onTap;
  final Function onSuffixTap;
  final IconData suffixIconUrl;
  final IconData prefixIconUrl;
  final bool isSearch;
  final Function onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final bool isElevation;
  final bool isPadding;
  final Function onChanged;
  //final LanguageProvider languageProvider;

  CustomTextField(
      {this.hintText = 'Write something...',
      required this.controller,
      required this.focusNode,
      required this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      required this.onSuffixTap,
      required this.fillColor,
      required this.onSubmit,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      required this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      required this.suffixIconUrl,
      required this.prefixIconUrl,
      this.isSearch = false,
      this.isElevation = true,
      required this.onChanged,
      this.isPadding = true});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: widget.isElevation
                ? (Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade200)
                : Colors.transparent,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: Dimensions.FONT_SIZE_LARGE),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: false,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
              ]
            : null,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(
          //     vertical: 10, horizontal: widget.isPadding ? 22 : 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: BorderSide.none,
          ),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor != Colors.white
              ? widget.fillColor
              : ColorResources.getGreyColor(context),
          hintStyle: poppinsLight.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: ColorResources.getGreyLightColor(context)),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon
              ? IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    widget.prefixIconUrl,
                    color: ColorResources.getTextColor(context),
                  ),
                  onPressed: () {},
                )
              : SizedBox.shrink(),
          prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon
              ? widget.isPassword
                  ? IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).hintColor.withOpacity(0.3)),
                      onPressed: _toggle)
                  : widget.isIcon
                      ? IconButton(
                          onPressed: widget.onSuffixTap as VoidCallback,
                          icon: Icon(widget.suffixIconUrl,
                              color: ColorResources.getHintColor(context)),
                        )
                      : null
              : null,
        ),
        onTap: widget.onTap as GestureTapCallback?,
        onChanged: widget.onChanged as void Function(String)?,
        onSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null
                ? widget.onSubmit(text)
                : null,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
