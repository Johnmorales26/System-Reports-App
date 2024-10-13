import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:system_reports_app/ui/appModule/assets.dart';

import '../signInModule/sign_in_screen.dart';
import '../style/dimens.dart';

class SliderScreen extends StatelessWidget {
  SliderScreen({super.key});

  static String route = '/SliderScreen';

  final List<String> _imgSlider = [
    Assets.imgSliderOne,
    Assets.imgSliderTwo,
    Assets.imgSliderThree,
    Assets.imgSliderFour,
    Assets.imgSliderFive,
    Assets.imgSliderSix,
    Assets.imgSliderSeven,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('System Reports'),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Assets.imgSilbec, fit: BoxFit.fill, height: 100),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 400.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(milliseconds: 3000)),
                    items: _imgSlider.map((resource) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimens.commonPaddingMin),
                              child: SvgPicture.asset(resource,
                                  semanticsLabel: 'Acme Logo'));
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, SignInScreen.route),
                          child: const Text('Start')))
                ])));
  }
}
