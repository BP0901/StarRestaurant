import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlashMessageScreen extends StatelessWidget {
  const FlashMessageScreen(
      {Key? key,
      required this.type,
      required this.content,
      required this.color})
      : super(key: key);

  final String type;
  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20)),
            child: SvgPicture.asset(
              "assets/icon/bubbles.svg",
              height: 48,
              width: 40,
              color: const Color(0xFF801336),
            ),
          ),
        ),
        Positioned(
            top: -20,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
              SvgPicture.asset(
                'assets/icon/fail.svg',
                height: 40,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  'assets/icon/close.svg',
                  height: 16,
                ),
              ),
            ])),
      ],
    );
  }
}
