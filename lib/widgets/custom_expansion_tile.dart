import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool isInitiallyExpanded;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.isInitiallyExpanded = true,
  });

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _iconTurns;

  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_animation);

    _isExpanded = widget.isInitiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: _handleTap,
          title: Text(widget.title),
          trailing: RotationTransition(
            turns: _iconTurns,
            child: const Icon(Icons.expand_more),
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _animation,
          child: Column(children: widget.children),
        ),
      ],
    );
  }
}
