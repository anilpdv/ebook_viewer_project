class BookRatings {
  List<Books> books;

  BookRatings({this.books});

  BookRatings.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = new List<Books>();
      json['books'].forEach((v) {
        books.add(new Books.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.books != null) {
      data['books'] = this.books.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Books {
  int id;
  String isbn;
  String isbn13;
  int ratingsCount;
  int reviewsCount;
  int textReviewsCount;
  int workRatingsCount;
  int workReviewsCount;
  int workTextReviewsCount;
  String averageRating;

  Books(
      {this.id,
      this.isbn,
      this.isbn13,
      this.ratingsCount,
      this.reviewsCount,
      this.textReviewsCount,
      this.workRatingsCount,
      this.workReviewsCount,
      this.workTextReviewsCount,
      this.averageRating});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isbn = json['isbn'];
    isbn13 = json['isbn13'];
    ratingsCount = json['ratings_count'];
    reviewsCount = json['reviews_count'];
    textReviewsCount = json['text_reviews_count'];
    workRatingsCount = json['work_ratings_count'];
    workReviewsCount = json['work_reviews_count'];
    workTextReviewsCount = json['work_text_reviews_count'];
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isbn'] = this.isbn;
    data['isbn13'] = this.isbn13;
    data['ratings_count'] = this.ratingsCount;
    data['reviews_count'] = this.reviewsCount;
    data['text_reviews_count'] = this.textReviewsCount;
    data['work_ratings_count'] = this.workRatingsCount;
    data['work_reviews_count'] = this.workReviewsCount;
    data['work_text_reviews_count'] = this.workTextReviewsCount;
    data['average_rating'] = this.averageRating;
    return data;
  }
}
