import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'net/check_net.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NetworkBloc()..add(ListenConnection()),
        child: CheckInternet(),
      )));
}
