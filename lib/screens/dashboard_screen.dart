import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/local_database.dart';
import '../model/user.dart';
import '../utility/AppColors.dart';
import '../utility/Utility.dart';
import 'login_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final LocalDatabase _localDatabase = LocalDatabase();
  List<UserData> userList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  @override
  void initState() {
    if(Utility.getUser()?.role == "admin"){
      getUserList();
    }
    super.initState();
  }

  void getUserList() async {
    await _localDatabase.initializeDatabase();
    userList = await _localDatabase.getUsers();
    userList = userList.where((element) => element.role != "admin").toList();
    print("----->");
    print(userList.length);
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getUserList();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.greenColor,
          leading: Container(),
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LogInScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Icon(Icons.exit_to_app, color: AppColors.white),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Text("Name")),
                  Expanded(child: Text(Utility.getUser()?.name ?? "")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(child: Text("Email")),
                  Expanded(child: Text(Utility.getUser()?.email ?? "")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(child: Text("Role")),
                  Expanded(child: Text(Utility.getUser()?.role ?? "")),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (userList.isNotEmpty)
                Text("User Detail's",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greenColor)),
              if (userList.isNotEmpty)
                const SizedBox(
                  height: 10,
                ),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(blurRadius: 1, offset: Offset(0, 1))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userList[index].name ?? "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.greenColor)),
                              Text(userList[index].email ?? ""),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: userList.length))
            ],
          ),
        ),
      ),
    );
  }

  _notify() {
    if (mounted) {
      setState(() {});
    }
  }
}
