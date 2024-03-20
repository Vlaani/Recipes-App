import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_back))),
        Expanded(
            child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFEDEDED),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        Image.asset(
                          "resources/test_image.png",
                          fit: BoxFit.fitHeight,
                          height: 200,
                        )
                      ],
                    ))),
          ],
        ))
      ],
    );
  }
}
