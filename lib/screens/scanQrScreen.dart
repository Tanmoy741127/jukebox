import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jukebox/screens/setupClientWebsocket.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool loading = false;


  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
             _buildQrView(context),
            Positioned(
              top: 25,
              right: 20,
              child: IconButton(onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              }, icon: const Icon(Icons.flashlight_on_outlined, color: Colors.white,))
            ),
            Positioned(
              bottom: 30,
              child: Container(
                width: MediaQuery.of(context).size.width*0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(visible: loading, child: const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(strokeWidth: 1.8,color: Colors.black,),)),
                    // SizedBox(width: 22,height: 22,child: Icon(Icons.check_circle_outline, color: Colors.green,size: 22,),),
                    const SizedBox(width: 20,),
                    Flexible(child: SizedBox(width: MediaQuery.of(context).size.width*0.7, child: Text(result?.code ?? "No QR Found", style: TextStyle(fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)))
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if(result?.code != null){
          Get.offAll(()=>SetupClientWebSocket(ipAddress: result?.code??""));
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      Get.snackbar("No permission", "Please allow camera permission");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
