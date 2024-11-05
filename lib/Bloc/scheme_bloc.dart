import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task/Api.dart';
import 'package:task/Model/SchemeModel.dart';

part 'scheme_event.dart';
part 'scheme_state.dart';

class SchemeBloc extends Bloc<SchemeEvent, SchemeState> {
  SchemeModel? _schemeData;
  SchemeBloc() : super(SchemeInitial()) {
    on<FetchSchemeEvent>(_fetchScheme);
  }

  Future<void> _fetchScheme(FetchSchemeEvent event, Emitter<SchemeState> emit) async {
    if(_schemeData == null){
      emit(SchemeLoading());
    }
    try {
      final response = await Api.fetchSchemeApi(event.page);
      if (response != null) {
        List<Data> newData = response.result!.properties!.data!;
        if (event.pagination == true && _schemeData != null) {
          newData = [..._schemeData!.result!.properties!.data!, ...newData];
        }
        final updatedData = response.result!.properties!.copyWith(data: newData);
        final updatedResult = response.result!.copyWith(properties: updatedData);
        _schemeData = response.copyWith(result: updatedResult);
        print('page::::${event.page}');
        print('newData::::${newData.length}');
        emit(SchemeSuccess(_schemeData!));
      }
    } on SocketException {
      emit(SchemeError('Please check your internet connection'));
    } catch (e) {
      emit(SchemeError(e.toString()));
    }
  }
}
