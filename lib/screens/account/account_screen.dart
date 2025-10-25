import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common_widgets/app_text.dart';
import '../../helpers/column_with_seprator.dart';
import '../../styles/colors.dart';
import 'account_item.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                // معلومات المستخدم
                _buildUserInfo(), // ⬅️ تم التعديل هنا
                // قائمة الخيارات
                _buildAccountItems(),
                SizedBox(height: 20),
                // زر تسجيل الخروج
                _buildLogoutButton(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final user = Supabase.instance.client.auth.currentUser;
    // ⬅️ مسار الصورة الجديدة
    final String profileImagePath = 'assets/images/account_image.jpg';

    return ListTile(
      leading: SizedBox(
        width: 65,
        height: 65,
        child: CircleAvatar(
          radius: 32.5,
          backgroundColor: AppColors.primaryColor.withOpacity(0.2),
          // ⬅️ استخدام الصورة الشخصية
          backgroundImage: AssetImage(profileImagePath),
          // تم إزالة الأيقونة الافتراضية <Icon(...)> لأننا نستخدم صورة
        ),
      ),
      title: Row( // ⬅️ تم تغيير العنوان إلى Row لاستيعاب أيقونة التعديل (القلم)
        children: [
          AppText(
            // افتراض اسم مستخدم من البيانات الوصفية أو جزء من الإيميل
            text: (user?.userMetadata?['full_name'] as String?) ?? user?.email?.split('@').first ?? "User",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 8),
          Icon(
            Icons.edit, // ⬅️ أيقونة القلم (Edit)
            size: 16,
            color: AppColors.primaryColor, // أو لون داكن
          ),
        ],
      ),
      subtitle: AppText(
        text: user?.email ?? "No email",
        color: AppColors.darkGrey,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    );
  }

  Widget _buildAccountItems() {
    return Column(
      children: getChildrenWithSeperator(
        widgets: accountItems.map((e) {
          return _buildAccountItemWidget(e);
        }).toList(),
        seperator: Divider(thickness: 1),
      ),
    );
  }

  Widget _buildAccountItemWidget(AccountItem accountItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              accountItem.iconPath,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: 20),
          Text(
            accountItem.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.darkGrey,
          )
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 0,
          backgroundColor: Color(0xffF2F3F2),
          foregroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          minimumSize: const Size.fromHeight(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                "assets/icons/account_icons/logout_icon.svg",
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              "Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            Container(width: 20), // للمساواة في المساحة
          ],
        ),
        onPressed: () {
          _showLogoutConfirmation(context);
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Log Out",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: TextStyle(
            color: AppColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الـ dialog
              _performLogout(context);
            },
            child: Text(
              "Log Out",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      // عرض مؤشر تحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      );

      // تنفيذ تسجيل الخروج
      await Supabase.instance.client.auth.signOut();

      // إغلاق مؤشر التحمل والانتقال لشاشة Login
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

    } catch (error) {
      // إغلاق مؤشر التحمل في حالة الخطأ
      Navigator.pop(context);

      // عرض رسالة خطأ
      _showErrorDialog(context, "Failed to logout. Please try again.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}