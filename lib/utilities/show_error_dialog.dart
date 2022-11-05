import 'package:flutter/material.dart';

Future<void> showErrorMsg(String title, String content, BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.all(0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(child: Text(title)),
          content: Text(content),
          actions: [
            const Divider(
              height: 3,
              thickness: 1,
            ),
            InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  child: Center(
                      child: Text(
                    'Dismiss',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue,fontSize:15),
                  )),
                ),
              ),
            )
          ],
        );
      });
}
