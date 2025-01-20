import 'package:sca_shopper/models/request_model/login_model.dart';
import 'package:sca_shopper/models/request_model/register_model.dart';
import 'package:sca_shopper/models/response_model/category_model.dart';
import 'package:sca_shopper/models/response_model/product_model.dart';
import 'package:sca_shopper/models/response_model/user_model.dart';
import 'package:sca_shopper/services/api_services.dart';
import 'package:sca_shopper/services/cache_service.dart';

import '../models/response_model/login_response_model.dart';

class ApiRepository {
  final apiService = ApiService();
  final cacheService = CacheService();

  Future<({UserModel? user, String? error})> createUser(
      RegisterModel model) async {
    final req =
        await apiService.post(endpoint: "api/v1/users/", data: model.toJson());
    if (req.data != null) {
      return (user: UserModel.fromJson(req.data), error: null);
    } else {
      return (user: null, error: req.error);
    }
  }

  Future<({bool? login, String? error})> loginUser(LoginModel model) async {
    final req = await apiService.post(
        endpoint: "api/v1/auth/login", data: model.toJson());
    if (req.data != null) {
      final loginmodel = LoginResponseModel.fromJson(req.data);

      if (loginmodel.accessToken != null) {
        await cacheService.saveToken(loginmodel.accessToken ?? "");
      }
      return (login: true, error: null);
    } else {
      return (login: false, error: req.error);
    }
  }

  Future<({List<CategoryModel>? cats, String? error})> fetchCategories() async {
    final req = await apiService.get(endpoint: "api/v1/categories?limit=100");
    if (req.data != null) {
      final data = req.data as List;
      final listOfCats =
          List<CategoryModel>.from(data.map((e) => CategoryModel.fromJson(e)));
      return (cats: listOfCats, error: null);
    } else {
      return (cats: null, error: req.error);
    }
  }

  Future<({List<ProductModel>? products, String? error})> fetchProductsById(
      String id) async {
    final req = await apiService.get(
        endpoint: "api/v1/categories/$id/products?limit=100&offset=0");
    if (req.data != null) {
      final data = req.data as List;
      final listOfCats =
          List<ProductModel>.from(data.map((e) => ProductModel.fromJson(e)));
      return (products: listOfCats, error: null);
    } else {
      return (products: null, error: req.error);
    }
  }

  Future<({List<ProductModel>? cats, String? error})> fetchProducts() async {
    final req = await apiService.get(
        endpoint: "https://api.escuelajs.co/api/v1/products");
    if (req.data != null) {
      final data = req.data as List;
      final listOfCats =
          List<ProductModel>.from(data.map((e) => ProductModel.fromJson(e)));
      return (cats: listOfCats, error: null);
    } else {
      return (cats: null, error: req.error);
    }
  }
}
