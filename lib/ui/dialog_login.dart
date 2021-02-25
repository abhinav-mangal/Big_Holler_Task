import '../imports.dart';

class LoginDialog extends StatefulWidget {
  final Metadata metadata;
  final Location location;
  final ValueChanged<User> userData;
  LoginDialog({
    Key key,
    this.metadata,
    this.location,
    this.userData,
  }) : super(key: key);

  static String mandatoryTextValidator(String text) {
    text = text.trim();
    if (text.isEmpty) return t_required;

    return null;
  }

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  var _errorMessage = "";
  String _userName = "";
  String _password = "";
  bool _isBusy = false;
  bool _showPassword = true;

  Future navigateToLanding() async {
    //Dismiss the keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    User user = User();
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isBusy = true;
      });

      UserLogin userLogin = UserLogin();
      ApiService apiService = ApiService();
      userLogin.username = this._userName.trim();
      userLogin.password = this._password;
      userLogin.organizationId = widget.metadata.organizationId;

      var status = await apiService.loginEndUser(context, userLogin);
      if (status.success == true) {
        if (!mounted) return;
        SPHelper.setUserLoginData(userLogin).then((onValue) {
          print(onValue);
        });
        user = User.fromJson(status.response);
        widget.userData(user);
      } else if (status.success == false) {
        setState(() {
          _errorMessage = status.response;
          _isBusy = false;
        });
      } else {
        setState(() {
          _errorMessage = msg_something_went_wrong;
          _isBusy = false;
        });
      }
    } else
      setState(() => _isBusy = false);
  }

  dialogContent(BuildContext context) {
    void changeButtonState() {
      setState(() {
        _showPassword = !_showPassword;
      });
    }

    return SingleChildScrollView(
      child: Container(
        padding: pagePadding,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[CloseBtn()],
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          t_login.toUpperCase(),
                          style: TextStyle(
                            color: Helper.getColorFromHex(
                                widget.metadata.primaryColor),
                            fontSize: textSizeHeadingOne,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: false,
                        hintText: t_username,
                        labelText: '$t_username *',
                        labelStyle: TextStyle(color: Colors.black54),
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: TextStyle(color: Colors.black),
                      controller: userController,
                      keyboardType: TextInputType.emailAddress,
                      validator: LoginDialog.mandatoryTextValidator,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) {
                        if (_errorMessage.isNotEmpty) {
                          setState(() {
                            _errorMessage = "";
                          });
                        }
                      },
                      onSaved: (String value) {
                        _userName = value;
                      },
                      focusNode: _emailFocus,
                      onFieldSubmitted: (email) {
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_pwdFocus);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: false,
                        hintText: t_password,
                        labelText: '$t_password *',
                        labelStyle: TextStyle(color: Colors.black54),
                        hintStyle: TextStyle(color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black38,
                          ),
                          onPressed: changeButtonState,
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      controller: userPasswordController,
                      obscureText: _showPassword,
                      validator: LoginDialog.mandatoryTextValidator,
                      onChanged: (String value) {
                        if (_errorMessage.isNotEmpty) {
                          setState(() {
                            _errorMessage = "";
                          });
                        }
                      },
                      onSaved: (String value) {
                        _password = value;
                      },
                      focusNode: _pwdFocus,
                      onFieldSubmitted: (pwd) {
                        _pwdFocus.unfocus();
                        navigateToLanding();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: _isBusy
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Helper.getColorFromHex(
                                        widget.metadata.primaryColor),
                                  ),
                                )
                              : ColoredButton(
                                  t_login,
                                  navigateToLanding,
                                  color: Helper.getColorFromHex(
                                      widget.metadata.primaryColor),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
