class Request {
  final String userid;
  final int requestId;
  final String title;
  final String creationDate;
  final String status;
  final int price;
  final String auctionLinkAllegro;
  final String auctionLinkEbay;

  Request({this.userid, this.requestId, this.title, this.creationDate,this.status, this.price, this.auctionLinkAllegro, this.auctionLinkEbay});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      userid: json['userid'],
      requestId: json['request_id'],
      title: json['title'],
      creationDate: json['creation_date'],
      status: json['status'],
      price: json['price'],
      auctionLinkAllegro: json['auction_link_allegro'],
      auctionLinkEbay: json['auction_link_ebay'],
    );
  }
}