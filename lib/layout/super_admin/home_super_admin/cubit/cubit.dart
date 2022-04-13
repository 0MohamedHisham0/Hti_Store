import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti_store/layout/super_admin/home_super_admin/cubit/states.dart';

class HomeSuperUserCubit extends Cubit<HomeSuperUserStates> {
  HomeSuperUserCubit() : super(HomeSuperUserInitialState());

  static HomeSuperUserCubit get(context) => BlocProvider.of(context);

  // Initial Selected Value
  String dropDownValue = 'جميع الموظفين';

  // List of items in our dropdown menu
  var items = [
    'جميع الموظفين',
    'امناء المخازن',
    'مديرين المخازن',
    'مسؤولين الاضافه',
    'مسؤولين الرقابه',
    'الجهات و الاقسام',
  ];

  void changeDropDownMenu(String value) {
    dropDownValue = value;
    emit(ChangeDropDownMenu());
  }
}
