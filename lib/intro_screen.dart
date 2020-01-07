import 'package:flutter/material.dart';
import 'package:flutter_memo/chat_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "채팅으로 가볍게 메모하기",
          body: "메신저에 메모하는 대신,\n메모만을 위해 준비된\n나에게 보내기가 있습니다.",
          image: _buildImage('intro_1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "가볍게 가져와서 정리하기",
          body: "드래그 앤 드롭으로 쉽고 가볍게\n메모를 카테고리별로 정리하세요.",
          image: _buildImage('intro_2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "나만의 카테고리 지정하기",
          body: "기본 카테고리를\n원하는 대로 설정하세요.",
          image: _buildImage('intro_3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "손쉬운 메모 관리",
          body: "삭제는 왼쪽으로\n카테고리 초기화는 오른쪽으로 가볍게.",
          image: _buildImage('intro_4'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('넘기기'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('시작하기', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
