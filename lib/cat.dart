import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'dart:math';

enum CatState {
  Awake,
  Sleeping,
}

class Animal {
  String petStatus = ''; // 동물 상태를 저장하는 변수
  int hungry = 100; // 공복지수
  int affection = 0; // 친밀도
  CatState catState = CatState.Awake;

  void displayInfo() {
    petStatus = '교감 중...';
    print(petStatus);
  }

  void eat() {
    petStatus = '먹는 중...';
    print(petStatus);
  }

  void sleep() {
    petStatus = '자는 중...';
    print(petStatus);
  }

  void play() {
    petStatus = '노는 중...';
    print(petStatus);
  }
}

class Cat extends StatefulWidget {
  const Cat({Key? key}) : super(key: key);

  @override
  _Cat createState() => _Cat();
}

class _Cat extends State<Cat> {
  Animal myPet = Animal();
  String currentImage = 'assets/cat_motions/cat1.svg';
  Timer? hungerTimer;
  int interactionCount = 0;

  @override
  void initState() {
    super.initState();

    // 1분마다 공복지수를 1씩 감소시키는 타이머 설정
    hungerTimer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() {
        myPet.hungry -= 1;
        if (myPet.hungry < 0) {
          myPet.hungry = 0;
        }
      });
    });

    // 밤 10시부터 아침 6시까지 자는 상태로 전환
    Timer.periodic(Duration(minutes: 1), (Timer timer) {
      var now = DateTime.now();
      if (now.hour >= 22 || now.hour < 6) {
        setState(() {
          myPet.catState = CatState.Sleeping;
        });
      } else {
        setState(() {
          myPet.catState = CatState.Awake;
        });
      }
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel(); // 페이지가 dispose될 때 타이머 해제
    super.dispose();
  }

  // 동물과 상호 작용하는 메서드
  void _interactWithPet() {
    setState(() {
      myPet.displayInfo();
      _increaseAffection(1);
      _waitForStatusChange();
    });
  }

  void _feedPet() {
    setState(() {
      myPet.eat();
      myPet.hungry += 10;
      if (myPet.hungry > 100) {
        myPet.hungry = 100;
      }
      _increaseAffection(1);
      _waitForStatusChange();
    });
  }

  // 동물과 놀기
  void _playWithPet() {
    setState(() {
      myPet.play();
      _increaseAffection(1);
      _waitForStatusChange();
    });
  }

  // 고양이와 놀아준 후 일정시간 뒤 고양이 상태 초기화를 위한 함수
  void _waitForStatusChange() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        myPet.petStatus = '';
      });
    });
  }

  // 이미지 변경 메서드
  // 고양이를 누를 때 마다 매번 랜덤으로 고양이 사진이 바뀜
  void _changeImage() {
    setState(() {
      // Generate a random number between 1 and 8
      int randomCatNumber = Random().nextInt(8) + 1;

      // Form the path for the random cat image
      currentImage = 'assets/cat_motions/cat$randomCatNumber.svg';
    });
    _increaseAffection(1); // 상호작용 정도가 1 상승
  }

  // 친밀도 증가 메서드, 버튼 클릭의 합이 50이상이면 친밀도 1증가
  void _increaseAffection(int value) {
    interactionCount += value;
    if (interactionCount >= 50) {
      myPet.affection += 1;
      interactionCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("야옹"),
        backgroundColor: Colors.yellow,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '고양이를 쓰다듬어 주세요',
            ),
            SizedBox(height: 10), // 버튼 위 간격
            // 추가: 동물 상태와 공복지수, 친밀도를 표시하는 Text 위젯
            Text(myPet.petStatus),
            Text('포만감: ${myPet.hungry}'),
            Text('친밀도: ${myPet.affection}'),
            Text('상태: ${myPet.catState == CatState.Awake ? "깨어있음" : "자는 중"}'),
            SizedBox(height: 20), // 이미지와 버튼 간 간격
            // GestureDetector를 사용하여 이미지 클릭 감지
            GestureDetector(
              onTap: _changeImage,
              child: SvgPicture.asset(
                currentImage, // 실제 SVG 파일의 경로
                width: 100,
              )
            ),
            SizedBox(height: 20), // 이미지와 버튼 간 간격
            // 밤 10시부터 아침 6시까지 잠자기 상태인 경우 "동물 잠잠" 메시지 표시
            if (myPet.catState == CatState.Sleeping)
              Text(
                '동물 잠잠',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            // 가로로 정렬된 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _interactWithPet,
                  child: const Text('상호작용'),
                ),
                SizedBox(width: 10), // 버튼 간격 조절
                ElevatedButton(
                  onPressed: _feedPet,
                  child: const Text('먹이 주기'),
                ),
                SizedBox(width: 10), // 버튼 간격 조절
                ElevatedButton(
                  onPressed: _playWithPet,
                  child: const Text('놀아주기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
