import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../styles/colors.dart';
import 'navigator_item.dart';
import '../login_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final _supabase = Supabase.instance.client;
  late Stream<AuthState> _authStateStream;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _authStateStream = _supabase.auth.onAuthStateChange;
    _getCurrentUser();
    _setupAuthListener();
  }

  void _getCurrentUser() {
    final user = _supabase.auth.currentUser;
    setState(() {
      _currentUser = user;
    });

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }

  void _setupAuthListener() {
    _authStateStream.listen((AuthState data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        _getCurrentUser();
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() {
          _currentUser = null;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else if (event == AuthChangeEvent.userUpdated) {
        _getCurrentUser();
      }
    });
  }

  Future<void> _logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (error) {
      print('Error during logout: $error');
      _showErrorDialog('Failed to logout. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (currentIndex == 0) {
      final shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    } else {
      setState(() {
        currentIndex = 0;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
              SizedBox(height: 20),
              Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: navigatorItems[currentIndex].screenBuilder(),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 37,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryColor,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedItemColor: AppColors.darkGrey,
          items: navigatorItems.map((e) {
            return _buildNavigationBarItem(
              label: e.label,
              index: e.index,
              iconPath: e.iconPath,
            );
          }).toList(),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem({
    required String label,
    required String iconPath,
    required int index,
  }) {
    final isSelected = index == currentIndex;
    final iconColor = isSelected ? AppColors.primaryColor : AppColors.darkGrey;

    return BottomNavigationBarItem(
      label: label,
      icon: Container(
        padding: EdgeInsets.all(8),
        child: SvgPicture.asset(
          iconPath,
          color: iconColor,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  // الطرق المحدثة لـ Supabase (بدون execute)
  Future<Map<String, dynamic>?> _getUserProfile() async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .single();

      return response;
    } catch (error) {
      print('Error fetching profile: $error');
      return null;
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', _currentUser!.id);
    } catch (error) {
      print('Error updating user profile: $error');
      rethrow;
    }
  }
}