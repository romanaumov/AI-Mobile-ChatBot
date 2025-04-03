import 'package:flutter/material.dart';
import '../models/ai_provider.dart';
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function onSettingsSaved;

  const SettingsScreen({Key? key, required this.onSettingsSaved}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _preferencesService = PreferencesService();
  final _apiKeyController = TextEditingController();
  
  List<AIProvider> _providers = [];
  AIProvider? _selectedProvider;
  AIModel? _selectedModel;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProviders();
    _loadSavedSettings();
  }
  
  void _loadProviders() {
    _providers = AIProvider.getProviders();
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _loadSavedSettings() async {
    final apiKey = await _preferencesService.getApiKey();
    final providerName = await _preferencesService.getProvider();
    final modelId = await _preferencesService.getModel();
    
    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }
    
    if (providerName != null && _providers.isNotEmpty) {
      _selectedProvider = _providers.firstWhere(
        (provider) => provider.name == providerName,
        orElse: () => _providers.first,
      );
      
      if (modelId != null && _selectedProvider != null) {
        _selectedModel = _selectedProvider!.models.firstWhere(
          (model) => model.id == modelId,
          orElse: () => _selectedProvider!.models.first,
        );
      } else if (_selectedProvider != null) {
        _selectedModel = _selectedProvider!.models.first;
      }
    } else if (_providers.isNotEmpty) {
      _selectedProvider = _providers.first;
      _selectedModel = _selectedProvider!.models.first;
    }
    
    setState(() {});
  }
  
  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
  
  void _onProviderChanged(AIProvider? provider) {
    setState(() {
      _selectedProvider = provider;
      _selectedModel = provider?.models.first;
    });
  }
  
  void _onModelChanged(AIModel? model) {
    setState(() {
      _selectedModel = model;
    });
  }
  
  Future<void> _saveSettings() async {
    if (_apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key')),
      );
      return;
    }
    
    if (_selectedProvider == null || _selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a provider and model')),
      );
      return;
    }
    
    await _preferencesService.saveApiKey(_apiKeyController.text);
    await _preferencesService.saveProvider(_selectedProvider!.name);
    await _preferencesService.saveModel(_selectedModel!.id);
    
    widget.onSettingsSaved();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Provider dropdown
                  const Text(
                    'Select AI Provider:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<AIProvider>(
                    value: _selectedProvider,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _providers.map((provider) {
                      return DropdownMenuItem<AIProvider>(
                        value: provider,
                        child: Text(provider.name),
                      );
                    }).toList(),
                    onChanged: _onProviderChanged,
                  ),
                  const SizedBox(height: 16),
                  
                  // Model dropdown
                  const Text(
                    'Select Model:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<AIModel>(
                    value: _selectedModel,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _selectedProvider?.models.map((model) {
                      return DropdownMenuItem<AIModel>(
                        value: model,
                        child: Text(model.name),
                      );
                    }).toList() ?? [],
                    onChanged: _onModelChanged,
                  ),
                  const SizedBox(height: 16),
                  
                  // API Key input
                  const Text(
                    'Enter API Key:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your API key',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  
                  // Save button
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Save Settings',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
