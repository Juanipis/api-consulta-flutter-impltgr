class Book {
  final String id;
  final String type;
  final BookAttributes attributes;
  final BookRelationships relationships;

  Book({required this.id, required this.type, required this.attributes, required this.relationships});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      type: json['type'],
      attributes: BookAttributes.fromJson(json['attributes']),
      relationships: BookRelationships.fromJson(json['relationships']),
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

  BookAttributes({required this.slug, required this.author, required this.cover, required this.dedication, required this.pages, required this.releaseDate, required this.summary, required this.title, required this.wiki});

  factory BookAttributes.fromJson(Map<String, dynamic> json) {
    return BookAttributes(
      slug: json['slug'],
      author: json['author'],
      cover: json['cover'],
      dedication: json['dedication'],
      pages: json['pages'],
      releaseDate: json['release_date'],
      summary: json['summary'],
      title: json['title'],
      wiki: json['wiki'],
    );
  }
}

class BookRelationships {
  final Chapters chapters;

  BookRelationships({required this.chapters});

  factory BookRelationships.fromJson(Map<String, dynamic> json) {
    return BookRelationships(
      chapters: Chapters.fromJson(json['chapters']),
    );
  }
}

class Chapters {
  final List<ChapterData> data;

  Chapters({required this.data});

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      data: (json['data'] as List).map((i) => ChapterData.fromJson(i)).toList(),
    );
  }
}

class ChapterData {
  final String id;
  final String type;

  ChapterData({required this.id, required this.type});

  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      id: json['id'],
      type: json['type'],
    );
  }
}

class BookLinks {
  final String self;

  BookLinks({required this.self});

  factory BookLinks.fromJson(Map<String, dynamic> json) {
    return BookLinks(
      self: json['self'],
    );
  }
}
class BookResponse {
  final List<Book> data;
  final BookLinks links;

  BookResponse({required this.data, required this.links});

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      data: (json['data'] as List).map((i) => Book.fromJson(i)).toList(),
      links: BookLinks.fromJson(json['links']),
    );
  }
}


