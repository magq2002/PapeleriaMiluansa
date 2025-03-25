import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';

class CropScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final void Function(Uint8List) onCropped;

  const CropScreen({
    Key? key,
    required this.imageBytes,
    required this.onCropped,
  }) : super(key: key);

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final CropController _controller = CropController();
  bool _isCropping = false;
  bool _isCircleUi = false;
  bool _isOverlayActive = true;
  bool _undoEnabled = false;
  bool _redoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recortar imagen')),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: widget.imageBytes,
              controller: _controller,
              onCropped: (result) {
                setState(() => _isCropping = false);
                if (result is CropSuccess) {
                  widget.onCropped(result.croppedImage);
                  Navigator.pop(context);
                } else if (result is CropFailure) {
                  _showErrorDialog(result.toString());
                }
              },
              withCircleUi: _isCircleUi,
              baseColor: Colors.black,
              maskColor: Colors.white.withAlpha(100),
              cornerDotBuilder: (size, edgeAlignment) =>
                  const DotControl(color: Colors.blue),
              onStatusChanged: (status) {
                setState(() {
                  // Actualizar el estado según sea necesario
                });
              },
              onHistoryChanged: (history) {
                setState(() {
                  _undoEnabled = history.undoCount > 0;
                  _redoEnabled = history.redoCount > 0;
                });
              },
              overlayBuilder: _isOverlayActive
                  ? (context, rect) {
                      final overlay = CustomPaint(
                        painter: GridPainter(),
                      );
                      return _isCircleUi
                          ? ClipOval(
                              child: overlay,
                            )
                          : overlay;
                    }
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.crop_7_5),
                      onPressed: () {
                        setState(() {
                          _isCircleUi = false;
                          _controller.aspectRatio = 16 / 4;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.crop_16_9),
                      onPressed: () {
                        setState(() {
                          _isCircleUi = false;
                          _controller.aspectRatio = 16 / 9;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.crop_5_4),
                      onPressed: () {
                        setState(() {
                          _isCircleUi = false;
                          _controller.aspectRatio = 4 / 3;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.crop_square),
                      onPressed: () {
                        setState(() {
                          _isCircleUi = false;
                          _controller
                            ..withCircleUi = false
                            ..aspectRatio = 1;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        setState(() {
                          _isCircleUi = true;
                          _controller.withCircleUi = true;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Mostrar cuadrícula'),
                    Switch(
                      value: _isOverlayActive,
                      onChanged: (value) {
                        setState(() {
                          _isOverlayActive = value;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _undoEnabled ? () => _controller.undo() : null,
                      child: const Text('Deshacer'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _redoEnabled ? () => _controller.redo() : null,
                      child: const Text('Rehacer'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCropping
                        ? null
                        : () {
                            setState(() => _isCropping = true);
                            _isCircleUi
                                ? _controller.cropCircle()
                                : _controller.crop();
                          },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('Recortar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error al recortar'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int divisions = 2;
  final double strokeWidth = 1.0;
  final Color color = Colors.black54;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color;

    final spacing = size / (divisions + 1);
    for (var i = 1; i < divisions + 1; i++) {
      // Dibujar línea vertical
      canvas.drawLine(
        Offset(spacing.width * i, 0),
        Offset(spacing.width * i, size.height),
        paint,
      );

      // Dibujar línea horizontal
      canvas.drawLine(
        Offset(0, spacing.height * i),
        Offset(size.width, spacing.height * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
