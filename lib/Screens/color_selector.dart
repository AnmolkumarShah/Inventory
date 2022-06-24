// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:palette_generator/palette_generator.dart';

const Color _kBackgroundColor = Color(0xffa0a0a0);
const Color _kSelectionRectangleBackground = Color(0x15000000);
const Color _kSelectionRectangleBorder = Color(0x80000000);
const Color _kPlaceholderColor = Color(0x80404040);

/// The main Application class.
class ColorSelector extends StatefulWidget {
  /// Creates the main Application class.
  ColorSelector({Key? key}) : super(key: key);

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;

  void resetImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedImage == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _selectedImage = photo;
                  });
                },
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
              ),
            )
          : ImageColors(
              title: 'Image Colors',
              // image: AssetImage('assets/back.jpg'),
              image: FileImage(File(_selectedImage!.path)),
              imageSize: Size(300.0, 290.0),
              resetImage: resetImage,
            ),
    );
  }
}

/// The home page for this example app.
@immutable
class ImageColors extends StatefulWidget {
  /// Creates the home page.
  ImageColors({
    Key? key,
    this.title,
    required this.image,
    this.imageSize,
    required this.resetImage,
  }) : super(key: key);

  /// The title that is shown at the top of the page.
  final String? title;

  /// This is the image provider that is used to load the colors from.
  final ImageProvider image;

  /// The dimensions of the image.
  final Size? imageSize;

  Function resetImage;

  @override
  _ImageColorsState createState() {
    return _ImageColorsState();
  }
}

class _ImageColorsState extends State<ImageColors> {
  Rect? region;
  Rect? dragRegion;
  Offset? startDrag;
  Offset? currentDrag;
  PaletteGenerator? paletteGenerator;

  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.imageSize != null) {
      region = Offset.zero & widget.imageSize!;
    }
    _updatePaletteGenerator(region);
  }

  Future<void> _updatePaletteGenerator(Rect? newRegion) async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      widget.image,
      size: widget.imageSize,
      region: newRegion,
      maximumColorCount: 50,
    );
    setState(() {});
  }

  // Called when the user starts to drag
  void _onPanDown(DragDownDetails details) {
    final RenderBox box =
        imageKey.currentContext!.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      startDrag = localPosition;
      currentDrag = localPosition;
      dragRegion = Rect.fromPoints(localPosition, localPosition);
    });
  }

  // Called as the user drags: just updates the region, not the colors.
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentDrag = currentDrag! + details.delta;
      dragRegion = Rect.fromPoints(startDrag!, currentDrag!);
    });
  }

  // Called if the drag is canceled (e.g. by rotating the device or switching
  // apps)
  void _onPanCancel() {
    setState(() {
      dragRegion = null;
      startDrag = null;
    });
  }

  // Called when the drag ends. Sets the region, and updates the colors.
  Future<void> _onPanEnd(DragEndDetails details) async {
    final Size? imageSize = imageKey.currentContext?.size;
    Rect? newRegion;

    if (imageSize != null) {
      newRegion = (Offset.zero & imageSize).intersect(dragRegion!);
      if (newRegion.size.width < 4 && newRegion.size.width < 4) {
        newRegion = Offset.zero & imageSize;
      }
    }

    await _updatePaletteGenerator(newRegion);
    setState(() {
      region = newRegion;
      dragRegion = null;
      startDrag = null;
    });
  }

  Color? _selectedColor;

  setColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                // GestureDetector is used to handle the selection rectangle.
                child: GestureDetector(
                  onPanDown: _onPanDown,
                  onPanUpdate: _onPanUpdate,
                  onPanCancel: _onPanCancel,
                  onPanEnd: _onPanEnd,
                  child: Stack(children: <Widget>[
                    Image(
                      key: imageKey,
                      image: widget.image,
                      fit: BoxFit.cover,
                    ),
                    // This is the selection rectangle.
                    Positioned.fromRect(
                        rect: dragRegion ?? region ?? Rect.zero,
                        child: Container(
                          decoration: BoxDecoration(
                              color: _kSelectionRectangleBackground,
                              border: Border.all(
                                width: 1.0,
                                color: _kSelectionRectangleBorder,
                                style: BorderStyle.solid,
                              )),
                        )),
                  ]),
                ),
              ),
              ElevatedButton(
                  onPressed: () => widget.resetImage(),
                  child: const Text("Reset Image")),
              PaletteSwatches(generator: paletteGenerator, setColor: setColor),
              if (_selectedColor != null)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _selectedColor == null ? Colors.grey : _selectedColor),
                    minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                  ),
                  onPressed: () {
                    int r =
                        _selectedColor!.red == null ? 0 : _selectedColor!.red;
                    int g = _selectedColor!.green == null
                        ? 0
                        : _selectedColor!.green;
                    int b =
                        _selectedColor!.blue == null ? 0 : _selectedColor!.blue;
                    Navigator.pop(context, [r, g, b]);
                  },
                  child: const Text("Selected Color"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that draws the swatches for the [PaletteGenerator] it is given,
/// and shows the selected target colors.
class PaletteSwatches extends StatelessWidget {
  PaletteSwatches({Key? key, this.generator, required this.setColor})
      : super(key: key);
  final PaletteGenerator? generator;

  Function setColor;

  @override
  Widget build(BuildContext context) {
    final List<Widget> swatches = <Widget>[];
    final PaletteGenerator? paletteGen = generator;
    if (paletteGen == null || paletteGen.colors.isEmpty) {
      return Container();
    }
    for (final Color color in paletteGen.colors) {
      swatches.add(PaletteSwatch(color: color, setColor: setColor));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Select A Shade From Patterns Below",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Wrap(
              children: swatches,
            ),
          ],
        ),
      ],
    );
  }
}

/// A small square of color with an optional label.
@immutable
class PaletteSwatch extends StatelessWidget {
  PaletteSwatch({
    Key? key,
    this.color,
    this.label,
    required this.setColor,
  }) : super(key: key);

  /// The color of the swatch.
  final Color? color;

  /// The optional label to display next to the swatch.
  final String? label;

  Function setColor;

  @override
  Widget build(BuildContext context) {
    final HSLColor hslColor = HSLColor.fromColor(color ?? Colors.transparent);
    final HSLColor backgroundAsHsl = HSLColor.fromColor(_kBackgroundColor);
    final double colorDistance = math.sqrt(
        math.pow(hslColor.saturation - backgroundAsHsl.saturation, 2.0) +
            math.pow(hslColor.lightness - backgroundAsHsl.lightness, 2.0));

    Widget swatch = Padding(
      padding: const EdgeInsets.all(2.0),
      child: color == null
          ? const Placeholder(
              fallbackWidth: 34.0,
              fallbackHeight: 20.0,
              color: Color(0xff404040),
              strokeWidth: 2.0,
            )
          : GestureDetector(
              onTap: () {
                setColor(color);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      width: 1.0,
                      color: _kPlaceholderColor,
                      style: colorDistance < 0.2
                          ? BorderStyle.solid
                          : BorderStyle.none,
                    )),
                width: 34.0,
                height: 20.0,
              ),
            ),
    );

    if (label != null) {
      swatch = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130.0, minWidth: 130.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            swatch,
            Container(width: 5.0),
            Text(label!),
          ],
        ),
      );
    }
    return swatch;
  }
}
