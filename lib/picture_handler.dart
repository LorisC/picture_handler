library picture_handler;


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
typedef TackPictureCallback(String picturePath);
class AdvancedCameraPreview extends StatefulWidget {
  final TackPictureCallback pictureCallback;
  const AdvancedCameraPreview({this.pictureCallback}) : assert(pictureCallback != null);
  @override
  _AdvancedCameraPreviewState createState() => _AdvancedCameraPreviewState();
}

class _AdvancedCameraPreviewState extends State<AdvancedCameraPreview> {
  CameraController _camera;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description = await getCamera(_direction);

    _camera = CameraController(
      description,
      ResolutionPreset.max,
    );

    await _camera.initialize();

    //trigger a rebuild
    setState(() {});
  }

  Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  _buildPreviewScreen() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        double shooterRadius = constraint.maxHeight / 10;
        double screenCenter = constraint.maxWidth / 2;
        return Stack(
          children: <Widget>[
            CameraPreview(_camera),
            Positioned(
              bottom: 16,
              left: screenCenter - shooterRadius / 2,
              child: GestureDetector(
                onTap: _takePicture,
                child: Material(
                  color: Colors.white,
                  shape: CircleBorder(
                    side: BorderSide(
                        color: Colors.white, width: 2, style: BorderStyle.solid),
                  ),
                  child: Container(
                    height: shooterRadius,
                    width: shooterRadius,
                  ),
                  elevation: 16,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _takePicture() async {
    String path = (await getApplicationDocumentsDirectory()).path + '${DateTime.now().toIso8601String()}';
    await _camera.takePicture(path);
    widget.pictureCallback(path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _camera == null
          ? Container(
              child: Center(
                child: Text(
                  "Initializing",
                ),
              ),
            )
          : _buildPreviewScreen(),
    );
  }
}
