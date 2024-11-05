part of 'scheme_bloc.dart';

@immutable
abstract class SchemeEvent {}
class FetchSchemeEvent extends SchemeEvent {
  final page;
  final pagination;
  FetchSchemeEvent(this.page, {this.pagination = false});
}
