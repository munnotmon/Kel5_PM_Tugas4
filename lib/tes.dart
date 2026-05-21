import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<dynamic> _data = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/Tes/'));

      if (response.statusCode == 200) {
        setState(() {
          final decodedResponse = json.decode(response.body);

          if (decodedResponse is List) {
            _data = decodedResponse;
          } else if (decodedResponse is Map) {
            final listValue = decodedResponse.values.firstWhere(
              (v) => v is List,
              orElse: () => null,
            );
            _data = listValue != null
                ? List.from(listValue)
                : [decodedResponse];
          } else {
            _data = [decodedResponse];
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data. Status: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Localhost')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_data.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        final item = _data[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.data_object)),
            title: Text(
              item is Map && item.containsKey('name')
                  ? item['name'].toString()
                  : item is Map && item.containsKey('title')
                  ? item['title'].toString()
                  : item.toString(),
            ),
            subtitle: Text(
              item is Map && item.containsKey('description')
                  ? item['description'].toString()
                  : item is Map && item.containsKey('body')
                  ? item['body'].toString()
                  : '',
            ),
          ),
        );
      },
    );
  }
}
