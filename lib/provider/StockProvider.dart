import 'package:flutter/material.dart';
import '../model/stock.dart';

class StockProvider extends ChangeNotifier {
  final List<Stock> _stocks = [];

  List<Stock> get stocks => _stocks;

  void addStock(String fishName, int quantity) {
    final existingStock = _stocks.firstWhere(
          (stock) => stock.fishName == fishName,
      orElse: () => Stock(fishName: fishName, quantity: 0),
    );

    if (_stocks.contains(existingStock)) {
      existingStock.quantity += quantity;
    } else {
      _stocks.add(Stock(fishName: fishName, quantity: quantity));
    }
    notifyListeners();
  }

  void reduceStock(String fishName, int quantity) {
    final existingStock = _stocks.firstWhere(
          (stock) => stock.fishName == fishName,
      orElse: () => Stock(fishName: fishName, quantity: 0),
    );

    if (_stocks.contains(existingStock) && existingStock.quantity >= quantity) {
      existingStock.quantity -= quantity;
    }
    notifyListeners();
  }
}
