import 'package:flutter/material.dart';
import 'package:metube/features/post/presentation/pages/manage_post_page.dart';

import '../../../home/home_page.dart';
import '../../../profile/profile_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const [
    HomePage(),
    ManagePostPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}


// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   @override
//   Widget build(BuildContext context) {
//     final authBloc = context.read<AuthBloc>();
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 10,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             BlocBuilder<AppUserCubit, AppUserState>(builder: (context, state) {
//               if (state is AppUserLoggedIn) {
//                 return Text(
//                   state.user.name,
//                   style: const TextStyle(color: Colors.yellow),
//                 );
//               } else {
//                 return const Text(
//                   "data",
//                   style: TextStyle(color: Colors.red),
//                 );
//               }
//             }),
//             Text(
//               "Logged In",
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
//               if (state is AuthLoading) {
//                 return const CupertinoActivityIndicator(
//                   color: Colors.white,
//                 );
//               }
//               return ElevatedButton(
//                   onPressed: () async {
//                     authBloc.add(AuthLogout());
//                     // final Map<int, String> map = {};
//                     // final a ={
//                     //   1: "1",
//                     // }.entries;
//                     // map.addEntries(a);
//                   },
//                   child: const Text("Logout"));
//             }, listener: (context, state) {
//               log(state.toString());
//               if (state is AuthInitial) {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => const Splash()),
//                   (route) => false,
//                 );
//               }
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
