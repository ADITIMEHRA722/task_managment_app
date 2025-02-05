// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'views/home_screen.dart';

// // void main() {
// //   runApp(ProviderScope(child: MyApp()));
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: HomeScreen(),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sizer/sizer.dart';
// import 'package:task_managment_app/viewmodels/preferences_viewmodel.dart';
// import 'views/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await Hive.openBox('preferences'); // Open Hive box for storing user preferences

//   runApp(ProviderScope(child: MyApp()));
// }

// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final preferences  = ref.watch(preferencesProvider);
//     final sizer = Sizer();
//     return MaterialApp(
//       builder: sizer.builder,
//       debugShowCheckedModeBanner: false,
//       theme: preferences.isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart'; // Import sizer for responsiveness
import 'package:task_managment_app/viewmodels/preferences_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('preferences'); // Open Hive box for storing user preferences

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: preferences.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: HomeScreen(),
        );
      },
    );
  }
}
