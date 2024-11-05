import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/Bloc/scheme_bloc.dart';
import 'dart:convert';

import '../Constant.dart';

class SchemeScreen extends StatefulWidget {
  @override
  _SchemeScreenState createState() => _SchemeScreenState();
}

class _SchemeScreenState extends State<SchemeScreen> {

  int currentPage = 1;
  var totalPage ;
  bool loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SchemeBloc>().add(FetchSchemeEvent(currentPage));
    _scrollController.addListener(_onScroll);
    // fetchSchemes();
  }

  void _onScroll(){
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if(currentPage < totalPage){
        loading = true;
        setState(() {

        });
        context.read<SchemeBloc>().add(FetchSchemeEvent(++currentPage, pagination: true));
      }
    }
  }



  var searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white,),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "View Schemes",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // To balance the back button space
                ],
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {

                  },
                  decoration: InputDecoration(
                    hintText: "enter... unit no type status",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Constant.bgText,
        ),
      ),
      body: BlocBuilder<SchemeBloc, SchemeState>(
          builder: (context, state) {
            if(state is SchemeLoading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(state is SchemeSuccess){
              currentPage = state.schemeModel.result!.properties!.currentPage!;
              totalPage = state.schemeModel.result?.properties?.lastPage;
              // loading = false;

              return ListView(
                controller: _scrollController,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.schemeModel.result?.properties?.data?.length,
                  itemBuilder: (context, index) {
                    final data = state.schemeModel.result?.properties!.data?[index];
                    var status = data?.propertyStatus == '1' ? 'Available' : data?.propertyStatus == '2' ? 'Book' : data?.propertyStatus == '3' ? 'Hold' : data?.propertyStatus == '4' ? 'Cancel' : 'Complete';
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(backgroundColor: Colors.blue.shade50,collapsedBackgroundColor: Colors.blue.shade50,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${data?.plotType}-${data?.plotName}', style: TextStyle(fontWeight: FontWeight.bold, color: Constant.bgText),),
                                Text('${data?.schemeName}', style: TextStyle( color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                            Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
                          ],
                        ),
                        trailing: SizedBox.shrink(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(color: Colors.grey, thickness: 1, height: 1,),
                          ),
                          if (data?.attributesData != null) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                json.decode(data!.attributesData!)
                                    .entries
                                    .map((entry) => '${entry.key}: ${entry.value}')
                                    .join(', '),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                            ),
                          ],

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  height: 40,
                                  width: 120,
                                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Constant.bgText,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: Text('Book/Hold', style: TextStyle(color: Colors.white),),
                                  )

                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                currentPage != totalPage && loading == true
                ? Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) : SizedBox(),]
              );
            }
            if(state is SchemeError){
              return Center(
                child: Text(state.error),
              );
            }
            return const SizedBox();
          },
        ),
    );
  }
}
