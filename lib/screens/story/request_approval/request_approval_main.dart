import 'package:flutter/material.dart';
import 'package:pets/common/gradient_bg.dart';
import 'package:pets/screens/story/request_approval/components/approval_items.dart';

class RequestApprovalMain extends StatefulWidget {
  const RequestApprovalMain({Key key}) : super(key: key);

  @override
  _RequestApprovalMainState createState() => _RequestApprovalMainState();
}

class _RequestApprovalMainState extends State<RequestApprovalMain> {
  @override
  Widget build(BuildContext context) {
    return GradientBg(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView.builder(
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return ApprovalItems(
                title: 'Requester Name $index',
                height: 70,
                onApproval: () {},
                onDecline: () {},
              );
            },
          ),
        ),
      ),
    );
  }
}
