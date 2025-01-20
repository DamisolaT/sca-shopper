import 'package:flutter/material.dart';
import 'package:sca_shopper/shared/colors.dart';
import 'package:sca_shopper/shared/constants.dart';

class ProductsDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductsDetailsScreen({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['title'] ?? "Product Details",
          style: style.copyWith(color: AppColors.white, fontSize: 18),
        ),
        backgroundColor: AppColors.appColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                product['images']?[0] ?? "",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Product Title
            Text(
              product['title'] ?? "No Title",
              style: style.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            // Product Price
            Text(
              "\$${product['price']?.toStringAsFixed(2) ?? '0.00'}",
              style: style.copyWith(
                fontSize: 18,
                color: AppColors.appColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            // Product Description
            Text(
              product['description'] ?? "No Description Available",
              style: style.copyWith(
                fontSize: 16,
                color: AppColors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
