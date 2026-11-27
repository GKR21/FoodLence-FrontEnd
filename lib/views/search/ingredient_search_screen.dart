import 'package:flutter/material.dart';
import 'package:foodlence/models/ingredient_model.dart';
import 'package:foodlence/services/ingredient_service.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final _queryController = TextEditingController();
  final _ingredientService = IngredientService();
  List<IngredientModel> _results = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _search([String? query]) {
    if (query != null) {
      _queryController.text = query;
    }

    final results = _ingredientService.parse(_queryController.text);
    setState(() {
      _results = results;
      _hasSearched = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    _queryController.clear();
    setState(() {
      _results = [];
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ingredient search')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Understand what's on the label",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Search an ingredient or paste a comma-separated label to see a plain-language description.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _queryController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'e.g. milk, wheat flour, E211',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _queryController.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: _clearSearch,
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _search(),
                      icon: const Icon(Icons.manage_search_rounded),
                      label: const Text('Search ingredients'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Try an example',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ExampleChip(
                        label: 'Wheat flour',
                        onPressed: () => _search('Wheat flour'),
                      ),
                      _ExampleChip(
                        label: 'Milk, soy lecithin',
                        onPressed: () => _search('Milk, soy lecithin'),
                      ),
                      _ExampleChip(
                        label: 'E211',
                        onPressed: () => _search('E211'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (!_hasSearched)
                    _SearchPrompt(color: colorScheme.onSurfaceVariant)
                  else if (_results.isEmpty)
                    _EmptyResults(color: colorScheme.onSurfaceVariant)
                  else ...[
                    Text(
                      '${_results.length} ${_results.length == 1 ? 'ingredient' : 'ingredients'} found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final ingredient in _results)
                      _IngredientResultCard(
                        ingredient: ingredient,
                        info: _ingredientService.infoFor(ingredient),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Descriptions are general information and do not determine whether a product is safe for you.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  const _ExampleChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onPressed);
  }
}

class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return _SearchMessage(
      icon: Icons.menu_book_outlined,
      title: 'Start with an ingredient',
      message:
          'Enter a name, additive code, or paste ingredients from a label.',
      color: color,
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return _SearchMessage(
      icon: Icons.search_off_rounded,
      title: 'No ingredients entered',
      message: 'Add an ingredient name or paste a food label to get started.',
      color: color,
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

class _IngredientResultCard extends StatelessWidget {
  const _IngredientResultCard({required this.ingredient, required this.info});

  final IngredientModel ingredient;
  final IngredientInfo info;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ingredient.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ingredient.eNumber ?? ingredient.type,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              info.what,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 8),
            Text(
              info.foundIn,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
