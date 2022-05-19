import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "iPhone", price: 999),
  Product(name: "cookie", price: 2),
  Product(name: "ps5", price: 500),
  Product(name: "apple", price: 50),
];

enum ProductSortType {
  name,
  price,
}

final productSortTypeProvider = StateProvider<ProductSortType>(
  (ref) => ProductSortType.name,
);

final productsProvider = Provider<List<Product>>((ref) {
  //ここでソートタイプの変更を受け取り再描画
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));

    case ProductSortType.price:
      return _products.sorted((a, b) => a.price.compareTo(b.price));
  }
});

class HomeScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          DropdownButton(
            value: ref.watch(productSortTypeProvider),
            items: const [
              DropdownMenuItem(
                value: ProductSortType.name,
                child: Icon(Icons.sort_by_alpha),
              ),
              DropdownMenuItem(
                value: ProductSortType.price,
                child: Icon(Icons.sort),
              ),
            ],
            onChanged: (value) {
              ref.read(productSortTypeProvider.notifier).state =
                  value as ProductSortType;
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 20,
            child: ListTile(
              leading: const Icon(Icons.monetization_on_outlined),
              //read:プロバイダの値を取得するだけで監視もリビルドもしない
              title: Text(ref.read(productsProvider)[index].name),
            ),
          );
        },
      ),
    );
  }
}
