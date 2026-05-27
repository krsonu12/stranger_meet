import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Home page — shown after successful authentication.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StrangerMeet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutRequested()),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _HomeContent(user: state.user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final dynamic user;

  const _HomeContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl as String)
                  : null,
              child: user.photoUrl == null
                  ? const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.isAnonymous ? 'Guest User' : (user.displayName ?? 'Welcome'),
              style: AppTextStyles.heading2,
            ),
            if (!user.isAnonymous && user.email != null) ...[
              const SizedBox(height: 4),
              Text(user.email as String, style: AppTextStyles.body2),
            ],
            if (user.isAnonymous) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Anonymous Session',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 48),
            Text(
              'You\'re in! Start meeting strangers.',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
