import 'package:finia_app/constants.dart';
import 'package:flutter/material.dart';

class IconOrSpinnerButton extends StatelessWidget {
  final bool showIcon;
  final bool loading;
  final bool isMenu;
  final VoidCallback onPressed;

  const IconOrSpinnerButton({
    super.key,
    required this.showIcon,
    required this.loading,
    this.isMenu = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showIcon ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 900),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [logoCOLOR1, logoCOLOR2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: !loading
            ? IconButton(
                icon: isMenu
                    ? const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      )
                    : const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                onPressed: onPressed,
              )
            : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
      ),
    );
  }
}
