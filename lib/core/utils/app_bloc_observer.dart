import 'package:bloc/bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:use_me/core/utils/app_logging.dart';

class AppBlocObserver extends TalkerBlocObserver {
  AppBlocObserver() : super(talker: talker);
}
