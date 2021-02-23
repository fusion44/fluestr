library fluestr.constants;

import 'package:flutter/material.dart';

const String heroTagfluestrLogo = 'hero_fluestr_logo';

// Preferences keys
const String prefLanguageCode = 'language_preference';
const String prefTheme = 'theme_preference';
const String prefOnboardingFinished = 'onboarding_finished';
const String prefNumNodes = 'num_nodes';
const String prefPinActive = 'pin_active';
const String prefPin = 'pin_string';

// Themeing
const fluestrBackground = Color(0xff32333d);
const fluestrBackgroundAccent = Color(0xff26282f);
const fluestrBackgroundCard = Color(0xff393942);
const fluestrPrimaryGreen700 = Color(0xff007d51);
const fluestrPrimaryGreen500 = Color(0xff1eb980);
const fluestrPrimaryGreen300 = Color(0xff37efba);
const fluestrDarkGreen = Color(0xff045d56);
const fluestrOrange300 = Color(0xffff5d56);
const fluestrOrange200 = Color(0xffff857c);
const fluestrOrange50 = Color(0xffff857c);
const fluestrYellow500 = Color(0xffffac12);
const fluestrYellow300 = Color(0xffffcf44);
const fluestrYellow200 = Color(0xffffdc78);
const fluestrPurple300 = Color(0xffa932ff);
const fluestrPurple200 = Color(0xffb15dff);
const fluestrPurple50 = Color(0xffdecaf7);
const fluestrBlue700 = Color(0xff0082fb);
const fluestrBlue200 = Color(0xff72deff);
const fluestrBlue100 = Color(0xffb2f2ff);

const themeFluestr = 'fluestr';
const themeDark = 'dark';
const themeLight = 'light';

const double defaultHorizontalWhiteSpace = 4.0;

// Background processing
class LocalNotificationChannels {
  static String chatChannelID = 'fluestr_chat';
  static String chatChannelName = 'Chat';
  static String chatChannelDescription = 'Chat messages';
}
