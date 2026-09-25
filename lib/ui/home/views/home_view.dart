import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clean_code_challenge/ui/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitrine de Produtos'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.carregarProdutos,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('Nenhum produto disponivel'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
