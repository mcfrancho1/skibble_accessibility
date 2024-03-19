part of media_picker;

class ListBackdrop extends StatelessWidget {
  const ListBackdrop({Key? key, required this.listener, this.onTap})
      : super(key: key);
  final ValueNotifier<bool> listener;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listener,
      builder: (_, bool val, Widget? child) {
        return IgnorePointer(
          ignoring: !val,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedOpacity(
              duration: switchingPathDuration,
              opacity: val ? 1.0 : 0.0,
              child: Container(color: Colors.white.withOpacity(0.75)),
            ),
          ),
        );
      },
    );
  }
}
