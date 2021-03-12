import 'package:flutter/material.dart';
import 'constants.dart';

import 'package:video_player/video_player.dart';

class Q1 extends StatefulWidget {
  @override
  _Q1State createState() => _Q1State();
}

class _Q1State extends State<Q1> {
  bool isYesClicked = false;
  bool isNoClicked = false;
  double sliderAnswer = 0;
  String sliderText = "Not going to happen!";
  bool isPlaying = true;
  VideoPlayerController _controller;
  double audioProgress = 0;
  int questionNum = 0;
  Future<void> _initializeVideoPlayerFuture;

  //calculate and return app width given current screen height. Aspect ratio 16:9
  getAppWidth(double screenHeight) {
    return screenHeight*9/16;
  }

  updateSliderText() {
    if (sliderAnswer < .3) {
      sliderText = "Not going to happen!";
    } else if (sliderAnswer >.6) {
      sliderText = "100% for sure";
    } else {
      sliderText = "It depends";
    }
  }

  updateAudioProgress(double currentPos, double duration) {
    setState(() {
      audioProgress = currentPos/duration;
    });
  }

  updateCurrentQuestionNumber() {
    setState(() {
      if (questionNum>=kQuestion.length-1) {
        questionNum = 0;
      } else {
        questionNum ++;
        initState();
      }
    });
  }
  endAudio() {
    _controller.pause();
    audioProgress = 1;
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/audio/${questionNum+1}.m4a');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    isPlaying = true;
    _controller.addListener(() {
      updateAudioProgress(_controller.value.position.inSeconds.toDouble(), _controller.value.duration.inSeconds.toDouble());
      if (_controller.value.isPlaying  == false) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF13B8BF),
      appBar: AppBar(
        backgroundColor: Color(0xFF009997),
        leading: Image(
          image: AssetImage('single.png'),
        ),
        title: Text("Happy Community Quest", style: kWhiteTextStyle,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              kSpaceBetweenElements,
              Container(
                constraints: BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 500*9/16,
                ),
                color: Color(0xFFFAEC7E),
                width: screenWidth-50,
                height: (screenWidth-50)*9/16,
              ),
              kSpaceBetweenElements,
              CircularProgressIndicator(
                value: audioProgress,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              kSpaceBetweenElements,
              RaisedButton(
                onPressed: (){
                  endAudio();
                },
                child: Text('End audio',style: kWhiteTextStyle,),
              ),
              kSpaceBetweenElements,
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: isPlaying? 0 : 1,
                child: Center(
                  child: Container(
                    width: screenWidth-50,
                    constraints: BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Column(
                      children: [
                        RaisedButton(
                          onPressed: (){
                            updateCurrentQuestionNumber();
                          },
                          child: Text('Submit', style: kWhiteTextStyle,),
                        ),
                        kSpaceBetweenElements,
                        ///Title text
                        Text(kTitle[questionNum], textAlign: TextAlign.center, style: kWhiteTextStyle,),
                        kSpaceBetweenElements,
                        ///Description text
                        Text(kDescription[questionNum], textAlign: TextAlign.center, style: kWhiteTextStyle,),
                        kSpaceBetweenElements,
                        ///quesstion text
                        Center(child: Text(kQuestion[questionNum], textAlign: TextAlign.center, style: kWhiteTextStyle,)),
                        kSpaceBetweenElements,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: (){
                                setState(() {
                                  isYesClicked = !isYesClicked;
                                  isNoClicked = !isYesClicked;
                                });
                              },
                              color: isYesClicked? Color(0xffFaaf01) : Colors.white,
                              child: Text('Yes', style: isYesClicked? kWhiteTextStyle : kBlackTextStyle,),
                            ),
                            kSpaceBetweenElements,
                            RaisedButton(
                              onPressed: (){
                                setState(() {
                                  isNoClicked = !isNoClicked;
                                  isYesClicked = !isNoClicked;
                                });
                              },
                              color: isNoClicked? Color(0xffFaaf01) : Colors.white,
                              child: Text('No', style: isNoClicked? kWhiteTextStyle : kBlackTextStyle,),
                            ),
                          ],
                        ),
                        kSpaceBetweenElements,
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                          ),
                          child: Slider(
                            value: sliderAnswer,
                            divisions: 10,
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            onChanged: (newAnswer){
                              setState(() {
                                sliderAnswer = newAnswer;
                                updateSliderText();
                              });
                            },
                          ),
                        ),
                        kSpaceBetweenElements,
                        Text(sliderText, style: kWhiteTextStyle,),
                        kSpaceBetweenElements,
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            maxHeight: 500*9/16,
                          ),
                          color: Color(0xFFFAEC7E),
                          width: screenWidth-50,
                          height: (screenWidth-50)*9/16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
