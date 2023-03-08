import 'package:daejeon_fe/screen/post_add_screen.dart';
import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 230,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.post_add_outlined,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "글 작성",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostAddScreen(),
              ),
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "마이페이지",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "로그아웃",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              await ApiService().logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
          ),
        ],
      ),
    );
  }
}
