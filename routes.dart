import 'package:flutter/material.dart';

// 📱 Auth Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

// 🏠 Home & Profile Screens
import 'screens/home/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/task/edit_profile_screen.dart';
import 'screens/task/change_password_screen.dart';

// ✅ Task Screens
import 'screens/task/create_task_screen.dart';
import 'screens/task/task_list_screen.dart';
import 'screens/task/task_detail_screen.dart';
import 'screens/add_task_screen.dart';

// 📄 Info & Hilfe
import 'screens/task/privacy_policy_screen.dart';
import 'screens/task/faq_screen.dart';
import 'screens/task/feedback_screen.dart';
import 'screens/task/support_screen.dart';

/// ✅ App-Routen-Map (alle benannten Routen)
final Map<String, WidgetBuilder> appRoutes = {
  // Auth
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
  '/forgot-password': (_) => const ForgotPasswordScreen(),

  // Home & Profile
  '/home': (_) => const HomeScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/edit-profile': (_) => const EditProfileScreen(),
  '/change-password': (_) => const ChangePasswordScreen(),

  // Tasks
  '/create': (_) => const CreateTaskScreen(),
  '/task-list': (_) => const TaskListScreen(),
  '/task-detail': (_) => const TaskDetailScreen(),
  '/add-task': (_) => const AddTaskScreen(),

  // Hilfe & Rechtliches
  '/privacy-policy': (_) => const PrivacyPolicyScreen(),
  '/faq': (_) => const FAQScreen(),
  '/feedback': (_) => const FeedbackScreen(),
  '/support': (_) => const SupportScreen(),
};
