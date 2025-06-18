// presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/configs/assets/app_images.dart';
import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';
import 'package:flutter_with_firebase/features/product/presentation/pages/FavoritesScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/theme_cubit.dart';
import '../../../core/constants.dart';
import '../../../main.dart';
import '../../../services/auth.dart';
import '../../auth/presentation/pages/login_screen.dart';
import '../../settings/pages/my_orders.dart';
import '../data/repos/profile_repository_impl.dart';
import '../data/sources/profile_remote_data_source.dart';
import '../domain/usecases/get_user_profile.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'widgets/list_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ProfileCubit(
            GetUserProfile(
              ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
            ),
          )..loadUser(),
      child: Scaffold(
        backgroundColor: isDark(context) ? Colors.black : Color(0xFFF7F9FC),
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                // ✅ On bascule entre Anglais et Arabe
                Locale newLocale =
                    Localizations.localeOf(context).languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en');
                MyApp.setLocale(context, newLocale);
              },
            ),

            IconButton(
              icon: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return Icon(
                    themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  );
                },
              ),
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark(context) ? Colors.black : Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          // backgroundImage: user.avatarUrl != null
                          //     ? NetworkImage(user.avatarUrl!)
                          //     :
                          backgroundImage:
                              AssetImage(AppImages.profile) as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.firstName + " " + user.lastName,
                          style: const TextStyle(fontSize: 22),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Edit profile
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFF0F4FF),
                            foregroundColor: Color(0xFF6484FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Shopping ",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: isDark(context) ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        children: [
                          MyListTile(
                            title: "My Orders",
                            icon: Icons.shopping_bag_outlined,
                            onTap: () {
                              AppNavigator.push(context, const MyOrdersPage());
                            },
                          ),

                          // SizedBox(height: 10),
                          MyListTile(
                            title: "My Favorites",
                            icon: Icons.favorite_border,
                            onTap: () {
                              AppNavigator.push(
                                context,
                                const MyFavoritesPage(),
                              );
                            },
                          ),
                          MyListTile(
                            title: "My Addresses",
                            icon: Icons.location_on_outlined,
                            onTap: () {
                              // Naviguer vers la page des adresses
                            },
                          ),
                          MyListTile(
                            title: "My informations",
                            icon: Icons.info_outline,
                            onTap: () {
                              // Naviguer vers la page des informations
                            },
                          ),
                          MyListTile(
                            title: "Help Center & Support",
                            icon: Icons.help_outline,
                            onTap: () {
                              // Naviguer vers la page d'aide
                            },
                          ),
                          MyListTile(
                            title: "Logout",
                            icon: Icons.logout,
                            onTap: () {
                              // Logique de déconnexion
                              _auth.signOut();
                              SharedPreferences.getInstance().then((pref) {
                                // pref.clear();
                                AppNavigator.pushAndRemove(
                                  context,
                                  SigninPage(),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
