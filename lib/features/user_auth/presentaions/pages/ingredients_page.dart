import 'package:flutter/material.dart';
import 'package:firebase_login/core/api/kitchen_controller.dart';

class IngredientsPage extends StatefulWidget {
  final List<int> kitchenItemIds;

  const IngredientsPage({Key? key, this.kitchenItemIds = const []})
      : super(key: key);

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final KitchenController _kitchenController = KitchenController();
  List<Map<String, dynamic>> ingredients = [];
  List allIngredients = [];
  List filteredIngredients = [];
  final Set<int> availableInKitchen = {};
  int currentPage = 1;
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    availableInKitchen.addAll(widget.kitchenItemIds);
    _fetchAvailableIngredients(currentPage);
    _fetchAllIngredients();
    _searchController.addListener(_filterIngredients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          filteredIngredients = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No ingredients found for this page.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ingredients: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAllIngredients() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _kitchenController.getAllIngredients();
      if (data != null && data.isNotEmpty) {
        setState(() {
          allIngredients = data;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ingredients: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterIngredients() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        filteredIngredients = ingredients;
      });
    } else {
      setState(() {
        filteredIngredients = allIngredients
            .where((ingredient) =>
                ingredient['name'].toLowerCase().contains(query))
            .toList();
      });
    }
  }

  Future<void> _toggleIngredient(int id) async {
    try {
      await _kitchenController.toggleIngredient(id);
      setState(() {
        if (availableInKitchen.contains(id)) {
          availableInKitchen.remove(id);
        } else {
          availableInKitchen.add(id);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(availableInKitchen.contains(id)
              ? 'Added to kitchen'
              : 'Removed from kitchen'),
        ),
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
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Ingredients',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Cooking Essentials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredIngredients.isEmpty
                    ? const Center(child: Text("No ingredients found."))
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: filteredIngredients.map((ingredient) {
                          final id = ingredient['id'] as int;
                          final isInKitchen = availableInKitchen.contains(id);

                          return ChoiceChip(
                            label: Text(ingredient['name']),
                            selected: isInKitchen,
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
