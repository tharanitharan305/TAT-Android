import 'package:flutter/material.dart';

import 'package:tat/Widgets/Jobs.dart';

class IconGenerate {
  Icon GenerateJobIcon(Jobs jobs) {
    Icon icon = Icon(Icons.people);
    switch (jobs) {
      case Jobs.select:
        icon = Icon(Icons.select_all_rounded);
        break;
      // TODO: Handle this case.
      case Jobs.Driver:
        icon = Icon(Icons.drive_eta_rounded);
        break;
      // TODO: Handle this case.
      case Jobs.Sales_Man:
        icon = Icon(Icons.pedal_bike_rounded);
        break;
      // TODO: Handle this case.
      case Jobs.All_Rounder:
        icon = Icon(Icons.person);
        break;
      // TODO: Handle this case.
      case Jobs.others:
        icon = Icon(Icons.man_2_rounded);
        break;
      // TODO: Handle this case.
    }
    return icon;
  }
}
