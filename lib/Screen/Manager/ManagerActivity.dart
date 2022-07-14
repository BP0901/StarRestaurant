import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:star_restaurant/Screen/Manager/components/card_custom.dart';
import 'package:star_restaurant/Screen/Manager/components/circle_progress.dart';
import 'package:star_restaurant/Screen/Manager/components/list_tile_custom.dart';
import 'package:star_restaurant/Screen/Manager/components/themes.dart';
import './components/DrawerMGTM.dart';
import '../../../Util/Constants.dart';

class ManagerActivity extends StatefulWidget {
  const ManagerActivity({Key? key}) : super(key: key);

  @override
  State<ManagerActivity> createState() => _ManagermentActivityState();
}

class _ManagermentActivityState extends State<ManagerActivity> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: kAppBarColor,
            title: const Text("Trang quản lý thông tin")),
        drawer: const DrawerMGTM(),
        body: SafeArea(
          child: Material(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width / 2 - 20,
                            child: Column(
                              children: [
                                CustomPaint(
                                  foregroundPainter: CircleProgress(),
                                  child: SizedBox(
                                    width: 107,
                                    height: 107,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "345",
                                          style: textBold,
                                        ),
                                        Text(
                                          "REACH",
                                          style: textSemiBold,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_upward_outlined,
                                              color: green,
                                              size: 14,
                                            ),
                                            Text(
                                              "8.1%",
                                              style: textSemiBold,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "NEW ACHIEVMENT",
                                  style: textBold2,
                                ),
                                Text(
                                  "Social Star",
                                  style: textBold3,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width / 2 - 20,
                            height: 180,
                            decoration: const BoxDecoration(
                                // image: DecorationImage(
                                //     image: AssetImage(
                                //         "assets/images/people.png"))
                                ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6,
                      color: sparatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: "Key metrics",
                                style: GoogleFonts.montserrat().copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: purple1),
                                children: const <TextSpan>[
                                  TextSpan(
                                      text: " this week",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              CardCustom(
                                width: size.width / 2 - 23,
                                height: 88.9,
                                mLeft: 0,
                                mRight: 3,
                                child: ListTileCustom(
                                  bgColor: purpleLight,
                                  pathIcon: "line.svg",
                                  title: "VISITS",
                                  subTitle: "4,324",
                                ),
                              ),
                              CardCustom(
                                width: size.width / 2 - 23,
                                height: 88.9,
                                mLeft: 3,
                                mRight: 0,
                                child: ListTileCustom(
                                  bgColor: greenLight,
                                  pathIcon: "thumb_up.svg",
                                  title: "LIKES",
                                  subTitle: "654",
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CardCustom(
                                width: size.width / 2 - 23,
                                height: 88.9,
                                mLeft: 0,
                                mRight: 3,
                                child: ListTileCustom(
                                  bgColor: yellowLight,
                                  pathIcon: "starts.svg",
                                  title: "FAVORITES",
                                  subTitle: "855",
                                ),
                              ),
                              CardCustom(
                                width: size.width / 2 - 23,
                                height: 88.9,
                                mLeft: 3,
                                mRight: 0,
                                child: ListTileCustom(
                                  bgColor: blueLight,
                                  pathIcon: "eyes.svg",
                                  title: "VIEWS",
                                  subTitle: "5,436",
                                ),
                              ),
                            ],
                          ),
                          CardCustom(
                              mLeft: 0,
                              mRight: 0,
                              width: size.width - 40,
                              height: 211,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 9.71,
                                          height: 9.71,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: purple2),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "Visits",
                                          style: label,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Container(
                                          width: 9.71,
                                          height: 9.71,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: green),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "Likes",
                                          style: label,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Container(
                                          width: 9.71,
                                          height: 9.71,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: red),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "Conversions",
                                          style: label,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width - 40,
                                    height: 144.35,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),

                                      // image: DecorationImage(
                                      //     image: AssetImage(
                                      //         "assets/images/graph.png"),
                                      //     fit: BoxFit.fill)
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
