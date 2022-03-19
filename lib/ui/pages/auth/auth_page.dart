import 'dart:ui';

import 'package:auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food/models/user.dart';
import 'package:food/states_mangement/auth/auth_cubit.dart';
import 'package:food/states_mangement/auth/auth_state.dart';
import 'package:food/ui/widgets/cusom_outline_button.dart';
import 'package:food/ui/widgets/custom_flat_button.dart';
import 'package:food/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  AuthManager? _manager;
  ISignUpService? _signUpService;
  AuthPage(this._manager, this._signUpService);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _controller = PageController();
  String? _username = '';
  String? _email = '';
  String? _password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _buildLogo(),
          ),
          SizedBox(height: 10.0),
          CubitConsumer<AuthCubit, AuthState>(builder: (_, state) {
            return _buildUI();
          },
              listener: (context, state) {
            if(state is LoadingState) {
              _showLoader();
            }
            if(state is ErrorState){
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(
                      state.message,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white,fontSize: 16.0
                    ),
                  )
                  )
              );
              _hideLoader();
            }
              })
        ],
      )),
    );
  }

  _buildLogo() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.asset('assets/logo.svg',
          fit: BoxFit.fill,),
          SizedBox(height: 10.0),
          RichText(text: TextSpan(
            text: 'Food',
            style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.black,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
            children: [TextSpan(
              text: 'Space',
              style:TextStyle(
                color: Theme.of(context).accentColor,
              )
            )]
          )
      )
        ],
      ),
    );
  }

  _buildUI() => Container(
    height: 500,
    child: PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _controller,
      children: [
        _buildSignin(),
        _buildSignup(),
      ],
    ),
  );

  _buildSignin() => Padding(
      padding:const EdgeInsets.symmetric(horizontal: 24.0),
  child: Column(
      children: [
        ..._emailAndPassword(),
        SizedBox(height: 30.0,),
        CustomFlatButton(
          text: "Sign in",
          size: Size(double.infinity,54.0),
          onPressed: () {
            CubitProvider.of<AuthCubit>(context).signin(widget._manager!.
            email(email: _email, password: _password));
          }
        ),
        SizedBox(height: 30.0),
        CustomOutlineButton(
          onPressed: (){
            CubitProvider.of<AuthCubit>(context).signin(widget._manager!.google);
          },
          text: 'Sign in with google',
          size: Size(double.infinity,54.0),
          icon: SvgPicture.asset('assets/google-icon.svg',
          height: 18.0,
          width: 18.0,
          fit: BoxFit.fill,),
        ),
        SizedBox(height: 30,),
        RichText(
            text: TextSpan(
              text: 'Don\'t have an account?',
              style: Theme.of(context).textTheme.caption!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18.0
              ),
              children: [
                TextSpan(
                  text: 'SignUp',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    _controller.nextPage(
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.elasticOut
                    );
                  }

                )
              ]
            ))
      ],
  ),);

  _buildSignup() => Padding(
    padding:const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
      children: [
        CustomTextField(
          hint: 'username',
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _username = val;
          },
        ),
        SizedBox(height: 30.0,),
        ..._emailAndPassword(),
        SizedBox(height: 30.0,),
        CustomFlatButton(
            text: "Sign up",
            size: Size(double.infinity,54.0),
            onPressed: () {
              print('12');
              User user = User(name: _username, email: _email, password: _password);
              CubitProvider.of<AuthCubit>(context).signup(widget._signUpService!, user);
              print('13');
            }
        ),
        SizedBox(height: 30.0),
        CustomOutlineButton(
          onPressed: (){},
          text: 'Sign in with google',
          size: Size(double.infinity,54.0),
          icon: SvgPicture.asset('assets/google-icon.svg',
            height: 18.0,
            width: 18.0,
            fit: BoxFit.fill,),
        ),
        SizedBox(height: 30,),
        RichText(
            text: TextSpan(
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0
                ),
                children: [
                  TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        _controller.previousPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.elasticOut
                        );
                      }

                  )
                ]
            ))
      ],
    ),);


  List<Widget> _emailAndPassword() => [
    CustomTextField(
      hint: 'Email',
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      onChanged: (val) {
        _email = val;
      }
    ),
    SizedBox(height: 30.0,),
    CustomTextField(
        hint: 'Password',
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        onChanged: (val) {
          _password = val;
        }
    )
  ];

  _showLoader() {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(context: context, builder: (_)=> alert);
  }

  _hideLoader(){
    Navigator.of(context, rootNavigator: true).pop();
  }
}
