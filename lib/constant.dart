import 'package:flutter/painting.dart';

const kImageUrlRecipeOfDay = 'https://loremflickr.com/200/400/food';

const kAppGradient = const [
  Color(0x77000000),
  Color(0x773C3C3C),
  Color(0x00000000)
];

const kBoxShadow = const BoxShadow(
  color: Color(0x4C000000),
  blurRadius: 4.0,
  offset: Offset(-2, -2),
);

const kWaveBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(30.0),
  bottomRight: Radius.circular(30.0),
);

const kWaveBoxDecoration = BoxDecoration(
  borderRadius: kWaveBorderRadius,
  boxShadow: [
    BoxShadow(
      color: kBoxShadowColor,
      offset: Offset(3, 3),
      blurRadius: 6.0,
    )
  ],
);

const kBoxShadowColor = Color(0x66000000);
const kBorderColor = const Color(0xFF707070);
const kWhite = const Color(0xffffffff);
const kPrimaryButtonColor = const Color(0xff6087AE);
