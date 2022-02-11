import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'core/widgets/app_styles.dart';

class OTPCheck extends StatefulWidget {
  const OTPCheck({Key key}) : super(key: key);

  @override
  _OTPCheckState createState() => _OTPCheckState();
}

class _OTPCheckState extends State<OTPCheck> with CodeAutoFill {
  TextEditingController _otpTextController = TextEditingController();
  @override
  void initState() {
    initOTPListener();
    super.initState();
  }

  Future<void> initOTPListener() async{
    await SmsAutoFill().listenForCode;
    await SmsAutoFill().getAppSignature.then((appSignature) {
      print("Sms getAppSignature $appSignature");
    });
  }

  @override
  void codeUpdated() {
    print("Sms codeUpdated $code");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: PinFieldAutoFill(
      keyboardType: TextInputType.phone,
      codeLength: 4,
      controller: _otpTextController,
      onCodeChanged: (code){
        print("Sms onCodeChanged $code");
      },
      onCodeSubmitted: (code){
        print("Sms onCodeSubmitted $code");
      },
      decoration: UnderlineDecoration(
        textStyle: AppStyles.otpTextStyle(),
        colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.6)),
      ),
    ),),);
  }


}
