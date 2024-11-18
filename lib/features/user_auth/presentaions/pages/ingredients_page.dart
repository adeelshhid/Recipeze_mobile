import 'package:flutter/material.dart';


class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> ingredients = [
    "Rice (Any)",
    "Pasta (Any)",
    "Chicken (Any)",
    "Olive Oil",
    "Vegetable Oil",
    "Eggs",
    "Tomato Paste",
    "Tomato Sauce",
    "Cooking Cream",
    "Flour",
    "Baking Powder",
    "Butter",
    "Salt",
    "Sugar",
    "Balsamic Vinegar",
    "Vanilla Extract",
  ];

  // Map to keep track of selected ingredients
  final Map<String, bool> selectedIngredients = {};

  @override
  void initState() {
    super.initState();
    for (var ingredient in ingredients) {
      selectedIngredients[ingredient] = false;
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
            Navigator.pop(context); // Navigate back to Kitchen Page
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
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Ingredients',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Cooking Essentials Section
              const Text(
                "Cooking Essentials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Ingredients List as Selectable Chips
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ingredients.map((ingredient) {
                    final isSelected = selectedIngredients[ingredient]!;
                    return ChoiceChip(
                      label: Text(
                        ingredient,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedIngredients[ingredient] = selected;
                        });
                      },
                      selectedColor: const Color(0xff00b473),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00b473),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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