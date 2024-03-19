part of media_picker;

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
    required this.selectedData,
    required this.isMulti,
    required this.limit,
  }) : super(key: key);

  final ValueNotifier<List<AssetEntity>> selectedData;
  final bool isMulti;
  final int limit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedData,
      builder: (_, List<AssetEntity> items, __) {
        return MaterialButton(
          elevation: 0.0,
          height: 32,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          color: items.isNotEmpty ? context.primary : Colors.grey[200],
          child: Text(
            items.isNotEmpty && isMulti
                ? 'Select (${items.length}/$limit)'
                : 'Select',
            style: TextStyle(
              color: items.isNotEmpty ? Colors.white : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (items.isNotEmpty) {
              Navigator.of(context).pop(items);
            }
          },
        );
      },
    );
  }
}
