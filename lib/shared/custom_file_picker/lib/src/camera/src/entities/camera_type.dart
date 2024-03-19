///
class CameraType {
  const CameraType._internal(this.value, this.index);

  ///
  final String value;

  ///
  final int index;

  ///When activating this, don't forget to switch the index
  static const CameraType text = CameraType._internal('Text', 0);

  ///
  static const CameraType photo = CameraType._internal('Photo', 0);

  ///
  static const CameraType video = CameraType._internal('Video', 1);

  ///
  // static const _InputType boomerang = _InputType._internal('Boomerang', 3);

  ///
  static const CameraType selfi = CameraType._internal('Selfi', 4);

  ///
  // static List<CameraType> get values => [text, normal, video, selfi];

  static List<CameraType> get values => [photo, video];

}
