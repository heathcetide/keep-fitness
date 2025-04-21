import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingQueue {
  static final LoadingQueue _instance = LoadingQueue._internal();
  factory LoadingQueue() => _instance;

  LoadingQueue._internal();

  int _loadingCount = 0;

  // 现代简约风格的 loading
  Widget _buildModernLoading(String? message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitPouringHourGlass(
            // 使用沙漏效果
            color: Color(0xFF65DAC6), // 使用应用主题色
            size: 50.0,
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Color(0xFF2D3142),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 科技感风格的 loading
  Widget _buildTechLoading(String? message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF65DAC6).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitSpinningLines(
            // 使用旋转线条效果
            color: Color(0xFF65DAC6),
            size: 70.0,
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 毛玻璃效果的 loading
  Widget _buildGlassLoading(String? message) {
    return Container(
      constraints: BoxConstraints(maxWidth: 320, minHeight: 120),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFoldingCube(
            // 使用折叠立方体效果
            color: Color(0xFF65DAC6),
            size: 50.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void show([String? message]) {
    _loadingCount++;
    if (_loadingCount == 1) {
      SmartDialog.showLoading(
        builder: (_) => _buildGlassLoading(message), // 使用毛玻璃效果的 loading
        backDismiss: false,
        maskColor: Colors.black.withOpacity(0.4),
        animationType: SmartAnimationType.scale,
        animationTime: Duration(milliseconds: 200),
      );
    }
  }

  void dismiss() {
    if (_loadingCount > 0) {
      _loadingCount--;
      if (_loadingCount == 0) {
        SmartDialog.dismiss();
      }
    }
  }

  void dismissAll() {
    _loadingCount = 0;
    SmartDialog.dismiss();
  }
}

/**
 * builder: (_) => _buildModernLoading(message), // 现代简约风格
  // 或
  builder: (_) => _buildTechLoading(message),   // 科技感风格
  // 或
  builder: (_) => _buildGlassLoading(message),  // 毛玻璃效果
 */
