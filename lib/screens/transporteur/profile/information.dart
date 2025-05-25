import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'dart:io';
import 'package:zomo/services/authserices.dart';

class InformationPersonal extends StatefulWidget {
  final bool changingProfile;
  const InformationPersonal({super.key, this.changingProfile = false});

  @override
  State<InformationPersonal> createState() => _InformationPersonalState();
}

class _InformationPersonalState extends State<InformationPersonal> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomUtilisatuerController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool isLoading = false;
  Transporteur? transporteurData;

  final _registerFormKey = GlobalKey<FormState>();
  String? selectedRole;
  bool changingProfile = false;
  int selectedIndex = 0;
  bool didAuthenticate = false;
  bool bioLoading = false;
  bool changePassword = false;

  // --- Add state for document files and service type selection ---
  final List<File?> _documentFiles = [null, null, null];
  int _selectedServiceType = 0;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          changingProfile = true;
        });
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: language == 'fr'
            ? 'Erreur lors de la sélection de l\'image'
            : 'Error selecting image',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
      ));
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
              color: kPrimaryColor.withValues(alpha: 0.1),
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
    super.initState();
    changingProfile = widget.changingProfile;
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final response = await AuthServices.getCurrentUser();
      if (response != null) {
        setState(() {
          if (response['specific_data'] != null) {
            if (response['specific_data'] is Transporteur) {
              transporteurData = response['specific_data'];
            } else {
              transporteurData =
                  Transporteur.fromJson(response['specific_data']);
            }

            // Set initial values
            _emailController.text = transporteurData?.email ?? '';
            _nomUtilisatuerController.text = transporteurData?.username ?? '';
            _phoneController.text = transporteurData?.phone ?? '';
          }
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data = {
        'email': _emailController.text,
        'username': _nomUtilisatuerController.text,
        'phone': _phoneController.text,
      };

      if (_passwordController.text.isNotEmpty) {
        data['password'] = _passwordController.text;
      }

      final response = await AuthServices.updateClient(
        transporteurData?.id ?? 0,
        data,
        imageFile: _image,
      );

      if (response != null && response['success'] == true) {
        Get.showSnackbar(GetSnackBar(
          title: language == 'fr'
              ? 'Profil modifié avec succès !'
              : 'Profile updated successfully!',
          backgroundColor: kPrimaryColor,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
        ));
        setState(() {
          changingProfile = false;
        });

        // Refresh user data
        await getUserData();
        Get.offAll(() => NavigationScreen(index: 3));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: language == 'fr'
              ? 'Erreur lors de la modification du profil'
              : 'Error updating profile',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
        ));
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: language == 'fr'
            ? 'Erreur lors de la modification du profil'
            : 'Error updating profile',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickDocumentFile(int index) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _documentFiles[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: language == 'fr'
            ? 'Erreur lors de la sélection du fichier'
            : 'Error selecting file',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
      ));
    }
  }

  Widget _buildDocumentRow(String title, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      trailing: Icon(
        Icons.check_circle,
        color: kPrimaryColor,
      ),
      onTap: () => _pickDocumentFile(index),
    );
  }

  Widget _buildServiceTypeRow(String title, int index) {
    bool isSelected = _selectedServiceType == index;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 15.sp)),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.cancel,
        color: isSelected ? kPrimaryColor : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _selectedServiceType = index;
        });
      },
    );
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
                        language == 'fr'
                            ? 'Informations personnelles'
                            : 'Personal information',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // --- Start new design for Documents and Types de service ---
                      Card(
                        margin: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.grey[200],
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.directions_bus_sharp),
                                  SizedBox(width: 10),
                                  Text(
                                    "${transporteurData?.vehiculeType ?? ''} - 12 m2",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                language == 'fr' ? 'Documents' : 'Documents',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 8),
                              Divider(
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              _buildDocumentRow('Permis de conduire', 0),
                              _buildDocumentRow('Carte grise', 1),
                              _buildDocumentRow('Assurance', 2),
                              SizedBox(height: 16),
                              Divider(
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                language == 'fr'
                                    ? 'Types de service'
                                    : 'Service types',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 8),
                              _buildServiceTypeRow('Course', 0),
                              _buildServiceTypeRow('Déménagement', 1),
                              _buildServiceTypeRow('Livraison', 2),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (changingProfile) {
                                    updateProfile();
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
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  changingProfile
                                      ? language == 'fr'
                                          ? 'Contacter Zomo'
                                          : 'Contact Zomo'
                                      : language == 'fr'
                                          ? 'Contacter Zomo'
                                          : 'Contact Zomo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                        ),
                      ),
                      // --- End new design ---
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
                      : transporteurData?.imageUrl != null
                          ? NetworkImage(
                              "${AuthServices.baseUrl}/${transporteurData!.imageUrl!}")
                          : AssetImage('assets/person.png') as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) =>
                      AssetImage('assets/person.png') as ImageProvider,
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
