import 'package:flutter/material.dart';

class CommonInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool password;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  const CommonInput({super.key, required this.controller,  this.hintText = "",  this.password = false, this.textInputType = TextInputType.text, this.textInputAction = TextInputAction.next});

  @override
  State<CommonInput> createState() => _CommonInputState();
}

class _CommonInputState extends State<CommonInput> {
  bool _showPass = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
                controller: widget.controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: widget.textInputType ,
                textInputAction: widget.textInputAction,
                // validator: (val) => widget.onValidate(val),
                decoration: InputDecoration(
                  suffixIcon: widget.password
                      ? IconButton(
                          onPressed: () {
                              setState(() {
                                _showPass = !_showPass;
                              });
                          },
                          icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText,
                  // hintStyle: AppTextStyle.lightGreyText,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                ),

                obscureText: widget.password ? !_showPass : false,
              );
  }
}