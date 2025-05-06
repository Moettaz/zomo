import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => _ChangeProfileState();
}

class _ChangeProfileState extends State<ChangeProfile> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomUtilisatuerController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  final _registerFormKey = GlobalKey<FormState>();
  bool _isRegisterPasswordVisible = false;
  String? selectedRole;
  bool changingProfile = false;
  int selectedIndex = 0;
  bool didAuthenticate = false;
  bool bioLoading = false;
  bool changePassword = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.showSnackbar(kErrorSnackBar(
          language == 'fr'
              ? 'Erreur lors de la sélection de l\'image'
              : 'Error selecting image',
          color: Colors.red));
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 2.h),
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                language == 'fr' ? 'Choisir une image' : 'Choose an image',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    Icons.camera_alt,
                    language == 'fr' ? 'Appareil photo' : 'Camera',
                    () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildImagePickerOption(
                    Icons.photo_library,
                    language == 'fr' ? 'Galerie' : 'Gallery',
                    () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption(
      IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: kPrimaryColor,
              size: 30.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _emailController.text = 'email@example.com';
    _passwordController.text = '12345678';
    _nomUtilisatuerController.text = 'Nom Prénom';
    _phoneController.text = '12345678';
    selectedRole = 'Client';
    super.initState();
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
                  color: Colors.black.withOpacity(0.5),
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
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Get.back();
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
        Align(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
              child: Form(
                key: _registerFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        language == 'fr' ? 'Nom Prénom' : 'Name Surname',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        language == 'fr'
                            ? 'email@example.com'
                            : 'email@example.com',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Text(
                          language == 'fr'
                              ? 'Gérez les informations de votre profil'
                              : 'Manage your profile information',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: kPrimaryColor,
                          enabled: changingProfile,
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
                            labelText: language == 'fr' ? 'Email' : 'Email',
                            labelStyle: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.sp,
                              vertical: 15.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: TextFormField(
                          controller: _nomUtilisatuerController,
                          cursorColor: kPrimaryColor,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return language == 'fr'
                                  ? 'Nom d\'utilisateur est obligatoire'
                                  : 'Username is required';
                            }
                            if (value.contains(RegExp(r'[0-9]'))) {
                              return language == 'fr'
                                  ? 'Le nom d\'utilisateur ne doit pas contenir de chiffre'
                                  : 'The username must not contain a number';
                            }
                            return null;
                          },
                          enabled: changingProfile,
                          decoration: InputDecoration(
                            labelText: language == 'fr'
                                ? "Nom d'utilisateur"
                                : 'Username',
                            labelStyle: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.sp,
                              vertical: 15.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Password field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: TextFormField(
                          enabled: changingProfile,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          controller: _passwordController,
                          obscureText: _isRegisterPasswordVisible,
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
                            labelText:
                                language == 'fr' ? 'Mot de passe' : 'Password',
                            labelStyle: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
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
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: TextFormField(
                          enabled: changingProfile,
                          controller: _phoneController,
                          cursorColor: kPrimaryColor,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
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
                            labelText: language == 'fr'
                                ? 'Numéro de téléphone'
                                : 'Phone number',
                            labelStyle: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.sp,
                              vertical: 15.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kSecondaryColor),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.sp,
                            vertical: 5.sp,
                          ),
                          child: DropdownButtonFormField<String>(
                            hint: Text(
                              language == 'fr' ? 'Rôle' : 'Role',
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: selectedRole,
                            icon: const Icon(Icons.arrow_drop_down),
                            decoration: InputDecoration(
                              enabled: changingProfile,
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                            items: <String>[
                              language == 'fr' ? 'Client' : 'Client',
                              language == 'fr' ? 'Chauffeur' : 'Driver',
                              language == 'fr'
                                  ? 'Déménageur ou Transporteur'
                                  : 'Demovator or Transporter'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                              if (changingProfile) {
                                setState(() {
                                  selectedRole = newValue!;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: ElevatedButton(
                          onPressed: () {
                            if (changingProfile) {
                              if (_registerFormKey.currentState!.validate()) {
                                Get.showSnackbar(kErrorSnackBar(
                                    language == 'fr'
                                        ? 'Profil modifié avec succès !'
                                        : 'Profile updated successfully !',
                                    color: kPrimaryColor));
                                setState(() {
                                  changingProfile = false;
                                });
                              }
                            } else {
                              setState(() {
                                changingProfile = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            fixedSize: Size(70.w, 6.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            changingProfile
                                ? language == 'fr'
                                    ? 'Enregistrer'
                                    : 'Save'
                                : language == 'fr'
                                    ? 'Modifier le profil'
                                    : 'Edit profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  )
                      .animate()
                      .slideX(duration: 500.ms, begin: 1, end: 0)
                      .animate(),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 30.sp,
                  backgroundColor: Colors.white,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/person.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt,
                          color: Colors.white, size: 19.sp),
                      onPressed: _showImagePickerModal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
