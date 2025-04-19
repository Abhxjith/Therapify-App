import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapify/main/navbar.dart';
import 'package:therapify/services/onboarding_form_service.dart';
import 'package:therapify/models/onboarding_form_data.dart';
import 'package:therapify/services/cbt_questions_service.dart';
import 'package:therapify/models/cbt_question.dart';
import 'package:therapify/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingFormScreen extends StatefulWidget {
  @override
  _OnboardingFormScreenState createState() => _OnboardingFormScreenState();
}

class _OnboardingFormScreenState extends State<OnboardingFormScreen> {
  final PageController _pageController = PageController();
  final OnboardingFormService _formService = OnboardingFormService();
  final List<CBTQuestion> _questions = CBTQuestionsService.getQuestions();
  OnboardingFormData _formData = OnboardingFormData(
    name: '',
    email: '',
    cbtResponses: {},
  );

  int _currentPage = 0;
  final int _totalPages = 6; // 1 for name/email + 5 CBT questions

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formData = OnboardingFormData(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      cbtResponses: _formData.cbtResponses,
    );

    await _formService.saveFormData(formData);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    
    // Show welcome screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          userName: _nameController.text,
          onComplete: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Navbar()),
            );
          },
        ),
      ),
    );
  }

  void _updateFormData(String field, dynamic value) {
    setState(() {
      if (field == 'name') {
        _formData = OnboardingFormData(
          name: value,
          email: _formData.email,
          cbtResponses: _formData.cbtResponses,
        );
      } else if (field == 'email') {
        _formData = OnboardingFormData(
          name: _formData.name,
          email: value,
          cbtResponses: _formData.cbtResponses,
        );
      } else {
        _formData.cbtResponses[field] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: FaIcon(FontAwesomeIcons.arrowLeft, color: appTheme.primaryColor),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPersonalInfoPage(),
                  ..._questions.map((question) => _buildQuestionPage(question)).toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentPage == _totalPages - 1 ? 'Complete' : 'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please provide your basic information to get started.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: FaIcon(
                  _obscurePassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  size: 16,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: FaIcon(
                  _obscureConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  size: 16,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(CBTQuestion question) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 32),
          if (question.isMultiSelect)
            ...question.options.map((option) => _buildCheckboxOption(question.id, option))
          else
            ...question.options.map((option) => _buildRadioOption(question.id, option)),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String questionId, String option) {
    final currentResponses = _formData.cbtResponses[questionId] as List<String>? ?? [];
    final isSelected = currentResponses.contains(option);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              final responses = List<String>.from(currentResponses);
              if (isSelected) {
                responses.remove(option);
              } else {
                responses.add(option);
                if (_currentPage < _totalPages - 1) {
                  _nextPage();
                }
              }
              _updateFormData(questionId, responses);
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? appTheme.primaryColor : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? appTheme.primaryColor.withOpacity(0.1) : Colors.white,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      final responses = List<String>.from(currentResponses);
                      if (value!) {
                        responses.add(option);
                      } else {
                        responses.remove(option);
                      }
                      _updateFormData(questionId, responses);
                    });
                  },
                  activeColor: appTheme.primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String questionId, String option) {
    final currentResponse = _formData.cbtResponses[questionId] as String?;
    final isSelected = currentResponse == option;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _updateFormData(questionId, option);
            if (_currentPage < _totalPages - 1) {
              _nextPage();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? appTheme.primaryColor : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? appTheme.primaryColor.withOpacity(0.1) : Colors.white,
            ),
            child: Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: currentResponse,
                  onChanged: (value) {
                    _updateFormData(questionId, value!);
                  },
                  activeColor: appTheme.primaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class WelcomeScreen extends StatelessWidget {
  final String userName;
  final VoidCallback onComplete;

  const WelcomeScreen({
    Key? key,
    required this.userName,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                '/Users/abhijithjinnu/androidtherapify/assets/meditation.svg',
                height: 200,
              ),
              SizedBox(height: 32),
              Text(
                'Welcome to Therapify, $userName!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'We\'re excited to have you on board. Your journey to better mental health starts now.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A9D8F),
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 