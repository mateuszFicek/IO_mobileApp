import 'package:auction_search/User.dart';

/// Klasa zapytania, która zawiera w sobie atrybuty, które określają zapytanie w aplikacji oraz serwerze.
class Request {
  final int requestId;
  final String description;
  final User user;
  final String creationDate;
  final String status;
  final double price;
  final String auctionLinkAllegro;
  final String auctionLinkEbay;

  Request(
      {this.requestId,
      this.description,
      this.creationDate,
      this.status,
      this.user,
      this.price,
      this.auctionLinkAllegro,
      this.auctionLinkEbay});

  /// Funkcja, która zamienia json otrzymany z serwera na obiekt typu Request.
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      requestId: json['id'],
      user: User.fromJson(json['user']),
      description: json['description'].toString(),
      creationDate: json['creationDate'],
      status: json['status'].toString(),
      price: json['maxPrice'],
      auctionLinkAllegro: json['allegroAuctionLink'],
      auctionLinkEbay: json['ebayAuctionLink'],
    );
  }
}
