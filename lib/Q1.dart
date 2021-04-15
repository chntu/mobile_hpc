import 'package:flutter/material.dart';
import 'constants.dart';

import 'package:video_player/video_player.dart';

class Q1 extends StatefulWidget {
  @override
  _Q1State createState() => _Q1State();
}

class _Q1State extends State<Q1> {
  double sliderAnswer = 0;
  String sliderText = "";
  bool isPlaying = true;
  VideoPlayerController _audioController;
  VideoPlayerController _videoController;
  double audioProgress = 0;
  int questionNum = 0;
  Future<void> _initAudioPlayer;
  Future<void> _initVideoPlayer;

  //calculate and return app width given current screen height. Aspect ratio 16:9
  getAppWidth(double screenHeight) {
    return screenHeight*9/16;
  }

  updateSliderText() {
    if (sliderAnswer <= .3) {
      sliderText = kSliderText[questionNum][0];
    } else if (sliderAnswer >=.7) {
      sliderText = kSliderText[questionNum][2];
    } else {
      sliderText = kSliderText[questionNum][1];
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
    _audioController.pause();
    audioProgress = 1;
    setState(() {});
  }
  saveUserAnswer() {

  }
  resetAnswer() {
    sliderAnswer = 0;
    setState(() {});
  }

  @override
  void initState() {
    //Initialize to play audio using Video player package
    _audioController = VideoPlayerController.asset('assets/audio/${questionNum+1}.m4a');
    _initAudioPlayer = _audioController.initialize();
    _audioController.play();
    isPlaying = true;
    _audioController.addListener(() {
      updateAudioProgress(_audioController.value.position.inSeconds.toDouble(), _audioController.value.duration.inSeconds.toDouble());
      if (_audioController.value.isPlaying  == false) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    //Initialize to play Video using Video player package
    _videoController = VideoPlayerController.asset('assets/video/V${questionNum+1}.mp4');
    _initVideoPlayer = _videoController.initialize();
    _videoController.play();
    super.initState();
  }

  @override
  void dispose() {
    _audioController.dispose();
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
      body: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                    maxHeight: 500*9/16,
                  ),
                  child: _videoController.value.initialized
                      ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                      : Container(
                    color: Color(0xFFFAEC7E),
                    width: screenWidth-50,
                    height: (screenWidth-50)*9/16,
                  ),
                ),
                kSpaceBetweenElements,
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: RaisedButton(
                    onPressed: (){
                      endAudio();
                    },
                    color: Color(0xFFFAAF01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 13,
                          width: 13,
                          child: CircularProgressIndicator(
                            value: audioProgress,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFAEC7E)),
                            strokeWidth: 3.0,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text('Skip audio',style: kWhiteTextStyle,),
                      ],
                    ),
                  ),
                ),
                kSpaceBetweenElements,
                ///Description text
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Text(kDescription[questionNum], textAlign: TextAlign.center, style: TextStyle(
                    color: Color(0xFFFAEC7E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
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
                          ///question text
                          Center(child: Text(kQuestion[questionNum], textAlign: TextAlign.center, style: kWhiteTextStyle,)),
                          kSpaceBetweenElements,
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: Slider(
                              value: sliderAnswer,
                              activeColor: Colors.white,
                              inactiveColor: Color(0xFF009997),
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
                          RaisedButton(
                            onPressed: (){
                              updateCurrentQuestionNumber();
                            },
                            color: Color(0xFFFAAF01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Submit',
                                  style: kWhiteTextStyle,
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
