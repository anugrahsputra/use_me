import 'package:use_me/core/utils/app_logging.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class AppBlocObserver extends TalkerBlocObserver {
  AppBlocObserver({TalkerBlocLoggerSettings? settings})
    : super(
        talker: talker,
        settings:
            settings ??
            const TalkerBlocLoggerSettings(
              printChanges: true,
              printClosings: true,
              printCreations: true,
              printTransitions: true,
            ),
      );
}
