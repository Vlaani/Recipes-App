import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes_app/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.user, {Key? key}) : super(key: key);
  final User user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(),
        Flexible(
            flex: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                        Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.user.userName,
                                            overflow: TextOverflow.visible,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 24,
                                                height: 1,
                                                color: Color(0xFF666666))),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.settings,
                                                size: 32,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Text("@" + widget.user.login,
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            height: 1,
                                            color: Color(0xFF666666))),
                                    SizedBox(
                                        width: 140,
                                        child: TextButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .pressed) ||
                                                      states.contains(
                                                          MaterialState
                                                              .hovered))
                                                    return Colors.amber;
                                                  return Colors.amber.withOpacity(
                                                      0.5); // null throus error in flutter 2.2+.
                                                })),
                                            child: Text("Избранное",
                                                overflow: TextOverflow.visible,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    height: 1,
                                                    color: Color(0xFF666666)))))
                                  ],
                                ),
                              ],
                            ))
                      ],
                    )),
                Flexible(flex: 75, child: ListView())
              ],
            ))
      ],
    );
  }
}
