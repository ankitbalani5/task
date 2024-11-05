part of 'scheme_bloc.dart';

@immutable
abstract class SchemeState {}

class SchemeInitial extends SchemeState {}
class SchemeLoading extends SchemeState {}
class SchemeSuccess extends SchemeState {
  SchemeModel schemeModel;
  SchemeSuccess(this.schemeModel);
}
class SchemeError extends SchemeState {
  final error;
  SchemeError(this.error);
}
