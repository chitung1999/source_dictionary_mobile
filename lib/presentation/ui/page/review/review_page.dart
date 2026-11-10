import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage ({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      bannerPath: 'data/banner/review.png',
      child: Container(color: Colors.red,),
    );
  }
}