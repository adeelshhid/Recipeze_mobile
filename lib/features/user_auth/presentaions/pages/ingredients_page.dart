import 'package:flutter/material.dart';
import 'package:firebase_login/core/api/kitchen_controller.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final KitchenController _kitchenController = KitchenController();
  List<Map<String, dynamic>> ingredients = [];
  final Map<int, bool> selectedIngredients = {};
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAvailableIngredients(currentPage);
  }

  Future<void> _fetchAvailableIngredients(int page) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _kitchenController.getAvailableIngredients(page: page);
      if (data != null && data.isNotEmpty) {
        setState(() {
          ingredients = data;
          for (var ingredient in data) {
            final id = ingredient['id'] as int;
            selectedIngredients[id] = false;  // Assuming initially not selected
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No ingredients found for page: $page')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load available ingredients: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleIngredient(int id) async {
    try {
      await _kitchenController.toggleIngredient(id);
      setState(() {
        selectedIngredients[id] = !(selectedIngredients[id] ?? false);
        if (!selectedIngredients[id]!) {
          ingredients.removeWhere((ingredient) => ingredient['id'] == id);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(selectedIngredients[id]! ? 'Added to kitchen' : 'Removed from kitchen')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle ingredient: $e')),
      );
    }
  }

  void _nextPage() {
    if (!isLoading) {
      currentPage++;
      _fetchAvailableIngredients(currentPage);
    }
  }

  void _previousPage() {
    if (!isLoading && currentPage > 1) {
      currentPage--;
      _fetchAvailableIngredients(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00b473),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ingredients",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cooking Essentials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ingredients.isEmpty
                    ? const Center(child: Text("No ingredients found."))
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: ingredients.map((ingredient) {
                          final id = ingredient['id'] as int;
                          final isSelected = selectedIngredients[id] ?? false;
                          return ChoiceChip(
                            label: Text(ingredient['name']),
                            selected: isSelected,
                            onSelected: (selected) {
                              _toggleIngredient(id);
                            },
                            selectedColor: Colors.green,
                            backgroundColor: Colors.white,
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: const Text('Next'),
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