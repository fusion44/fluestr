import 'package:equatable/equatable.dart';
import 'package:fluestr/common/models/credentials.dart';
import 'package:isar/isar.dart';

part 'preferences.g.dart';

@Collection(ignore: {'props'})
class Preferences extends Equatable {
  // There must only be one Preferences object in the database.
  final Id id = 1;
  final bool onboardingFinished;
  final bool currentlyOnboarding;
  final String languageCode;
  final String theme;
  final Credentials credentials;

  Preferences({
    this.onboardingFinished = false,
    this.currentlyOnboarding = false,
    this.languageCode = 'en',
    this.theme = 'light',
    required this.credentials,
  });

  @override
  List<Object> get props => [
        onboardingFinished,
        currentlyOnboarding,
        languageCode,
        theme,
        credentials,
      ];

  Preferences.empty()
      : onboardingFinished = false,
        currentlyOnboarding = false,
        languageCode = 'en',
        theme = 'light',
        credentials = Credentials();

  Preferences copyWith({
    bool? onboardingFinished,
    bool? currentlyOnboarding,
    String? languageCode,
    String? theme,
    Credentials? credentials,
  }) {
    return Preferences(
      onboardingFinished: onboardingFinished ?? this.onboardingFinished,
      currentlyOnboarding: currentlyOnboarding ?? this.currentlyOnboarding,
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
      credentials: credentials ?? this.credentials,
    );
  }
}
