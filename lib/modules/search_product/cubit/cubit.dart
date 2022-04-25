import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/models/list_product_model.dart';
import 'package:hti_store/modules/search_product/cubit/states.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/components/constants.dart';
import 'package:hti_store/shared/network/end_points.dart';
import 'package:hti_store/shared/network/remote/dio_helper.dart';

class SearchProductCubit extends Cubit<SearchProductStates> {
  SearchProductCubit() : super(SearchInitialState());

  static SearchProductCubit get(context) => BlocProvider.of(context);

  // Initial Selected Value
  String dropDownValue = getRolesInArabic().first;
  ListProductModel? listProductModel;
  // List of items in our dropdown menu
  var items = getRolesInArabic();

  void changeDropDownMenu(String value) {
    dropDownValue = value;
    emit(ChangeDropDownMenu(dropDownValue));
  }

  void searchProduct(name) {
    emit(SearchLoadingState());

    DioHelper.getData(
      url: GET_ALL_IN_STORE,
      query: {
        'name': name,
      },
      token: token  ,
    )
        .then((value) => {
              if (value.data != null)
                {
                  print(value.data),
                  listProductModel = ListProductModel.fromJson(value.data),
                  if (listProductModel!.data!.data!.isEmpty)
                    {emit(SearchIsEmpty())}
                  else
                    {emit(SearchSuccessState(listProductModel!))}
                }
              else
                {emit(SearchErrorState("هناك خطاء في استلام البينات"))}
            })
        .catchError((error) {
      print(error.toString());
      if (error.toString().contains("SocketException")) {
        emit(SearchErrorState("هناك مشكله في الاتصال"));
      } else {
        emit(SearchErrorState("هناك خطاء في استلام البينات"));
      }
    });
  }

}
