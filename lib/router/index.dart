import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medi_talk_for_flutter/utils/shared_preferences_util.dart';
import 'package:medi_talk_for_flutter/lang/routers.dart';
import 'package:medi_talk_for_flutter/views/doctor/appointment/congratulaton/index.dart';
import 'package:medi_talk_for_flutter/views/doctor/appointment/index.dart';
import 'package:medi_talk_for_flutter/views/doctor/detail/index.dart';
import 'package:medi_talk_for_flutter/views/doctor/patient/index.dart';
import 'package:medi_talk_for_flutter/views/landing/index.dart';
import 'package:medi_talk_for_flutter/views/login/index.dart';
import 'package:medi_talk_for_flutter/views/main/appointment/index.dart';
import 'package:medi_talk_for_flutter/views/main/index.dart';
import 'package:medi_talk_for_flutter/views/message/detail/index.dart';
import 'package:medi_talk_for_flutter/views/signup/index.dart';

final Map<String, Function> routes = {
  Routers.LANDING: (context) => const Landing(),
  Routers.LOGIN: (context) => const Login(),
  Routers.SIGN_UP: (context) => const Signup(),
  Routers.MAIN: (context) => const Main(),
  Routers.DOCTOR_DETAIL: (context) => const DoctorDetail(),
  Routers.DOCTOR_APPOINTMENT: (context) => const DoctorAppointment(),
  Routers.PATIENT_IS_DETAILS: (context) => const PatientDetail(),
  Routers.CONGRATULATON: (context) => const Congratulaton(),
  Routers.MESSAGE_DETAIL:(context) => const MessageDetail(),
};

final List<String> noValidationRouters = <String>[
  Routers.LANDING,
  Routers.LOGIN,
  Routers.SIGN_UP,
];

var onGenerateRoute = (RouteSettings settings) {
  //String? 表示name为可空类型
  final String? name = settings.name;
  //Function? 表示pageContentBuilder为可空类型
  final Function? pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    // 判断是否第一次打开App(打开引导页)
    bool? firstOpenStatus = SharedPreferencesUtil.preferences.getBool("fistOpen");
    if (firstOpenStatus == null || !firstOpenStatus) {
      return MaterialPageRoute(builder: (context) => const Landing());
    }

    // 非登录界面检测是否有token的存在,其余的都要登录
    if (noValidationRouters.isNotEmpty && !noValidationRouters.contains(name)) {
      String? token = SharedPreferencesUtil.preferences.getString("token");
      if (token == null) {
        EasyLoading.showToast("请您先登录后再执行操作");
        return MaterialPageRoute(builder: (context) => const Login());
      }
    }

    late Route route;
    if (settings.arguments != null) {
      route = MaterialPageRoute(
        builder: (context) {
          return pageContentBuilder(context, arguments: settings.arguments);
        },
      );
    } else {
      route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    }

    return route;
  }
  return null;
};
