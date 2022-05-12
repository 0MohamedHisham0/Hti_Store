import 'package:flutter/material.dart';
import 'package:hti_store/modules/login/login_screen.dart';
import 'package:hti_store/shared/components/components.dart';
import 'package:hti_store/shared/network/local/cache_helper.dart';
import 'package:hti_store/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;


  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}


class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboarding_3.svg',
      title: 'سهوله التعامل بين موظفين',
      body:
          'يمكن لجميع الموظفين التعامل مع بعضهم فثلا يمكن للموردين ارسال المتجات الجديده الي مسؤول الاضافه و مسؤول الاضافه يمكنه ارسلها اللي مدير المخازن وبعد مرجعتها يمكنه ان حفظها في المخزن نفسه.',
    ),
    BoardingModel(
      image: 'assets/images/onboarding_2.svg',
      title: 'سهوله التعامل مع المخازن',
      body:
          'تسطيع ان تطلع علي جميع المنتجات الموجوه في المخزن من خلال هاتفك و ايضا يمكنك طلب النوع و الكميه التي ترغب  بها و تنتظر حتي يتم التأكيد علي طلبك من قبل الموظفين.',
    ),
    BoardingModel(
      image: 'assets/images/onboarding_1.svg',
      title: 'تنظيم حركه المنتجات',
      body:
          'يمكن لكل جهه او قسم الاطلاع علي المنتجات التي في المخزن سواء كانت مستديمه (مثل الاثاث) او مستهلكه (مثل الطعام) و بعد ان يطلب الطلب المكون من نوع المنتج والكميه المرغوب فيها سيظهر طلبه لامين المخازن و من هنا يسطيع امين المخازن ارسال الطلب له او رفضه اذا كان الطلب متاح بالمخزن',
    ),
  ];


  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value!) {
        navigateAndFinish(
          context,
          LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: () {
              submit();
            },
            text: 'تخطي',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SmoothPageIndicator(
              controller: boardController,
              effect: const SwapEffect(
                dotColor: Colors.grey,
                activeDotColor: defaultColor,
                dotHeight: 10,
                dotWidth: 20,
                spacing: 10.0,
              ),
              count: boarding.length,
            ),
            Row(
              children: [
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: const Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: svgImage(path: model.image)),
          Text(
            model.title,
            style: const TextStyle(
              fontSize: 24.0,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            model.body,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      );
}
