import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scanner_app/models/nutrition_model.dart';
import 'package:scanner_app/theme/custom_theme.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Product',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        width: 180.0,
                        height: 180.0,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nutella',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: CustomTheme.bringooprimary),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Nutella Chocolate Hazelnut Spread, Perfect on Pancakes',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          '26.5 oz, 750 gram',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('d MMM y').format(
                                      DateTime.now().subtract(
                                        const Duration(days: 3),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                  Text(
                                    'Date added',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.35),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('d MMM y')
                                        .format(DateTime.now()),
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                  Text(
                                    'Latest update',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.35),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 12.0),
                          child: Divider(height: 1.0),
                        ),
                        const IngredientNutritionTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'EDIT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text(
                      'DELETE',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class IngredientNutritionTab extends StatefulWidget {
  const IngredientNutritionTab({Key? key}) : super(key: key);

  @override
  State<IngredientNutritionTab> createState() => _IngredientNutritionTabState();
}

class _IngredientNutritionTabState extends State<IngredientNutritionTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  List<NutritionModel> nutritions = List.empty();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    final _nutritions = List.generate(2, (index) {
      final nutrition = NutritionModel(
        key: 'parent $index',
        parent: KeyValueModel(
          label: "Total Fat",
          value: '12 g',
        ),
        children: List.generate(2, (index) {
          return NutritionModel(
            key: 'parent $index',
            parent: KeyValueModel(
              label: "Sub/Trans Fat",
              value: '6 g',
            ),
          );
        }),
      );
      return nutrition;
    });
    setState(() {
      nutritions = _nutritions;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 32.0,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                25.0,
              ),
              color: Colors.green,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            isScrollable: true,
            tabs: const [
              Tab(child: Text('Ingredient')),
              Tab(child: Text('Nutrition ')),
            ],
            onTap: (tabIndex) {
              setState(() {
                _tabIndex = tabIndex;
              });
            },
          ),
        ),
        const SizedBox(height: 20.0),
        SizedBox(
          width: double.infinity,
          child: _tabIndex == 0
              ? const Text(
                  'Sugar, Vegerable Oil, Hazelnuts (13%), Skim Milk Powder (8.7%), Fat-reduced cocoa powder (7.4%), Emulsifier (Soy Lecithin), Flavouring (Vanillin).\n\nContains Hazelnuts, Milk, Soy. Total Milk Solids: 8.7% Total Cocoa Solids: 7.4%')
              : _buildNutrition(),
        ),
      ],
    );
  }

  Widget _buildNutrition() {
    return Column(
      children: nutritions.asMap().entries.map((index) {
        return NutritionDetail(nutritionModel: nutritions[index.key]);
      }).toList(),
    );
  }
}

class NutritionDetail extends StatelessWidget {
  const NutritionDetail({Key? key, this.nutritionModel}) : super(key: key);

  final NutritionModel? nutritionModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          _buildFlexBetweenRow(nutritionModel?.parent),
          nutritionModel?.children != null
              ? Column(
                  children: [
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4.0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: nutritionModel?.children?.length ?? 0,
                        itemBuilder: ((context, index) {
                          return _buildFlexBetweenRow(
                              nutritionModel?.children?[index].parent);
                        }),
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildFlexBetweenRow(KeyValueModel? keyValueModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(keyValueModel?.label ?? ''),
        Text(keyValueModel?.value ?? ''),
      ],
    );
  }
}
