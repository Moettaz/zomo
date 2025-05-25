import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/transporteurservices.dart';
import '../models/reclamation.dart';
import '../services/reclamationservices.dart';
import '../models/transporteur.dart';

class ReclamationForm extends StatefulWidget {
  final Function(Reclamation) onReclamationCreated;

  const ReclamationForm({
    super.key,
    required this.onReclamationCreated,
  });

  @override
  State<ReclamationForm> createState() => _ReclamationFormState();
}

class _ReclamationFormState extends State<ReclamationForm> {
  final _formKey = GlobalKey<FormState>();
  final _reclamationService = ReclamationService();

  final _sujetController = TextEditingController();
  final _descriptionController = TextEditingController();
  Transporteur? _selectedTransporteur;
  final String _selectedPriorite = 'medium';
  List<Transporteur> _transporteurs = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> services = [
    {
      'id': 1,
      'nom': 'Trajet',
    },
    {
      'id': 2,
      'nom': 'Déménagement',
    },
    {
      'id': 3,
      'nom': 'Colis',
    },
  ];
  int serviceId = 1;
  @override
  void initState() {
    super.initState();
    _loadTransporteurs();
  }

  Future<void> _loadTransporteurs() async {
    try {
      final transporteurs = await TransporteurServices.getAllTransporteurs();
      setState(() {
        _transporteurs = transporteurs;
      });
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: 'Error loading transporteurs: $e',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      ));
    }
  }

  Future<void> _submitReclamation() async {
    if (!_formKey.currentState!.validate() || _selectedTransporteur == null) {
      Get.showSnackbar(GetSnackBar(
        message: 'Please fill all required fields',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      ));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reclamation = Reclamation(
        clientId: clientData!.id!,
        transporteurId: _selectedTransporteur!.id!,
        serviceId: serviceId,
        dateCreation: DateTime.now(),
        sujet: _sujetController.text,
        description: _descriptionController.text,
        status: 'pending',
        priorite: _selectedPriorite,
      );

      final createdReclamation =
          await _reclamationService.createReclamation(reclamation);
      if (createdReclamation) {
        Get.showSnackbar(GetSnackBar(
          message: 'Reclamation created successfully',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          message: 'Error creating reclamation',
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          borderRadius: 10,
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          backgroundColor: Colors.red,
        ));
      }
      Get.back();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: 'Error creating reclamation: $e',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // ignore: deprecated_member_use
                    colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        language == 'fr'
                            ? 'Écrire une réclamation'
                            : 'Write a Reclamation',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Service Selection
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Service',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    prefixIcon: Icon(Icons.category, color: kPrimaryColor),
                  ),
                  value: serviceId,
                  items: services.map((service) {
                    return DropdownMenuItem<int>(
                      value: service['id'],
                      child: Text(service['nom']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => serviceId = value!);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Transporteur Dropdown
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<Transporteur>(
                  decoration: InputDecoration(
                    labelText: 'Select Transporteur',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                  ),
                  value: _selectedTransporteur,
                  items: _transporteurs.map((transporteur) {
                    return DropdownMenuItem(
                      value: transporteur,
                      child: Text(transporteur.username),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedTransporteur = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a transporteur';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Sujet Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: _sujetController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    prefixIcon: Icon(Icons.subject, color: kPrimaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    prefixIcon: Icon(Icons.description, color: kPrimaryColor),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Priority Selection

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReclamation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Reclamation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sujetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
