import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servixo/core/const/app_const.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/features/auth/presentation/widgets/auth_button.dart';
import 'package:servixo/features/setup/presentation/cubits/profile_photo_cubit.dart';

import '../../../home/presentation/home_screen.dart';

class ProfilePhotoScreen extends StatelessWidget {
  const ProfilePhotoScreen({super.key});
  static const String id = 'profile_photo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfilePhotoCubit>(),
      child: const _ProfilePhotoView(),
    );
  }
}

class _ProfilePhotoView extends StatelessWidget {
  const _ProfilePhotoView();

  void _pickSource(BuildContext context) {
    final cubit = context.read<ProfilePhotoCubit>();
    showModalBottomSheet(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(sheetCtx);
                cubit.pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(sheetCtx);
                cubit.pick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<ProfilePhotoCubit, ProfilePhotoState>(
      listener: (context, state) {
        if (state.completed) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.id, (_) => false);
        } else if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfilePhotoCubit>();
        final hasPhoto = state.bytes != null;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: colors.onSurface),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Add a profile photo',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'A clear photo helps providers and customers trust each other.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      color: colors.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: state.busy ? null : () => _pickSource(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: colors.primary.withValues(alpha: 0.1),
                          backgroundImage:
                              hasPhoto ? MemoryImage(state.bytes!) : null,
                          child: hasPhoto
                              ? null
                              : Icon(Icons.person_outline,
                                  size: 80, color: colors.primary),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 4,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: colors.primary,
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  AuthButton(
                    text: hasPhoto ? 'Finish' : 'Choose a photo',
                    isLoading: state.busy,
                    backgroundColor: colors.primary,
                    textColor: colors.surface,
                    onTap: hasPhoto
                        ? cubit.finish
                        : () => _pickSource(context),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed:
                        state.busy ? null : () => cubit.finish(skipPhoto: true),
                    child: Text('Skip for now',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 16,
                          color: colors.onSurface,
                        )),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}