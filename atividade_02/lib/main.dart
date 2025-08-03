import 'package:flutter/material.dart';

// Inicia a aplicação Flutter
void main() {
  runApp(const MyApp());
}

// Widget principal da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RegistrationForm(), // A tela principal será o nosso formulário
    );
  }
}

// Widget que representa o formulário
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // Chave global para identificar e validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para obter os valores dos campos
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  // Variável para armazenar o sexo selecionado
  String? _selectedGender;
  // Variável para armazenar a data de nascimento
  DateTime? _selectedDate;

  // Função para exibir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formata a data para exibição no formato dd/MM/yyyy
        _dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Função para validar se a pessoa tem mais de 18 anos
  String? _validateAge(String? value) {
    if (_selectedDate == null) {
      return 'Por favor, selecione a data de nascimento.';
    }

    final today = DateTime.now();
    int age = today.year - _selectedDate!.year;
    if (today.month < _selectedDate!.month ||
        (today.month == _selectedDate!.month && today.day < _selectedDate!.day)) {
      age--;
    }

    if (age < 18) {
      return 'Você deve ter 18 anos ou mais para se cadastrar.';
    }
    return null;
  }

  // Função para lidar com o envio do formulário
  void _submitForm() {
    // Acessa o estado do formulário através da chave e o valida
    if (_formKey.currentState!.validate()) {
      // Se o formulário for válido, exibe um dialog de sucesso
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cadastro Realizado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${_nameController.text}'),
              Text('Data de Nascimento: ${_dobController.text}'),
              Text('Sexo: $_selectedGender'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('FECHAR'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget é descartado
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Cadastro'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo Nome Completo
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira seu nome completo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Data de Nascimento
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Impede a digitação manual
                onTap: () => _selectDate(context),
                validator: _validateAge, // Aplica a validação de idade
              ),
              const SizedBox(height: 20),

              // Campo Sexo
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: ['Homem', 'Mulher']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione seu sexo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botão de Enviar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'CADASTRAR',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}