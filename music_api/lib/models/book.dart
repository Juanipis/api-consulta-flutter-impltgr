class Book {
  final String id;
  final String type;
  final BookAttributes? attributes;

  Book({
    required this.id,
    required this.type,
    this.attributes,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      attributes: json['attributes'] != null
          ? BookAttributes.fromJson(json['attributes'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BookAttributes {
  final String slug;
  final String author;
  final String cover;
  final String dedication;
  final int pages;
  final String releaseDate;
  final String summary;
  final String title;
  final String wiki;

  BookAttributes({
    required this.slug,
    required this.author,
    required this.cover,
    required this.dedication,
    required this.pages,
    required this.releaseDate,
    required this.summary,
    required this.title,
    required this.wiki,
  });

  factory BookAttributes.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
      throw ArgumentError('json cannot be null');
    }

    return BookAttributes(
      slug: json['slug'] ?? '',
      author: json['author'] ?? '',
      cover: json['cover'] ?? '',
      dedication: json['dedication'] ?? '',
      pages: json['pages'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      summary: json['summary'] ?? '',
      title: json['title'] ?? '',
      wiki: json['wiki'] ?? '',
    );
  }
}

class Chapter {
  final String id;
  final String type;
  final ChapterAttributes? attributes;
  final ChapterRelationships? relationships;

  Chapter({
    required this.id,
    required this.type,
    this.attributes,
    this.relationships,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      attributes: json['attributes'] != null
          ? ChapterAttributes.fromJson(
              json['attributes'] as Map<String, dynamic>)
          : null,
      relationships: json['relationships'] != null
          ? ChapterRelationships.fromJson(
              json['relationships'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChapterAttributes {
  final String slug;
  final int order;
  final String summary;
  final String title;

  ChapterAttributes({
    required this.slug,
    required this.order,
    required this.summary,
    required this.title,
  });

  factory ChapterAttributes.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
      throw ArgumentError('json cannot be null');
    }

    return ChapterAttributes(
      slug: json['slug'] ?? '',
      order: json['order'] ?? 0,
      summary: json['summary'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class ChapterRelationships {
  final Book? book;

  ChapterRelationships({this.book});

  factory ChapterRelationships.fromJson(Map<String, dynamic> json) {
    var bookData = json['book']?['data'];
    return ChapterRelationships(
      book: bookData != null
          ? Book.fromJson(bookData as Map<String, dynamic>)
          : null,
    );
  }
}

class ChapterResponse {
  final List<Chapter> data;

  ChapterResponse({required this.data});

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_null_comparison
    if (json == null) {
      throw ArgumentError('json cannot be null');
    }

    var dataList = json['data'];
    if (dataList == null) {
      throw ArgumentError('data cannot be null');
    }

    return ChapterResponse(
      data: (dataList as List)
          .map((i) => Chapter.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
