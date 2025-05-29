import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanzanian_bms/features/auth/application/auth_controller.dart';
import 'package:tanzanian_bms/screens/auth/registration_screen.dart';
import 'package:tanzanian_bms/screens/dashboard/dashboard_screen.dart'; // Added

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final AuthController authController =
        Get.find(); // Get AuthController instance

    // Listener for auth status changes (navigation, snackbars)
    // Using 'ever' to listen to Rx<AuthStatus>
    // Ensure this is set up only once or managed appropriately if widget rebuilds often
    // For a StatelessWidget, this setup in build is generally okay if it doesn't cause multiple subscriptions.
    // A more robust way for complex scenarios might involve a GetView/GetWidget with its own controller or a StatefulWidget's initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever(authController.authStatus, (AuthStatus status) {
        if (status == AuthStatus.authenticated) {
          Get.off(DashboardScreen());
          Get.snackbar(
            'Login Successful!',
            'Welcome back.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else if (status == AuthStatus.error &&
            authController.errorMessage.isNotEmpty) {
          Get.snackbar(
            'Login Failed',
            authController.errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login - BMS'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to manage your business',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or username';
                      }
                      if (!GetUtils.isEmail(value)) {
                        // Using GetUtils for email validation
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  Obx(() {
                    // Wrap button and loading indicator with Obx
                    return authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final email = emailController.text;
                              final password = passwordController.text;
                              authController.signInWithEmailAndPassword(
                                email,
                                password,
                              );
                            }
                          },
                          child: const Text('Login'),
                        );
                  }),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    // Also disable these buttons when loading
                    return TextButton(
                      onPressed:
                          authController.isLoading.value
                              ? null
                              : () {
                                Get.to(RegistrationScreen());
                              },
                      child: const Text('Don\'t have an account? Register'),
                    );
                  }),
                  Obx(() {
                    // Also disable these buttons when loading
                    return TextButton(
                      onPressed:
                          authController.isLoading.value
                              ? null
                              : () {
                                Get.snackbar(
                                  'Feature Not Implemented',
                                  'Forgot password functionality is not yet available.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                      child: const Text('Forgot Password?'),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
