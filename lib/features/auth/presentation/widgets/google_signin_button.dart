import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/const/app_const.dart';
import '../cubit/google_auth_cubit.dart';

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<GoogleAuthCubit, GoogleAuthState>(
      builder: (context, state) {
        final isLoading = state is GoogleAuthLoading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () => context.read<GoogleAuthCubit>().signInWithGoogle(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.3),
                  blurRadius: 3,
                  offset: Offset(-3, 6),
                ),
              ],
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Follow via Google account',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 12),
                      Image.asset(
                        googleIcon,
                        height: 25,
                        width: 25,
                        color: colors.primary,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
