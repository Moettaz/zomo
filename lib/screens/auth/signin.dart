import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/authserices.dart';
import 'package:zomo/models/user.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomUtilisatuerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final List<FocusNode> _codeFocusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final _resetPasswordEmailFormKey = GlobalKey<FormState>();
  final _verifyCodeFormKey = GlobalKey<FormState>();
  bool _isLoginPasswordVisible = false;
  bool _isRegisterPasswordVisible = false;
  bool _isResetPasswordEmailVisible = false;
  bool _isResetPasswordPasswordVisible = false;
  String? selectedRole;
  bool _rememberMe = false;
  bool _acceptTerms = false;
  int selectedIndex = 0;
  bool didAuthenticate = false;
  bool bioLoading = false;
  bool changePassword = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool _isLoggingIn = false;

  Future<bool> _checkBiometric(context) async {
    setState(() {
      bioLoading = true;
    });
    try {
      bool permis = await auth.isDeviceSupported();
      if (permis) {
        await auth.getAvailableBiometrics();
        didAuthenticate = await auth.authenticate(
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            biometricOnly: false,
            stickyAuth: true,
            sensitiveTransaction: false,
          ),
          localizedReason: language == 'fr'
              ? 'Veuillez vous authentifier pour connectez'
              : 'Please authenticate to connect',
        );
        if (didAuthenticate) {
          setState(() {
            bioLoading = false;
          });
          Get.off(() => const NavigationScreen(
                index: 0,
              ));
        }
      } else {
        setState(() {
          bioLoading = false;
        });
        Get.showSnackbar(kErrorSnackBar(language == 'fr'
            ? "Votre appareil ne support pas les biometriques"
            : "Your device does not support biometrics"));
      }
    } on PlatformException catch (e) {
      setState(() {
        bioLoading = false;
      });
      // ignore: avoid_print
      print(e);
      Get.showSnackbar(kErrorSnackBar(
          language == 'fr' ? "Une erreur est survenue" : "An error occurred"));
    }
    setState(() {
      bioLoading = false;
    });
    return didAuthenticate;
  }

  // Login function
  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    final result = await AuthServices.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isLoggingIn = false;
    });

    if (result['success']) {
      final userData = result['data'];
      final user = User.fromJson(userData['user']);

      if (user.role?.slug == 'client') {
        Get.off(() => const NavigationScreen(index: 0));
      } else {
        Get.off(() => const NavigationScreenTransporteur(index: 0));
      }
    } else {
      Get.showSnackbar(kErrorSnackBar(language == 'fr'
          ? "Échec de la connexion : ${result['message']}"
          : "Login failed: ${result['message']}"));
    }
  }

  // Register function
  Future<void> _register() async {
    try {
      if (!_registerFormKey.currentState!.validate()) {
        return;
      }

      if (!_acceptTerms) {
        Get.showSnackbar(kErrorSnackBar(language == 'fr'
            ? "Veuillez accepter les termes et conditions"
            : "Please accept the terms and conditions"));
        return;
      }

      setState(() {
        _isLoggingIn = true;
      });

      int roleId;
      switch (selectedRole) {
        case 'Client':
          roleId = 2;
          break;
        case 'Transporteur':
          roleId = 3;
          break;
        case 'Chauffeur':
          roleId = 4;
          break;
        default:
          roleId = 2;
      }

      final result = await AuthServices.register(
        name: _nomUtilisatuerController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        roleId: roleId,
        phone: _phoneController.text,
      );

      setState(() {
        _isLoggingIn = false;
      });

      if (result['success']) {
        Get.showSnackbar(kSuccessSnackBar(language == 'fr'
            ? "Inscription réussie ! Vous pouvez maintenant vous connecter."
            : "Registration successful! You can now log in."));

        setState(() {
          selectedIndex = 0;
          _emailController.clear();
          _passwordController.clear();
        });
      } else {
        Get.showSnackbar(kErrorSnackBar(language == 'fr'
            ? "Échec de l'inscription : ${result['message']}"
            : "Registration failed: ${result['message']}"));
      }
    } catch (e) {
      setState(() {
        _isLoggingIn = false;
      });
      Get.showSnackbar(kErrorSnackBar(language == 'fr'
          ? "Une erreur inattendue s'est produite"
          : "An unexpected error occurred"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Header Image
          SizedBox(
            width: 100.w,
            height: 20.h,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Header Image
                Container(
                  width: double.infinity,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    image: DecorationImage(
                      image: AssetImage('assets/headerImage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/miniLogo.png',
                    width: 50.w,
                    height: 8.h,
                  ),
                ),
                // Back Button
                selectedIndex == 0
                    ? Container()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            if (selectedIndex == 0) {
                              return;
                            } else if (selectedIndex == 1) {
                              setState(() {
                                selectedIndex = 0;
                                changePassword = false;
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            } else if (selectedIndex == 3 ||
                                selectedIndex == 6) {
                              setState(() {
                                selectedIndex = 0;
                                changePassword = false;
                              });
                            } else {
                              setState(() {
                                selectedIndex = selectedIndex - 1;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).animate(),
          // Login Section
          !changePassword
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 100.w,
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.sp),
                        topRight: Radius.circular(25.sp),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5.h),
                          // Top buttons
                          Container(
                            width: 90.w,
                            height: 7.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedIndex = 0;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(100.w, 7.h),
                                        elevation: 0,
                                        backgroundColor: selectedIndex == 0
                                            ? Colors.white
                                            : kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Text(
                                        language == 'fr'
                                            ? 'Se connecter'
                                            : 'Login',
                                        style: TextStyle(
                                            color: selectedIndex == 0
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedIndex = 1;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: selectedIndex == 1
                                            ? Colors.white
                                            : kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Text(
                                        language == 'fr'
                                            ? 'Créer un compte'
                                            : 'Create an account',
                                        style: TextStyle(
                                          color: selectedIndex == 1
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          // Email field
                          selectedIndex == 0
                              ? Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.sp),
                                        child: TextFormField(
                                          controller: _emailController,
                                          cursorColor: kPrimaryColor,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return language == 'fr'
                                                  ? 'Email est obligatoire'
                                                  : 'Email is required';
                                            }
                                            if (!RegExp(
                                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                                .hasMatch(value)) {
                                              return language == 'fr'
                                                  ? 'Email invalide'
                                                  : 'Invalid email';
                                            }
                                            return null;
                                          },
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: language == 'fr'
                                                ? 'Email'
                                                : 'Email',
                                            hintStyle: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize: 15.sp,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 20.sp,
                                              vertical: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      // Password field
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.sp),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          textInputAction: TextInputAction.done,
                                          cursorColor: kPrimaryColor,
                                          controller: _passwordController,
                                          obscureText: _isLoginPasswordVisible,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return language == 'fr'
                                                  ? 'Mot de passe est obligatoire'
                                                  : 'Password is required';
                                            }
                                            if (value.length < 8) {
                                              return language == 'fr'
                                                  ? 'Mot de passe doit contenir au moins 8 caractères'
                                                  : 'Password must contain at least 8 characters';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: language == 'fr'
                                                ? 'Mot de passe'
                                                : 'Password',
                                            hintStyle: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize: 15.sp,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              borderSide: BorderSide(
                                                  color: kSecondaryColor),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 20.sp,
                                              vertical: 15.sp,
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isLoginPasswordVisible =
                                                      !_isLoginPasswordVisible;
                                                });
                                              },
                                              icon: _isLoginPasswordVisible
                                                  ? const Icon(
                                                      Icons.visibility_off)
                                                  : const Icon(
                                                      Icons.visibility),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      // Remember me and Forgot password
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Checkbox(
                                                  activeColor: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.sp),
                                                  ),
                                                  side: BorderSide(
                                                      color: kPrimaryColor),
                                                  value: _rememberMe,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _rememberMe =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                Text(language == 'fr'
                                                    ? 'Souviens-moi'
                                                    : 'Remember me'),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  changePassword = true;
                                                  selectedIndex = 3;
                                                });
                                              },
                                              child: Text(
                                                language == 'fr'
                                                    ? 'Mot de passe oublié ?'
                                                    : 'Forgot password?',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      // Login Button
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.sp),
                                        child: ElevatedButton(
                                          onPressed:
                                              _isLoggingIn ? null : _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            fixedSize: Size(70.w, 6.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: _isLoggingIn
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : Text(
                                                  language == 'fr'
                                                      ? 'Se connecter'
                                                      : 'Login',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: [
                                          SizedBox(width: 5.w),
                                          Expanded(
                                              child: Divider(
                                                  color: kSecondaryColor)),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Se connecter avec'
                                                  : 'Login with',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Divider(
                                                  color: kSecondaryColor)),
                                          SizedBox(width: 5.w),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                    ],
                                  ).animate().slideX(
                                      duration: 500.ms, begin: -1, end: 0),
                                )
                              // Register Section
                              : Form(
                                  key: _registerFormKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: TextFormField(
                                            controller: _emailController,
                                            cursorColor: kPrimaryColor,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Email est obligatoire'
                                                    : 'Email is required';
                                              }
                                              if (!RegExp(
                                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                                  .hasMatch(value)) {
                                                return language == 'fr'
                                                    ? 'Email invalide'
                                                    : 'Invalid email';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? 'Email'
                                                  : 'Email',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: TextFormField(
                                            controller:
                                                _nomUtilisatuerController,
                                            cursorColor: kPrimaryColor,
                                            keyboardType: TextInputType.name,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Nom d\'utilisateur est obligatoire'
                                                    : 'Username is required';
                                              }
                                              if (value
                                                  .contains(RegExp(r'[0-9]'))) {
                                                return language == 'fr'
                                                    ? 'Le nom d\'utilisateur ne doit pas contenir de chiffre'
                                                    : 'The username must not contain a number';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? "Nom d'utilisateur"
                                                  : 'Username',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        // Password field
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: kPrimaryColor,
                                            controller: _passwordController,
                                            obscureText:
                                                _isRegisterPasswordVisible,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Mot de passe est obligatoire'
                                                    : 'Password is required';
                                              }
                                              if (value.length < 8) {
                                                return language == 'fr'
                                                    ? 'Mot de passe doit contenir au moins 8 caractères'
                                                    : 'Password must contain at least 8 characters';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? 'Mot de passe'
                                                  : 'Password',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isRegisterPasswordVisible =
                                                        !_isRegisterPasswordVisible;
                                                  });
                                                },
                                                icon: _isRegisterPasswordVisible
                                                    ? const Icon(
                                                        Icons.visibility_off)
                                                    : const Icon(
                                                        Icons.visibility),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: TextFormField(
                                            controller: _phoneController,
                                            cursorColor: kPrimaryColor,
                                            keyboardType: TextInputType.phone,
                                            textInputAction:
                                                TextInputAction.next,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  8),
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Numéro de téléphone est obligatoire'
                                                    : 'Phone number is required';
                                              }
                                              if (value.length != 8) {
                                                return language == 'fr'
                                                    ? 'Numéro de téléphone doit contenir 8 chiffres'
                                                    : 'Phone number must contain 8 digits';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? 'Numéro de téléphone'
                                                  : 'Phone number',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kSecondaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.sp,
                                              vertical: 5.sp,
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              hint: Text(
                                                language == 'fr'
                                                    ? 'Rôle'
                                                    : 'Role',
                                                style: TextStyle(
                                                  color: kSecondaryColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              value: selectedRole,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                              ),
                                              items: <String>[
                                                language == 'fr'
                                                    ? 'Client'
                                                    : 'Client',
                                                language == 'fr'
                                                    ? 'Chauffeur'
                                                    : 'Driver',
                                                language == 'fr'
                                                    ? 'Déménageur ou Transporteur'
                                                    : 'Demovator or Transporter'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      color: value == 'Rôle'
                                                          ? kSecondaryColor
                                                          : Colors.black,
                                                      fontSize: 15.sp,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == 'Rôle') {
                                                  return language == 'fr'
                                                      ? 'Veuillez sélectionner un rôle'
                                                      : 'Please select a role';
                                                }
                                                return null;
                                              },
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedRole = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        // Remember me and Forgot password
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                activeColor: kPrimaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.sp),
                                                ),
                                                side: BorderSide(
                                                    color: kPrimaryColor),
                                                value: _acceptTerms,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _acceptTerms =
                                                        value ?? false;
                                                  });
                                                },
                                              ),
                                              Text(
                                                language == 'fr'
                                                    ? "J'accepte les termes et conditions"
                                                    : "I accept the terms and conditions",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.blue[900],
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationThickness: 1,
                                                  decorationColor:
                                                      Colors.blue[900],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: ElevatedButton(
                                            onPressed:
                                                _isLoggingIn ? null : _register,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kPrimaryColor,
                                              fixedSize: Size(70.w, 6.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                            child: _isLoggingIn
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white)
                                                : Text(
                                                    language == 'fr'
                                                        ? 'Créer un compte'
                                                        : 'Create an account',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 5.w),
                                            Expanded(
                                                child: Divider(
                                                    color: kSecondaryColor)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              child: Text(
                                                language == 'fr'
                                                    ? 'Créer un compte avec'
                                                    : 'Create an account with',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Divider(
                                                    color: kSecondaryColor)),
                                            SizedBox(width: 5.w),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    )
                                        .animate()
                                        .slideX(
                                            duration: 500.ms, begin: 1, end: 0)
                                        .animate(),
                                  ),
                                ),
                          // Social buttons
                          Column(
                            children: [
                              SizedBox(
                                  width: 90.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  WidgetStateProperty.all(
                                                      2.sp)),
                                          onPressed: () async {
                                            // await signInWithGoogle();
                                          },
                                          icon: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/google.png', // Path to the Google logo image
                                                width: 15.w,
                                              ),
                                              // isGoogleSignIn
                                              // ? SizedBox(
                                              //     width: 15.w,
                                              //     height: 15.w,
                                              //     child: CircularProgressIndicator(
                                              //       color: secandaryColor,
                                              //       backgroundColor: Colors.red,
                                              //     ))
                                              // : SizedBox()
                                            ],
                                          )),
                                      IconButton(
                                          style: ButtonStyle(
                                              elevation:
                                                  WidgetStateProperty.all(
                                                      2.sp)),
                                          onPressed: () async {
                                            // await signInWithFacebook();
                                          },
                                          icon: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/facebook.png', // Path to the Google logo image
                                                height: 15.w,
                                              ),
                                              // isFbSignIn
                                              // ? SizedBox(
                                              //     width: 15.w,
                                              //     height: 15.w,
                                              //     child: CircularProgressIndicator(
                                              //       color: secandaryColor,
                                              //       backgroundColor: Colors.blue[800],
                                              //     ))
                                              // : SizedBox()
                                            ],
                                          )),
                                    ],
                                  )),
                              selectedIndex == 0 && transporteurData != null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 0.h),
                                      child: InkWell(
                                          onTap: () {
                                            if (bioLoading) return;
                                            _checkBiometric(context);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.fingerprint,
                                                size: 30.sp,
                                                color: kPrimaryColor,
                                              ),
                                              bioLoading
                                                  ? SizedBox(
                                                      width: 15.w,
                                                      height: 15.w,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kPrimaryColor,
                                                      ))
                                                  : SizedBox()
                                            ],
                                          )),
                                    )
                                  : SizedBox(),
                            ],
                          )
                              .animate()
                              .slideY(duration: 500.ms, begin: 1, end: 0)
                              .animate(),
                        ],
                      ),
                    ),
                  ),
                )
              // Reset Password Section
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 100.w,
                    height: 85.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.sp),
                        topRight: Radius.circular(25.sp),
                      ),
                    ),
                    child: selectedIndex == 3
                        ? Column(
                            children: [
                              SizedBox(height: 5.h),
                              // Top buttons
                              SizedBox(
                                width: 65.w,
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              SizedBox(
                                width: 65.w,
                                child: Text(
                                  'Ne vous inquiétez pas ! Veuillez saisir l\'adresse email associée à votre compte',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.sp),
                                  child: Text(
                                    'Adresse email / Téléphone',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Form(
                                key: _resetPasswordEmailFormKey,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: TextFormField(
                                    controller: _emailController,
                                    cursorColor: kPrimaryColor,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return language == 'fr'
                                            ? 'Email est obligatoire'
                                            : 'Email is required';
                                      }
                                      if (!RegExp(
                                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                          .hasMatch(value)) {
                                        return language == 'fr'
                                            ? 'Email invalide'
                                            : 'Invalid email';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          language == 'fr' ? 'Email' : 'Email',
                                      hintStyle: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 15.sp,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide:
                                            BorderSide(color: kSecondaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide:
                                            BorderSide(color: kSecondaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide:
                                            BorderSide(color: kSecondaryColor),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.sp,
                                        vertical: 15.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              // Password field

                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 15.sp),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_resetPasswordEmailFormKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        selectedIndex = 4;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    backgroundColor: kPrimaryColor,
                                    fixedSize: Size(70.w, 6.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    language == 'fr' ? 'Envoyer' : 'Send',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    language == "fr"
                                        ? "Se souvenir du mot de passe ?"
                                        : "Remember your password?",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 0;
                                        changePassword = false;
                                      });
                                    },
                                    child: Text(
                                      language == 'fr'
                                          ? 'Se connecter'
                                          : 'Login',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                            ],
                          )
                            .animate()
                            .slideX(duration: 500.ms, begin: -1, end: 0)
                        // Verify Code Section
                        : selectedIndex == 4
                            ? Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  // Top buttons
                                  SizedBox(
                                    width: 65.w,
                                    child: Text(
                                      language == 'fr'
                                          ? 'Veuillez vérifier votre email'
                                          : 'Please check your email',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  SizedBox(
                                    width: 65.w,
                                    child: Text(
                                      language == 'fr'
                                          ? 'Nous avons envoyé un code à\n${_emailController.text}'
                                          : 'We have sent a code to\n${_emailController.text}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),

                                  Form(
                                    key: _verifyCodeFormKey,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 32.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(4, (index) {
                                          return SizedBox(
                                            width: 15.w,
                                            child: TextFormField(
                                              controller:
                                                  _codeControllers[index],
                                              focusNode: _codeFocusNodes[index],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: kPrimaryColor,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return '*';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                if (value.length == 1) {
                                                  if (index < 3) {
                                                    _codeFocusNodes[index + 1]
                                                        .requestFocus();
                                                  }
                                                  _codeController.text =
                                                      _codeControllers
                                                          .map((controller) =>
                                                              controller.text)
                                                          .join();
                                                } else if (value.isEmpty &&
                                                    index > 0) {
                                                  _codeFocusNodes[index - 1]
                                                      .requestFocus();
                                                }
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                      color: kSecondaryColor),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                      color: kSecondaryColor),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: BorderSide(
                                                      color: kSecondaryColor),
                                                ),
                                                errorStyle:
                                                    TextStyle(height: 0),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  // Password field

                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.sp),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_verifyCodeFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            selectedIndex = 5;
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 4,
                                        backgroundColor: kPrimaryColor,
                                        fixedSize: Size(70.w, 6.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Text(
                                        language == 'fr'
                                            ? 'Vérifier'
                                            : 'Verify',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        language == 'fr'
                                            ? "Envoyer à nouveau le code "
                                            : "Send the code again ",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        language == 'fr' ? '00:20' : '00:20',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                ],
                              )
                                .animate()
                                .slideX(duration: 500.ms, begin: -1, end: 0)
                            : selectedIndex == 5
                                ? Form(
                                    key: _resetPasswordFormKey,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5.h),
                                        // Top buttons
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.sp),
                                            child: SizedBox(
                                              width: 65.w,
                                              child: Text(
                                                language == 'fr'
                                                    ? 'Réinitialiser le mot de passe'
                                                    : 'Reset password',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 5.h),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.sp),
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Nouveau mot de passe'
                                                  : 'New password',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.sp),
                                          child: TextFormField(
                                            controller: _newPasswordController,
                                            cursorColor: kPrimaryColor,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText:
                                                _isResetPasswordEmailVisible,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Mot de passe est obligatoire'
                                                    : 'Password is required';
                                              }
                                              if (value.length < 8) {
                                                return language == 'fr'
                                                    ? 'Mot de passe doit contenir au moins 8 caractères'
                                                    : 'Password must contain at least 8 characters';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? 'Doit contenir 8 caractères'
                                                  : 'Must contain 8 characters',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isResetPasswordEmailVisible =
                                                        !_isResetPasswordEmailVisible;
                                                  });
                                                },
                                                icon:
                                                    _isResetPasswordEmailVisible
                                                        ? const Icon(Icons
                                                            .visibility_off)
                                                        : const Icon(
                                                            Icons.visibility),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.sp),
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Confirmer le mot de passe'
                                                  : 'Confirm password',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.sp),
                                          child: TextFormField(
                                            controller:
                                                _confirmPasswordController,
                                            cursorColor: kPrimaryColor,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
                                            obscureText:
                                                _isResetPasswordPasswordVisible,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Mot de passe est obligatoire'
                                                    : 'Password is required';
                                              }
                                              if (value !=
                                                  _newPasswordController.text) {
                                                return language == 'fr'
                                                    ? 'Mot de passe ne correspond pas'
                                                    : 'Password does not match';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: language == 'fr'
                                                  ? 'Répéter votre mot de passe'
                                                  : 'Repeat your password',
                                              hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 15.sp,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: BorderSide(
                                                    color: kSecondaryColor),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                                vertical: 15.sp,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isResetPasswordPasswordVisible =
                                                        !_isResetPasswordPasswordVisible;
                                                  });
                                                },
                                                icon:
                                                    _isResetPasswordPasswordVisible
                                                        ? const Icon(Icons
                                                            .visibility_off)
                                                        : const Icon(
                                                            Icons.visibility),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        // Password field

                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.sp),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_resetPasswordFormKey
                                                  .currentState!
                                                  .validate()) {
                                                setState(() {
                                                  selectedIndex = 6;
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 4,
                                              backgroundColor: kPrimaryColor,
                                              fixedSize: Size(70.w, 6.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Réinitialiser'
                                                  : 'Reset',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              language == 'fr'
                                                  ? "Se souvenir du mot de passe ?"
                                                  : "Remember your password?",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedIndex = 0;
                                                  changePassword = false;
                                                });
                                              },
                                              child: Text(
                                                language == 'fr'
                                                    ? 'Se connecter'
                                                    : 'Login',
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                      ],
                                    ).animate().slideX(
                                        duration: 500.ms, begin: -1, end: 0),
                                  )
                                : selectedIndex == 6
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: kPrimaryColor,
                                            size: 50.sp,
                                          ),
                                          SizedBox(height: 5.h),

                                          SizedBox(
                                            width: 65.w,
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Mot de passe modifié'
                                                  : 'Password modified',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          SizedBox(
                                            width: 65.w,
                                            child: Text(
                                              language == 'fr'
                                                  ? 'Votre mot de passe a été modifié avec succès'
                                                  : 'Your password has been modified successfully',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          // Password field

                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.sp),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectedIndex = 0;
                                                  changePassword = false;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 4,
                                                backgroundColor: kPrimaryColor,
                                                fixedSize: Size(70.w, 6.h),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                              ),
                                              child: Text(
                                                language == 'fr'
                                                    ? 'Se connecter'
                                                    : 'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                    // Social buttons
                  ),
                ).animate().slideY(duration: 500.ms, begin: 1, end: 0).animate()
        ],
      ),
    );
  }
}
