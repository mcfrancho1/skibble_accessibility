///With the help of the read_more package from pub.dev,
///I was able to recreate this with animation
///
/// Thanks read_more package :)

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

enum CustomTrimMode {
  Length,
  Line,
}

class CustomReadMoreText extends StatefulWidget {
  const CustomReadMoreText(
      this.data, {
        Key? key,
        this.preData,
        this.preDataStyle,
        this.trimExpandedText = 'show less',
        this.trimCollapsedText = 'read more',
        this.colorClickableText,
        this.trimLength = 240,
        this.trimLines = 2,
        this.trimMode = CustomTrimMode.Length,
        this.style,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.textScaleFactor,
        this.semanticsLabel,
        this.moreStyle,
        this.lessStyle,
        this.delimiter = _kEllipsis + ' ',
        this.delimiterStyle,
        this.callback,
      }) : super(key: key);

  /// Used on TrimMode.Length
  final int trimLength;

  /// Used on TrimMode.Lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.Length takes into account
  /// the number of letters, while TrimMode.Lines takes into account
  /// the number of lines
  final CustomTrimMode trimMode;

  /// TextStyle for expanded text
  final TextStyle? moreStyle;

  /// TextStyle for compressed text
  final TextStyle? lessStyle;

  ///Called when state change between expanded/compress
  final Function(bool val)? callback;

  final String delimiter;
  final String data;
  final String? preData;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? colorClickableText;
  final TextStyle? style;
  final TextStyle? preDataStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final String? semanticsLabel;
  final TextStyle? delimiterStyle;

  @override
  CustomReadMoreTextState createState() => CustomReadMoreTextState();
}

const String _kEllipsis = '\u2026';

const String _kLineSeparator = '\u2028';

class CustomReadMoreTextState extends State<CustomReadMoreText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() {
      _readMore = !_readMore;
      widget.callback?.call(_readMore);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style?.inherit ?? false) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);

    final colorClickableText =
        widget.colorClickableText ?? Theme.of(context).colorScheme.secondary;
    final _defaultLessStyle = widget.lessStyle ??
        effectiveTextStyle?.copyWith(color: colorClickableText);
    final _defaultMoreStyle = widget.moreStyle ??
        effectiveTextStyle?.copyWith(color: colorClickableText);
    final _defaultDelimiterStyle = widget.delimiterStyle ?? effectiveTextStyle;

    TextSpan link = TextSpan(
      text: _readMore ? widget.trimCollapsedText : widget.trimExpandedText,
      style: _readMore ? _defaultMoreStyle : _defaultLessStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    TextSpan _delimiter = TextSpan(
      text: _readMore
          ? widget.trimCollapsedText.isNotEmpty
          ? widget.delimiter
          : ''
          : widget.trimExpandedText.isNotEmpty
          ? widget.delimiter
          : '',
      style: _defaultDelimiterStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with data
        final text = widget.preData == null ? TextSpan(
          style: effectiveTextStyle,
          text: widget.data,
        )
        :
       TextSpan(
            children: [
              TextSpan(
                text: widget.preData,
                style: widget.preDataStyle != null ? widget.preDataStyle : TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              )
            ]
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
          locale: locale,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = _delimiter;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of data
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        var textSpan;
        var preDataTextSpan =
          TextSpan(
          text: widget.preData,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
          ),
        );

        switch (widget.trimMode) {
          case CustomTrimMode.Length:
            if (widget.trimLength < widget.data.length) {
              textSpan = widget.preData == null ? TextSpan(
                style: effectiveTextStyle,
                text: _readMore
                    ? widget.data.substring(0, widget.trimLength)
                    : widget.data,
                children: <TextSpan>[_delimiter, link],
              ) : TextSpan(
                  children: [
                    preDataTextSpan,
                    TextSpan(
                      style: effectiveTextStyle,
                      text: widget.data,
                    )
                  ]
              );
            } else {
              textSpan = widget.preData == null ? TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              )
                  :
              TextSpan(
                  children: [
                    preDataTextSpan,
                    TextSpan(
                      style: effectiveTextStyle,
                      text: widget.data,
                    )
                  ]
              );
            }
            break;
          case CustomTrimMode.Line:
            if (textPainter.didExceedMaxLines) {
              textSpan = widget. preData == null ? TextSpan(
                style: effectiveTextStyle,
                text: _readMore
                    ? widget.data.substring(0, endIndex) +
                    (linkLongerThanLine ? _kLineSeparator : '')
                    : widget.data,
                children: <TextSpan>[_delimiter, link],
              )
                  :
              TextSpan(
                  children: [
                    preDataTextSpan,
                    TextSpan(
                      style: effectiveTextStyle,
                      text: _readMore
                          ? widget.data.substring(0, endIndex) +
                          (linkLongerThanLine ? _kLineSeparator : '')
                          : widget.data,
                      children: <TextSpan>[_delimiter, link],
                    )
                  ]
              );
            } else {
              textSpan = widget.preData == null ? TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              )
                  :
              TextSpan(
                  children: [
                    preDataTextSpan,
                    TextSpan(
                      style: effectiveTextStyle,
                      text: widget.data,
                    )
                  ]
              ) ;
            }
            break;
          default:
            throw Exception(
                'TrimMode type: ${widget.trimMode} is not supported');
        }

        ///This is the only thing that changed(animation)
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: RichText(
            textAlign: textAlign,
            textDirection: textDirection,
            softWrap: true,
            //softWrap,
            overflow: TextOverflow.clip,
            //overflow,
            textScaleFactor: textScaleFactor,
            text: textSpan,
          ),
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }
}
