import 'package:flutter/material.dart';
import 'package:pets/theming/common_size.dart';

class ApprovalItems extends StatelessWidget {
  final String title;
  final String image;
  final double height;
  final Function() onDecline;
  final Function() onApproval;
  const ApprovalItems(
      {Key key,
      @required this.title,
      this.image,
      this.onDecline,
      this.onApproval,
      this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double margin = 10;
    _button(IconData icon, String title, Color color, Function() onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 2),
                  borderRadius: BorderRadius.circular(height),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(margin),
            width: height - margin,
            height: height - margin,
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(height),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://unsplash.com/photos/2UZ4kQRImVg/download?force=true&w=640'))),
          ),
          Expanded(child: Text(title)),
          _button(Icons.done, 'Accept', Colors.green, onApproval),
          _button(Icons.close, 'Decline', Colors.grey, onDecline)
        ],
      ),
    );
  }
}
