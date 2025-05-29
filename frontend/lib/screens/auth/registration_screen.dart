import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanzanian_bms/features/auth/application/auth_controller.dart';
import 'package:tanzanian_bms/features/auth/domain/employment_details_model.dart';
import 'package:tanzanian_bms/features/auth/domain/billing_info_model.dart';
import 'package:tanzanian_bms/screens/auth/login_screen.dart';
import 'package:tanzanian_bms/screens/dashboard/dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late AuthController authController;

  // User Info Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneNumberController;

  // Employment Info Controllers
  late TextEditingController _companyNameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _departmentController;
  late TextEditingController _employeeIdController;

  // Billing Info Controllers
  late TextEditingController _billingAddressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  late TextEditingController _preferredPaymentMethodController;
  late TextEditingController _paymentMethodDetailsController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();

    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneNumberController = TextEditingController();

    _companyNameController = TextEditingController();
    _jobTitleController = TextEditingController();
    _departmentController = TextEditingController();
    _employeeIdController = TextEditingController();

    _billingAddressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _countryController = TextEditingController();
    _preferredPaymentMethodController = TextEditingController();
    _paymentMethodDetailsController = TextEditingController();

    ever(authController.authStatus, (AuthStatus status) {
      if (!mounted) return;
      if (status == AuthStatus.authenticated) {
        Get.offAll(DashboardScreen());
        Get.snackbar(
          'Registration Successful!',
          'Welcome! You are now logged in.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (status == AuthStatus.error &&
          authController.errorMessage.isNotEmpty) {
        Get.snackbar(
          'Registration Failed',
          authController.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();

    _companyNameController.dispose();
    _jobTitleController.dispose();
    _departmentController.dispose();
    _employeeIdController.dispose();

    _billingAddressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _preferredPaymentMethodController.dispose();
    _paymentMethodDetailsController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    bool isFormValid = _formKey.currentState!.validate();

    if (isFormValid) {
      final isLastStep = _currentStep == _getSteps(context).length - 1;
      if (isLastStep) {
        _attemptRegistration();
      } else {
        setState(() {
          _currentStep += 1;
        });
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        Get.off(LoginScreen());
      }
    }
  }

  void _attemptRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final employmentDetails = EmploymentDetails(
      companyName:
          _companyNameController.text.trim().isEmpty
              ? null
              : _companyNameController.text.trim(),
      jobTitle:
          _jobTitleController.text.trim().isEmpty
              ? null
              : _jobTitleController.text.trim(),
      department:
          _departmentController.text.trim().isEmpty
              ? null
              : _departmentController.text.trim(),
      employeeId:
          _employeeIdController.text.trim().isEmpty
              ? null
              : _employeeIdController.text.trim(),
    );

    final billingInfo = BillingInfo(
      billingAddress:
          _billingAddressController.text.trim().isEmpty
              ? null
              : _billingAddressController.text.trim(),
      city:
          _cityController.text.trim().isEmpty
              ? null
              : _cityController.text.trim(),
      postalCode:
          _postalCodeController.text.trim().isEmpty
              ? null
              : _postalCodeController.text.trim(),
      country:
          _countryController.text.trim().isEmpty
              ? null
              : _countryController.text.trim(),
      preferredPaymentMethod:
          _preferredPaymentMethodController.text.trim().isEmpty
              ? null
              : _preferredPaymentMethodController.text.trim(),
      paymentMethodDetails:
          _paymentMethodDetailsController.text.trim().isEmpty
              ? null
              : _paymentMethodDetailsController.text.trim(),
    );

    authController.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      phoneNumber:
          _phoneNumberController.text.trim().isEmpty
              ? null
              : _phoneNumberController.text.trim(),
      employmentDetails: employmentDetails,
      billingInfo: billingInfo,
    );
  }

  List<Step> _getSteps(BuildContext context) {
    return [
      Step(
        title: const Text('User Info'),
        content: _buildUserInfoForm(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Employment Info'),
        content: _buildEmploymentInfoForm(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Billing Info (Optional)'),
        content: _buildBillingInfoForm(),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (authController.isLoading.value) return;
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            } else {
              if (Get.previousRoute.isNotEmpty) {
                Get.back();
              } else {
                Get.off(LoginScreen());
              }
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Obx(() {
          return Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue:
                authController.isLoading.value ? null : _onStepContinue,
            onStepCancel: authController.isLoading.value ? null : _onStepCancel,
            steps: _getSteps(context),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              final isLastStep = _currentStep == _getSteps(context).length - 1;
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: <Widget>[
                    if (authController.isLoading.value && isLastStep)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(isLastStep ? 'REGISTER' : 'CONTINUE'),
                      ),
                    if (!authController.isLoading.value || !isLastStep)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('BACK'),
                      ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildUserInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(labelText: 'Full Name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a username';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!GetUtils.isEmail(value.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _phoneNumberController,
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildEmploymentInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Company Name (Optional)',
          ),
        ),
        TextFormField(
          controller: _jobTitleController,
          decoration: const InputDecoration(labelText: 'Job Title (Optional)'),
        ),
        TextFormField(
          controller: _departmentController,
          decoration: const InputDecoration(labelText: 'Department (Optional)'),
        ),
        TextFormField(
          controller: _employeeIdController,
          decoration: const InputDecoration(
            labelText: 'Employee ID (Optional)',
          ),
        ),
      ],
    );
  }

  Widget _buildBillingInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _billingAddressController,
          decoration: const InputDecoration(
            labelText: 'Billing Address (Optional)',
          ),
        ),
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(labelText: 'City (Optional)'),
        ),
        TextFormField(
          controller: _postalCodeController,
          decoration: const InputDecoration(
            labelText: 'Postal Code (Optional)',
          ),
        ),
        TextFormField(
          controller: _countryController,
          decoration: const InputDecoration(labelText: 'Country (Optional)'),
        ),
        TextFormField(
          controller: _preferredPaymentMethodController,
          decoration: const InputDecoration(
            labelText: 'Preferred Payment Method (Optional)',
          ),
        ),
        TextFormField(
          controller: _paymentMethodDetailsController,
          decoration: const InputDecoration(
            labelText: 'Payment Method Details (Optional)',
          ),
        ),
      ],
    );
  }
}
