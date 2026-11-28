import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import 'package:servixo/features/setup/presentation/cubits/permissions_cubit.dart';
import 'package:servixo/features/setup/presentation/screens/profile_photo_screen.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});
  static const String id = 'permissions';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PermissionsCubit>()..refresh(),
      child: const _PermissionsView(),
    );
  }
}

class _PermissionsView extends StatefulWidget {
  const _PermissionsView();
  @override
  State<_PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<_PermissionsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // User may come back from system settings after enabling a permission.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionsCubit>().refresh();
    }
  }

  Future<void> _handle(Future<PermissionStatus> request) async {
    final status = await request;
    if (status.isPermanentlyDenied) await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cubit = context.read<PermissionsCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: BlocBuilder<PermissionsCubit, PermissionsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text('Almost there',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'Allow a couple of permissions so Servixo can find professionals near you and keep you updated.',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      color: colors.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _PermissionTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    subtitle: 'Find services and providers close to you.',
                    granted: state.location,
                    busy: state.busy,
                    onAllow: () => _handle(cubit.requestLocation()),
                  ),
                  const SizedBox(height: 14),
                  _PermissionTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Get updates about your requests and bookings.',
                    granted: state.notifications,
                    busy: state.busy,
                    onAllow: () => _handle(cubit.requestNotifications()),
                  ),
                  const Spacer(),
                  Center(
                    child: Text(
                      'You can change these later in your phone settings.',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 13,
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AuthButton(
                    text: 'Continue',
                    backgroundColor: colors.primary,
                    textColor: colors.surface,
                    onTap: () =>
                        Navigator.pushNamed(context, ProfilePhotoScreen.id),
                  ),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.busy,
    required this.onAllow,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final bool busy;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: colors.onSurface,
                    )),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 13,
                      color: colors.onSurface.withValues(alpha: 0.7),
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (granted)
            const Icon(Icons.check_circle, color: Colors.green, size: 28)
          else
            TextButton(
              onPressed: busy ? null : onAllow,
              child: const Text('Allow'),
            ),
        ],
      ),
    );
  }
}