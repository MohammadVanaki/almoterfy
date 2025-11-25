// class PostNews {
//     List<News> news;
//     List<News> sliders;
//     List<Category> categories;

//     PostNews({
//         required this.news,
//         required this.sliders,
//         required this.categories,
//     });

//     factory PostNews.fromJson(Map<String, dynamic> json) => PostNews(
//         news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
//         sliders: List<News>.from(json["sliders"].map((x) => News.fromJson(x))),
//         categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "news": List<dynamic>.from(news.map((x) => x.toJson())),
//         "sliders": List<dynamic>.from(sliders.map((x) => x.toJson())),
//         "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
//     };
// }

// class Category {
//     int id;
//     int parentId;
//     String title;
//     List<dynamic>? children;
//     String? slug;

//     Category({
//         required this.id,
//         required this.parentId,
//         required this.title,
//         this.children,
//         this.slug,
//     });

//     factory Category.fromJson(Map<String, dynamic> json) => Category(
//         id: json["id"],
//         parentId: json["parent_id"],
//         title: json["title"],
//         children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
//         slug: json["slug"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "parent_id": parentId,
//         "title": title,
//         "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
//         "slug": slug,
//     };
// }

// class News {
//     int id;
//     int categoryId;
//     String title;
//     String img;
//     int dateTime;
//     String categoryTitle;
//     String newsDate;
//     Category? category;

//     News({
//         required this.id,
//         required this.categoryId,
//         required this.title,
//         required this.img,
//         required this.dateTime,
//         required this.categoryTitle,
//         required this.newsDate,
//         this.category,
//     });

//     factory News.fromJson(Map<String, dynamic> json) => News(
//         id: json["id"],
//         categoryId: json["category_id"],
//         title: json["title"],
//         img: json["img"],
//         dateTime: json["date_time"],
//         categoryTitle: json["category_title"],
//         newsDate: (json["news_date"]),
//         category: json["category"] == null ? null : Category.fromJson(json["category"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         "title": title,
//         "img": img,
//         "date_time": dateTime,
//         "category_title": categoryTitle,
//         "news_date": newsDate,
//         "category": category?.toJson(),
//     };
// }

// class PostNewsContent {
//     List<Post> post;

//     PostNewsContent({
//         required this.post,
//     });

//     factory PostNewsContent.fromJson(Map<String, dynamic> json) => PostNewsContent(
//         post: List<Post>.from(json["post"].map((x) => Post.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "post": List<dynamic>.from(post.map((x) => x.toJson())),
//     };
// }

// class Post {
//     int id;
//     int categoryId;
//     String title;
//     String img;
//     int dateTime;
//     String content;
//     String categoryTitle;
//     String newsDate;

//     Post({
//         required this.id,
//         required this.categoryId,
//         required this.title,
//         required this.img,
//         required this.dateTime,
//         required this.content,
//         required this.categoryTitle,
//         required this.newsDate,
//     });

//     factory Post.fromJson(Map<String, dynamic> json) => Post(
//         id: json["id"],
//         categoryId: json["category_id"],
//         title: json["title"],
//         img: json["img"],
//         dateTime: json["date_time"],
//         content: json["content"],
//         categoryTitle: json["category_title"],
//         newsDate: (json["news_date"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         "title": title,
//         "img": img,
//         "date_time": dateTime,
//         "content": content,
//         "category_title": categoryTitle,
//         "news_date": newsDate,
//     };
// }

// class Search {
//   List<News> news;

//   Search({
//     required this.news,
//   });

//   factory Search.fromJson(Map<String, dynamic> json) => Search(
//         news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "news": List<dynamic>.from(news.map((x) => x.toJson())),
//       };
// }

import 'dart:convert';

/// Main model for API response
class PostNews {
  final List<PostItem> posts;
  final Sliders sliders;

  PostNews({
    required this.posts,
    required this.sliders,
  });

  factory PostNews.fromJson(Map<String, dynamic> json) {
    return PostNews(
      posts: (json['posts'] as List).map((e) => PostItem.fromJson(e)).toList(),
      sliders: Sliders.fromJson(json['sliders']),
    );
  }
}

/// Model for posts list
class PostItem {
  final int id;
  final int categoryId;
  final String title;
  final String img;
  final int dateTime;

  PostItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.img,
    required this.dateTime,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      img: json['img'],
      dateTime: json['date_time'],
    );
  }

  /// Convert object to JSON map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category_id": categoryId,
      "title": title,
      "img": img,
      "date_time": dateTime,
    };
  }
}

/// Sliders model
class Sliders {
  final List<dynamic> fixed; // list is empty according to your API
  final List<SliderItem> other;

  Sliders({
    required this.fixed,
    required this.other,
  });

  factory Sliders.fromJson(Map<String, dynamic> json) {
    return Sliders(
      fixed: json['fixed'] ?? [],
      other:
          (json['other'] as List).map((e) => SliderItem.fromJson(e)).toList(),
    );
  }
}

/// Slider item inside "other"
class SliderItem {
  final int id;
  final String title;
  final String img;
  final int dateTime;
  final int categoryId;
  final Category category;

  SliderItem({
    required this.id,
    required this.title,
    required this.img,
    required this.dateTime,
    required this.categoryId,
    required this.category,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id'],
      title: json['title'],
      img: json['img'],
      dateTime: json['date_time'],
      categoryId: json['category_id'],
      category: Category.fromJson(json['category']),
    );
  }
}

/// Category model for sliders
class Category {
  final int id;
  final String title;
  final String slug;
  final int parentId;

  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      parentId: json['parent_id'],
    );
  }
}

/// Main model for article content response
class PostNewsContent {
  final List<PostContentItem> post;

  PostNewsContent({required this.post});

  factory PostNewsContent.fromJson(Map<String, dynamic> json) {
    return PostNewsContent(
      post: (json['post'] as List)
          .map((e) => PostContentItem.fromJson(e))
          .toList(),
    );
  }
}

/// Model for each post content item
class PostContentItem {
  final int id;
  final int categoryId;
  final String title;
  final String img;
  final int dateTime;
  final String content; // HTML content

  PostContentItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.img,
    required this.dateTime,
    required this.content,
  });

  factory PostContentItem.fromJson(Map<String, dynamic> json) {
    return PostContentItem(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
      img: json['img'],
      dateTime: json['date_time'],
      content: json['content'], // HTML string
    );
  }
}

class Search {
  List<PostItem> news;
  final Sliders sliders;
  Search({
    required this.news,
    required this.sliders,
  }); 

  factory Search.fromJson(Map<String, dynamic> json) => Search(
      news: List<PostItem>.from(json["posts"].map((x) => PostItem.fromJson(x))),
      sliders: Sliders.fromJson(
        json['sliders'],
      ));

  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(news.map((x) => x.toJson())),
      };
}
 
/// The main response model
class CategoryResponse {
  final List<PostGroup> postGroups;

  CategoryResponse({required this.postGroups});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      postGroups: (json['post_groups'] as List)
          .map((e) => PostGroup.fromJson(e))
          .toList(),
    );
  }
}

/// Model for each group in "post_groups"
class PostGroup {
  final int id;
  final int parentId;
  final String title;
  final List<CategoryItem> children;

  PostGroup({
    required this.id,
    required this.parentId,
    required this.title,
    required this.children,
  });

  factory PostGroup.fromJson(Map<String, dynamic> json) {
    return PostGroup(
      id: json['id'],
      parentId: json['parent_id'],
      title: json['title'],
      children: (json['children'] as List)
          .map((e) => CategoryItem.fromJson(e))
          .toList(),
    );
  }
}

/// Model for each category in "children"
class CategoryItem {
  final int id;
  final String lang;
  final int parentId;
  final String title;
  final String logo;
  final String source;
  final String slug;
  final int firstPage;
  final int show2site;
  final int idShow;

  CategoryItem({
    required this.id,
    required this.lang,
    required this.parentId,
    required this.title,
    required this.logo,
    required this.source,
    required this.slug,
    required this.firstPage,
    required this.show2site,
    required this.idShow,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      lang: json['lang'],
      parentId: json['parent_id'],
      title: json['title'],
      logo: json['logo'],
      source: json['source'],
      slug: json['slug'],
      firstPage: json['first_page'],
      show2site: json['show2site'],
      idShow: json['id_show'],
    );
  }
}
