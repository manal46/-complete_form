import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لإضافة SystemChrome

void main() {
  // إعداد النظام قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complete Form Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,

      ),
      home: const CompleteForm(),
    );
  }
}

class CompleteForm extends StatefulWidget {
  const CompleteForm({super.key});

  @override
  State<CompleteForm> createState() => _CompleteFormState();
}

class _CompleteFormState extends State<CompleteForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedGender;
  String? _selectedCountry;
  double _satisfactionRating = 3.0;
  double _progressLevel = 50.0;
  RangeValues _budgetRange = const RangeValues(20, 80);
  bool _subscribeToNewsletter = false;
  bool _agreeToTerms = false;

  final List<String> _countries = ['United States', 'Canada', 'UK'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete Form Example',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information
              _buildSectionHeader('Personal Information'),
              _buildTextField('Full Name *', 'Enter your name', _fullNameController, true),
              _buildTextField('Email *', 'Enter your email', _emailController, true),
              _buildTextField('Password *', 'Enter password', _passwordController, true, true),
              _buildTextField('Phone', 'Enter phone', _phoneController, false),
              _buildTextField('Age', 'Enter age', _ageController, false),

              const SizedBox(height: 20),
              _buildSectionHeader('Demographics'),
              _buildSimpleDropdown('Gender', _genders, _selectedGender, (value) {
                setState(() => _selectedGender = value);
              }),
              _buildSimpleDropdown('Country', _countries, _selectedCountry, (value) {
                setState(() => _selectedCountry = value);
              }),

              const SizedBox(height: 20),
              _buildSectionHeader('Ratings & Preferences'),
              _buildSlider('Satisfaction: ${_satisfactionRating.toStringAsFixed(1)}',
                  _satisfactionRating, 1, 5, (value) {
                    setState(() => _satisfactionRating = value);
                  }),
              _buildSlider('Progress: ${_progressLevel.toInt()}%',
                  _progressLevel, 0, 100, (value) {
                    setState(() => _progressLevel = value);
                  }),

              const SizedBox(height: 10),
              const Text(
                'Budget Range:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Text(
                '\$${_budgetRange.start.toInt()} - \$${_budgetRange.end.toInt()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              RangeSlider(
                values: _budgetRange,
                min: 0,
                max: 100,
                onChanged: (values) => setState(() => _budgetRange = values),
              ),

              const SizedBox(height: 20),
              _buildSectionHeader('Preferences'),
              _buildCheckbox('Subscribe to Newsletter', 'Receive updates', _subscribeToNewsletter, (value) {
                setState(() => _subscribeToNewsletter = value!);
              }),
              _buildCheckbox('I agree to Terms', 'You must agree', _agreeToTerms, (value) {
                setState(() => _agreeToTerms = value!);
              }),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Submit Form',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text(
                        'Reset Form',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, bool required, [bool isPassword = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Text('Select $label', style: const TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, String subtitle, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_agreeToTerms) {
      print('=== FORM DATA ===');
      print('Name: ${_fullNameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      print('Phone: ${_phoneController.text}');
      print('Age: ${_ageController.text}');
      print('Gender: $_selectedGender');
      print('Country: $_selectedCountry');
      print('Rating: $_satisfactionRating');
      print('Progress: $_progressLevel%');
      print('Budget: \$${_budgetRange.start.toInt()}-\$${_budgetRange.end.toInt()}');
      print('Newsletter: $_subscribeToNewsletter');
      print('Terms: $_agreeToTerms');
      print('==============');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form submitted! Check terminal.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _ageController.clear();
    setState(() {
      _selectedGender = null;
      _selectedCountry = null;
      _satisfactionRating = 3.0;
      _progressLevel = 50.0;
      _budgetRange = const RangeValues(20, 80);
      _subscribeToNewsletter = false;
      _agreeToTerms = false;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}