// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:meonji/config/palette.dart';
import 'package:google_fonts/google_fonts.dart'; // 폰트
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meonji/screens/loading.dart'; // 사용자 등록/인증 관련

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  // firebase auth 인스턴스 생성 (변하지 않는 private)
  final _authentification = FirebaseAuth.instance;
  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();
  String userName = ''; // 검증값 (이름)
  String userEmail = ''; // 검증값 (이메일)
  String userPassword = ''; // 검증값 (비밀번호)

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Image.asset(
              'image/background.jpg', fit: BoxFit.cover, // 배경 늘리기
              width: double.infinity, // 여백 없애기
              height: double.infinity, // 여백 없애기
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('image/login_logo.jpg'),
                      fit: BoxFit.fill),
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 90, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '환영합니다!',
                          style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.black),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? ' 먼지어때?' : ' 다시 뵙게되어',
                              style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        isSignupScreen ? '회원가입' : '로그인',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //배경
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: 180,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                padding: EdgeInsets.all(20.0),
                height: isSignupScreen ? 330.0 : 300.0,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.orange,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                      if (isSignupScreen) // 회원가입 페이지
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: ValueKey(1),
                                  validator: (value) {
                                    if (value!.isEmpty || value!.length < 4) {
                                      return '이름은 두 글자 이상을 입력해주세요! (4 character+)';
                                    }
                                    return null;
                                  },
                                  // 검증하기 위한 입력 값 저장
                                  onSaved: (value) {
                                    userName = value!;
                                  },
                                  // Firebase에서 검증하기 위한 입력 값 저장
                                  onChanged: (value) {
                                    userName = value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: 'User name',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: ValueKey(2),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return '올바르지 않은 이메일 형식입니다! (@가 빠졌어요!)';
                                    }
                                    return null;
                                  },
                                  // 검증하기 위한 입력 값 저장
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  // Firebase에서 검증하기 위한 입력 값 저장
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: 'email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key: ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '패스워드는 7글자 이상이어야 해요!';
                                    }
                                    return null;
                                  },

                                  // 검증하기 위한 입력 값 저장
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  // Firebase에서 검증하기 위한 입력 값 저장
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isSignupScreen) // 로그인 페이지
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  key: ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return '올바르지 않은 이메일 형식입니다! (@가 빠졌어요!)';
                                    }
                                    return null;
                                  },
                                  // 검증하기 위한 입력 값 저장
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  // Firebase에서 검증하기 위한 입력 값 저장
                                  onChanged: (value) {
                                    userEmail = value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: 'email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  key: ValueKey(5),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '패스워드는 7글자 이상이어야 해요!';
                                    }
                                    return null;
                                  },
                                  // 검증하기 위한 입력 값 저장
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  // Firebase에서 검증하기 위한 입력 값 저장
                                  onChanged: (value) {
                                    userPassword = value;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Palette.iconColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.textColor1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(35.0),
                                        ),
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Palette.textColor1),
                                      contentPadding: EdgeInsets.all(10)),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            //텍스트 폼 필드
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 480 : 410,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: GestureDetector(
                    onTap: () async {
                      // 회원가입 화면일 경우
                      if (isSignupScreen) {
                        _tryValidation();

                        // 회원가입 성공
                        try {
                          final newUser = await _authentification
                              .createUserWithEmailAndPassword(
                            email: userEmail,
                            password: userPassword,
                          );

                          // 가입성공 후 Loading 페이지로 이동
                          if (newUser.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Loading(); // Loading 페이지로 이동
                              }),
                            );
                          }
                          // 회원가입 실패
                        } catch (e) {
                          print(e); // 콘솔
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('잘못된 이메일이나 비밀번호입니다!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      }

                      // 로그인 화면일 경우
                      if (!isSignupScreen) {
                        _tryValidation();

                        try {
                          // 로그인 정보 넘겨주기
                          final newUser = await _authentification
                              .signInWithEmailAndPassword(
                            email: userEmail,
                            password: userPassword,
                          );

                          // 가입성공 후 Loading 페이지로 이동
                          if (newUser.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Loading(); // Loading 페이지로 이동
                              }),
                            );
                          }
                        } catch (e) {
                          print(e); // 콘솔
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('잘못된 이메일이나 비밀번호입니다!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.orange, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //전송버튼
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen
                  ? MediaQuery.of(context).size.height - 125
                  : MediaQuery.of(context).size.height - 165,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  SizedBox(height: 12.0),
                  Text(
                    isSignupScreen ? 'or Signup with' : 'or Signin with',
                    style: GoogleFonts.lato(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Palette.googleColor),
                    icon: Icon(Icons.add),
                    label: Text('Google'),
                  ),
                ],
              ),
            ),
            //구글 로그인 버튼
          ],
        ),
      ),
    );
  }
}
