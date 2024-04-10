import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool _remeemberMe = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: _remeemberMe,
            checkColor: Theme.of(context).textTheme.bodyLarge?.color,
            activeColor: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: MaterialStateBorderSide.resolveWith((states) => BorderSide(
                  width: 2.0,
                  color: Theme.of(context).primaryColor,
                )),
            onChanged: (value) {
              setState(() {
                _remeemberMe = value!;
              });
            },
          ),
          const Text("Remember me"),
        ],
      ),
    );
  }
}
