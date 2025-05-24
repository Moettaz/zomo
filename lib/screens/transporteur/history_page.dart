import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/callhistory.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HistorypageTransporteur extends StatefulWidget {
  const HistorypageTransporteur({super.key});

  @override
  State<HistorypageTransporteur> createState() =>
      _HistorypageTransporteurState();
}

class _HistorypageTransporteurState extends State<HistorypageTransporteur> {
  List<Map<String, dynamic>> callHistory = [];
  bool isLoading = true;
  String selectedFilter = 'Tous';
  String searchQuery = '';
  final CallHistoryService _callHistoryService = CallHistoryService();

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
  }

  Future<bool> storeCall(int senderId, int receiverId) async {
    final callHistoryService = CallHistoryService();

// Store a call history
    try {
      final result = await callHistoryService.storeCallHistory(
        senderId: senderId,
        receiverId: receiverId,
        etat: 'received',
        duration: 120, // optional
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> callClient(String phoneNumber, int clientId) async {
    try {
      await storeCall(transporteurData!.id!, clientId);
      final Uri uri = Uri.parse('tel:$phoneNumber');
      await launchUrl(uri);
    } catch (e) {
      // ignore: avoid_print
      print('Error calling client: $e');
    }
  }

  Future<void> _loadCallHistory() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response =
          await _callHistoryService.getCallHistoryById(transporteurData!.id!);

      if (response['call_history'] != null) {
        final List<dynamic> historyData = response['call_history'];
        setState(() {
          callHistory = historyData.map((call) {
            // Determine if the current user is the sender or receiver
            final isSender =
                call['sender']['user']['id'] == transporteurData!.id;
            final otherUser = isSender ? call['receiver'] : call['sender'];

            // Get the name from specific data if available, otherwise use user data
            String name = 'Inconnu';
            if (otherUser['specific_data'] != null) {
              name = otherUser['specific_data']['username'] ??
                  otherUser['user']['name'] ??
                  'Inconnu';
            } else {
              name = otherUser['user']['name'] ?? 'Inconnu';
            }
            String phoneNumber = '12345678';

            if (otherUser['specific_data'] != null) {
              phoneNumber = otherUser['specific_data']['phone'] ??
                  otherUser['user']['phone'] ??
                  '12345678';
            } else {
              phoneNumber = otherUser['user']['phone'] ?? '12345678';
            }
            int clientId = 0;

            if (otherUser['specific_data'] != null) {
              clientId = otherUser['specific_data']['id'] ??
                  otherUser['user']['id'] ??
                  0;
            } else {
              clientId = otherUser['user']['id'] ?? 0;
            }
            // Map backend etat to frontend type
            String type = 'received';
            if (call['etat'] == 'cancelled') {
              type = 'missed';
            } else if (isSender) {
              type = 'passed';
            }

            // Format duration
            String duration = '';
            if (call['duration'] != null) {
              final minutes = (call['duration'] / 60).floor();
              final seconds = call['duration'] % 60;
              duration = '$minutes min $seconds s';
            }

            // Format time
            final DateTime callTime = DateTime.parse(call['created_at']);
            String time;
            if (DateTime.now().difference(callTime).inDays == 0) {
              time = 'Aujourd\'hui ${DateFormat('HH:mm').format(callTime)}';
            } else if (DateTime.now().difference(callTime).inDays == 1) {
              time = 'Hier ${DateFormat('HH:mm').format(callTime)}';
            } else {
              time = DateFormat('d MMMM HH:mm', 'fr_FR').format(callTime);
            }

            return {
              'name': name,
              'type': type,
              'time': time,
              'duration': duration,
              'missed': type == 'missed',
              'initial': name.isNotEmpty ? name[0].toUpperCase() : 'I',
              'phone': phoneNumber,
              'client_id': clientId,
            };
          }).toList();
        });
      }
    } catch (e) {
      // Keep the mock data as fallback
      setState(() {
        callHistory = [
          {
            'name': 'Ahmed B',
            'type': 'received',
            'time': 'Aujourd\'hui 10:15',
            'duration': '1 min 42 s',
            'missed': false,
            'initial': 'A',
          },
          {
            'name': 'Inconnu',
            'type': 'missed',
            'time': 'Hier 18:27',
            'duration': '',
            'missed': true,
            'initial': 'I',
          },
          {
            'name': 'Nadia Client',
            'type': 'passed',
            'time': '15 avril 14:03',
            'duration': '3 min 10 s',
            'missed': false,
            'initial': 'N',
          },
        ];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredCalls {
    List<Map<String, dynamic>> filtered = callHistory;
    if (selectedFilter == 'Passés') {
      filtered = filtered.where((c) => c['type'] == 'passed').toList();
    } else if (selectedFilter == 'Recus') {
      filtered = filtered.where((c) => c['type'] == 'received').toList();
    }
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((c) =>
              c['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
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
                  // ignore: deprecated_member_use
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
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).animate(),
        // Body Section
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        language == 'fr'
                            ? 'Historique des appels'
                            : 'History of calls',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isLoading)
                        SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        )
                      else
                        IconButton(
                          icon: Icon(Icons.refresh, color: kPrimaryColor),
                          onPressed: _loadCallHistory,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                // Filter buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    children: [
                      _buildFilterButton('Tous', kPrimaryColor),
                      SizedBox(width: 2.w),
                      _buildFilterButton('Passés', kPrimaryColor),
                      SizedBox(width: 2.w),
                      _buildFilterButton('Recus', kPrimaryColor),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                // Search box
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: language == 'fr' ? 'Rechercher' : 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        )
                      : filteredCalls.isEmpty
                          ? Center(child: _buildEmptyState())
                          : RefreshIndicator(
                              onRefresh: _loadCallHistory,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                itemCount: filteredCalls.length,
                                itemBuilder: (context, index) {
                                  return historyItem(filteredCalls[index]);
                                },
                              ),
                            ),
                ),
              ],
            ).animate().slideX(duration: 500.ms, begin: -1, end: 0),
          ),
        )
      ],
    ));
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: kSecondaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kSecondaryColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.access_time_rounded,
            size: 45.sp,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          language == 'fr' ? "Aucun historique !" : "No history !",
          style: TextStyle(
            fontFamily: 'Sofia Pro',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          language == 'fr'
              ? "Faire des appels pour les voir ici."
              : "Make calls to see them here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Sofia Pro',
            fontSize: 15.sp,
            height: 1.4,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget historyItem(Map<String, dynamic> call) {
    Color amber = kPrimaryColor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: kSecondaryColor,
              child: Text(
                call['initial'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
            title: Text(
              call['name'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  call['type'] == 'missed'
                      ? (language == 'fr' ? 'Appel manqué' : 'Missed call')
                      : call['type'] == 'received'
                          ? (language == 'fr' ? 'Appel reçu' : 'Received call')
                          : (language == 'fr'
                              ? 'Appel passé'
                              : 'Outgoing call'),
                  style: TextStyle(
                    color:
                        call['type'] == 'missed' ? Colors.red : Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      call['time'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13.5.sp,
                      ),
                    ),
                    if (call['duration'] != null && call['duration'] != '') ...[
                      Text('  •  ', style: TextStyle(color: Colors.grey[500])),
                      Text(
                        call['duration'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13.5.sp,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () async {
                callClient(call['phone'], call['client_id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.sp),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              child: Text(
                language == 'fr' ? 'Rappeler' : 'Recall',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5.sp,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[600],
            height: 1.h,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, Color amber) {
    bool isSelected = selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? amber : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
