import 'package:flutter/material.dart';
import 'package:start/features/Auth/View/Widgets/DarkModelLogo.dart';
import 'package:start/features/Auth/View/Widgets/GlassCard.dart';
import 'package:start/features/Auth/View/Widgets/LightModelLogo.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isDarkMode = false;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isDarkMode
                    ? [
                        const Color(0xFF0A0E21),
                        const Color(0xFF1D2671),
                        const Color(0xFF5C469C),
                      ]
                    : [
                        Colors.white,
                        Colors.grey[50]!,
                        Colors.grey[100]!,
                      ],
              ),
            ),
          ),

          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: _isDarkMode
                        ? const DarkModelLogo(key: ValueKey('dark'))
                        : const LightModelLogo(key: ValueKey('light')),
                  ),
                  const SizedBox(height: 40),

                  // Glass card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 320),
                    child: GlassCard(
                      darkMode: _isDarkMode,
                      child: Padding(
                        padding: isSmallScreen
                            ? const EdgeInsets.all(20)
                            : const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Gallery Manager',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                    
                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email,
                                      color: Theme.of(context).iconTheme.color),
                                  labelText: 'Email',
                                  hintText: 'manager@company.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                    
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock,
                                      color: Theme.of(context).iconTheme.color),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
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
                              const SizedBox(height: 24),
                    
                              // Login Button
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 300),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Login logic
                                      Navigator.pushReplacementNamed(context, HomePage.routeName);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isDarkMode
                                        ? const Color(0xFF5C469C)
                                        : Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                    elevation: 4,
                                    shadowColor: _isDarkMode
                                        ? const Color(0xFF5C469C).withOpacity(0.5)
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Dark mode toggle
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isDarkMode
                        ? _buildDarkModeToggle(context)
                        : _buildLightModeToggle(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5C469C).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.light_mode, color: Colors.grey),
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeColor: const Color(0xFF5C469C),
            inactiveThumbColor: Colors.grey,
          ),
          const Icon(Icons.dark_mode, color: Color(0xFF5C469C)),
        ],
      ),
    );
  }

  Widget _buildLightModeToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.light_mode, color: Colors.amber),
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeTrackColor: Colors.black12,
            inactiveThumbColor: Colors.black,
          ),
          const Icon(Icons.dark_mode, color: Colors.grey),
        ],
      ),
    );
  }
}