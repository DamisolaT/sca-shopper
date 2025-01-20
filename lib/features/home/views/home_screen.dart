import 'package:flutter/material.dart';
import 'package:sca_shopper/services/cache_service.dart';
import 'package:sca_shopper/shared/Navigation/app_route_strings.dart';
import 'package:sca_shopper/shared/Navigation/app_router.dart';
import 'package:sca_shopper/shared/colors.dart';
import 'package:sca_shopper/shared/constants.dart';

import '../../../repository/api_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cache = CacheService();
  final apiRepo = ApiRepository();
  bool isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  Future<void> handleLogout() async {
    setLoading(true);
    await cache.deleteToken().then((_) {
      AppRouter.push(AppRouteStrings.loginScreen);
    }).whenComplete(() {
      setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.appColor,
            title: Text(
              "Home Screen",
              style: style.copyWith(fontSize: 20, color: AppColors.white),
            ),
            actions: [
              TextButton(
                onPressed: handleLogout,
                child: Text(
                  "Logout",
                  style: style.copyWith(fontSize: 15, color: AppColors.white),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Categories",
                    style: style.copyWith(
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: apiRepo.fetchCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Could not fetch categories"),
                        );
                      } else if (snapshot.data?.error != null) {
                        return Center(
                          child: Text(
                            snapshot.data?.error ??
                                "Could not fetch categories",
                          ),
                        );
                      }

                      final categories = snapshot.data?.cats ?? [];
                      if (categories.isEmpty) {
                        return const Center(
                          child: Text("No categories available"),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return ReusableListTile(
                            title: category.name ?? "Unknown Category",
                            subtitle: "",
                            imageUrl: category.image ?? "",
                            onTap: () {
                              AppRouter.push(
                                AppRouteStrings.productListScreen,
                                arg: category,
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(height: 0),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Products",
                    style: style.copyWith(
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: apiRepo.fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Could not fetch products"),
                        );
                      } else if (snapshot.data?.error != null) {
                        return Center(
                          child: Text(
                            snapshot.data?.error ?? "Could not fetch products",
                          ),
                        );
                      }

                      final products = snapshot.data?.cats ?? [];
                      if (products.isEmpty) {
                        return const Center(
                          child: Text("No products available"),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ReusableListTile(
                            title: product.title ?? "No Title",
                            subtitle:
                                "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                            imageUrl: (product.images?.isNotEmpty ?? false)
                                ? product.images!.first
                                : "",
                            onTap: () {
                              AppRouter.push(
                                AppRouteStrings.productDetailsScreen,
                                arg: product,
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(height: 0),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class ReusableListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const ReusableListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            )
          : const Icon(Icons.image, size: 50),
      title: Text(
        title.isNotEmpty ? title : "No Title Available",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
