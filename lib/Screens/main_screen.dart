import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class MyZoomableImage extends StatefulWidget {
  @override
  _MyZoomableImageState createState() => _MyZoomableImageState();
}

class _MyZoomableImageState extends State<MyZoomableImage> {
  late PhotoViewController _controller;
  double _currentScale = 1.0;
  bool vBool = true;
  bool v1Bool = false;
  bool v2Bool = false;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController()
      ..outputStateStream.listen((PhotoViewControllerValue value) {
        // Update the current scale when the scale changes
        setState(() {
          _currentScale = value.scale!;
        });

        // Update image based on the scale
        if (_currentScale < 5 && !vBool) {
          setState(() {
            vBool = true;
            v1Bool = false;
            v2Bool = false;
          });
        } else if (_currentScale >= 5 && _currentScale <= 10 && !v1Bool) {
          setState(() {
            vBool = false;
            v1Bool = true;
            v2Bool = false;
            // Set minScale to currentScale when transitioning to a new image
            _controller.scale = _currentScale;
          });
        } else if (_currentScale > 10 && !v2Bool) {
          setState(() {
            vBool = false;
            v1Bool = false;
            v2Bool = true;
            // Set minScale to currentScale when transitioning to a new image
            _controller.scale = _currentScale;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scale: $_currentScale'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PhotoView(
                imageProvider: vBool
                    ? AssetImage('assets/images/zoom_0.jpg')
                    : v1Bool
                    ? AssetImage('assets/images/zoom_1.jpg')
                    : AssetImage('assets/images/zoom_2.jpg'),
                controller: _controller,
                minScale: v1Bool || v2Bool
                    ? 1
                    : .1, // Set minScale to currentScale when transitioning to a new image
                maxScale: 5.0,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
