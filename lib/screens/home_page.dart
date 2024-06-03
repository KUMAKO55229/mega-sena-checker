import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numbersController = TextEditingController();
  final List<int> _userNumbers = [];
  List<List<int>> _megaSenaResults = [];
  List<List<int>> _matchingResults = [];
  List<List<dynamic>> _excelData = [];
  bool _verified = false;
  bool _isTableVisible = false;
  @override
  void initState() {
    super.initState();
    _loadMegaSenaResults();
  }

  Future<void> _loadMegaSenaResults() async {
    try {
      final String response =
          await rootBundle.loadString('assets/mega_sena_results.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        _megaSenaResults = data.map((e) => List<int>.from(e)).toList();
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  void _addNumber(int number) {
    if (_userNumbers.length < 15 && !_userNumbers.contains(number)) {
      setState(() {
        _userNumbers.add(number);
      });
    }
  }

  void _removeNumber(int number) {
    setState(() {
      _userNumbers.remove(number);
    });
  }

  void _checkNumbers() {
    if (_userNumbers.length >= 6 && _userNumbers.length <= 15) {
      List<int> userNumbers = List.from(_userNumbers)..sort();
      setState(() {
        _matchingResults = _megaSenaResults
            .where((result) =>
                userNumbers.where((number) => result.contains(number)).length >=
                4)
            .toList();
        _verified = true;
      });
    }
  }

  void _reset() {
    setState(() {
      _userNumbers.clear();
      _matchingResults.clear();
      _verified = false;
    });
  }

  Widget _buildNumberButton(int number) {
    final isSelected = _userNumbers.contains(number);
    return GestureDetector(
      onTap: () {
        isSelected ? _removeNumber(number) : _addNumber(number);
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleTableVisibility() {
    setState(() {
      _isTableVisible = !_isTableVisible;
    });
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Concurso',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Números',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        for (int i = 0; i < _megaSenaResults.length; i++)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Concurso ${i + 1}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_megaSenaResults[i].join(', ')),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mega-Sena Checker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _toggleTableVisibility,
                child:
                    Text(_isTableVisible ? 'Ocultar Tabela' : 'Mostrar Tabela'),
              ),
              if (_isTableVisible)
                SizedBox(
                  height: MediaQuery.sizeOf(context).height *
                      0.8, // Defina uma altura fixa
                  child: SingleChildScrollView(
                    child: _buildTable(),
                  ),
                ),
              SizedBox(height: 10),
              if (!_isTableVisible)
                Column(
                  children: [
                    const Text(
                      'Escolha de 6 a 15 números',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(
                          60, (index) => _buildNumberButton(index + 1)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _userNumbers.length >= 6 &&
                                  _userNumbers.length <= 15
                              ? _checkNumbers
                              : null,
                          child: Text('Verificar'),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: _reset,
                          child: const Text('Resetar'),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: _matchingResults.length == 0 && _verified
                          ? Text('Nenhum acerto')
                          : ListView.builder(
                              itemCount: _matchingResults.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      'Resultado: ${_matchingResults[index].join(', ')}'),
                                );
                              },
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
}
