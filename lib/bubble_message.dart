import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message extends StatelessWidget {
  final message;
  final bool isMe;

  Message(this.message, this.isMe);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: (isMe) ? const Color(0xFFE09DB6) : const Color(0xFFb4a7d6),
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: (isMe) ? const Radius.circular(20) : Radius.zero,
                bottomRight: (isMe) ? Radius.zero : const Radius.circular(20)),
          ),
          width: width * 0.75,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(message,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.black)),
          )),
        )
      ],
    );
  }
}
