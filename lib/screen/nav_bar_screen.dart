import 'package:daejeon_fe/service/api_service.dart';
import 'package:flutter/material.dart';

class NavMenu extends StatefulWidget {
  const NavMenu({super.key});

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  late var isLogin = false;

  @override
  void initState() {
    ApiService().isLogin().then(
          (value) => setState(() => isLogin = value),
        );
    super.initState();
  }

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
              'INAB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          if (isLogin)
            ListTile(
              title: Row(
                children: const [
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
              onTap: () {
                Navigator.pushNamed(context, "/my-page");
              },
            ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.search,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "다른 학교 가기",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
          if (isLogin)
            ListTile(
              title: Row(
                children: const [
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
          if (!isLogin)
            ListTile(
              title: Row(
                children: const [
                  Icon(
                    Icons.login,
                    size: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            ),
        ],
      ),
    );
  }
}
