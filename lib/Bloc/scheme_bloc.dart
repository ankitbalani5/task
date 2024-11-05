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
    // emit(SchemeLoading());
    try{
      if (event.page == 1 && _schemeData == null) {
        final response = await Api.fetchSchemeApi(event.page);
        _schemeData = response;
        emit(SchemeLoading());
      }
      final response = await Api.fetchSchemeApi(event.page);
      if(response != null){


        List<Data> currentData = [];

        currentData = _schemeData!.result!.properties!.data!;

        // if (state is SchemeSuccess) {
        //   currentData = (state as SchemeSuccess).schemeModel.result!.properties!.data!;
        // }
        final newData;

        if(event.pagination == false){
          newData = [...response.result!.properties!.data!];
        }else{
          newData = [...currentData, ...response.result!.properties!.data!];
        }


        final updatedData = response.result!.properties!.copyWith(data: newData);

        final updatedResult = response.result!.copyWith(properties: updatedData);

        _schemeData = response.copyWith(result: updatedResult);


        print('currentPage:::;${event.page}');
        print('new0Data len:::;${newData.length}');
        emit(SchemeSuccess(_schemeData!));
        currentData = newData;

        // emit(SchemeSuccess(response));
      }
    }on SocketException{
      emit(SchemeError('Please check your internet connection'));
    }catch(e){
      emit(SchemeError(e.toString()));

    }
  }
}
