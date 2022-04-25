import 'package:flutter/material.dart';
import 'package:research_alert/core/services/auth_service.dart';
import 'package:research_alert/drawer/contacts.dart';
import 'package:research_alert/drawer/notifications.dart';
import 'package:research_alert/ui/screens/bookmarks_home_screen.dart';
import 'package:research_alert/ui/screens/home_screen.dart';
import 'package:research_alert/ui/screens/login_signup/login.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color.fromARGB(255, 34, 53, 51),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 130,
                    // margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage('images/AppLogo.png'),
                        )),
                  ),
                  Text(
                    "Research Alert",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    "Info@research.com",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.dashboard_outlined),
              title: Text(
                'Dashboard',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.people_alt_outlined),
            title: Text(
              'Contacts',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_outline_sharp),
            title: Text(
              'Bookmarks',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarksHomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text(
              'Notifications',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notificationss()),
              );
            },
          ),
          Divider(),
          // VerticalDivider(
          //   color: Colors.black,
          //   thickness: 10,
          //   width: 10,
          //   indent: 70,
          //   endIndent: 70,
          // ),
          ListTile(
            leading: Icon(Icons.logout_sharp),
            title: Text(
              'LogOut',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Do you want to Logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            _authService.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  });
              // const Icon(Icons.logout);
            },
          ),
        ],
      ),
    );
  }
}
