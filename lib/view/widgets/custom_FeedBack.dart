import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio/controller/main_screen_controller.dart';

class CustomFeedBack extends GetView<MainScreenController> {
  CustomFeedBack({
    Key? key,
    required this.feedback,
    required this.img,
    required this.name,
    required this.email,
  }) : super(key: key);
  final String img;
  final String name;
  final String feedback;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(img),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.lightBlue,
                          size: 16,
                        )
                      ],
                    ),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  feedback,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
