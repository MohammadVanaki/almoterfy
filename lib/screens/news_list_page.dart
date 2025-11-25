import 'dart:async';

import 'package:almoterfy/Components/news_card.dart';
import 'package:almoterfy/Components/skeleton.dart';
import 'package:almoterfy/api/news_api.dart';
import 'package:almoterfy/api/news_model.dart';
import 'package:almoterfy/constants/constants.dart';
import 'package:almoterfy/screens/news_content.dart';
import 'package:almoterfy/screens/search_page.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_controller.dart' as cs;

class NewsListPag extends StatefulWidget {
  const NewsListPag({super.key});

  @override
  State<NewsListPag> createState() => _NewsListPagState();
}

class _NewsListPagState extends State<NewsListPag> {
  int _current = 0;
  int selectedCategory = 0;
  int gid = 0;
  Future<PostNews>? listNews;
  Future<CategoryResponse>? listCategories;
  final CarouselController _carouselController = CarouselController();

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleRefresh() async {
    setState(() {
      debugPrint("$selectedCategory<<<<<<<");
      Constants.changeCategory = false;
      Constants.refreshNews = true;
      listNews = fetchNews(gid);
    });
  }

  static const List<String> sampleImages = [
    './Assets/images/d-s001.jpg',
    './Assets/images/d-s002.jpg',
    './Assets/images/d-s003.jpg',
    './Assets/images/d-s004.jpg',
  ];

  @override
  void initState() {
    listNews = fetchNews(gid);
    listCategories = fetchCategories();
    super.initState();
    connected();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Constants.connectToInternet
          ? LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              backgroundColor: Colors.white,
              color: Constants.themeColor.withAlpha(200),
              showChildOpacityTransition: false,
              springAnimationDurationInMilliseconds: 300,
              height: 50,
              onRefresh: _handleRefresh,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 15,
                      //     horizontal: 20,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: <Widget>[
                      //       Text(
                      //         "أحدث الأخبار",
                      //         style: TextStyle(
                      //           fontFamily: Constants.boldFontFamily,
                      //           fontWeight: FontWeight.w900,
                      //           fontSize: 18,
                      //           color: Constants.themeColor,
                      //         ),
                      //       ),
                      //       InkWell(
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             PageTransition(
                      //               child: const SearchPage(),
                      //               type: PageTransitionType.bottomToTop,
                      //             ),
                      //           );
                      //         },
                      //         child: RotatedBox(
                      //           quarterTurns: 1,
                      //           child: Icon(
                      //             Icons.search,
                      //             color: Constants.themeColor,
                      //             size: 30,
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      // Slider News
                      Column(
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 220.0,
                              autoPlay: true,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            items: [0, 1, 2].map((i) {
                              return FutureBuilder(
                                future: listNews,
                                builder: (BuildContext context,
                                    AsyncSnapshot<PostNews> snapshot) {
                                  if (snapshot.hasData &&
                                      Constants.changeCategory == true &&
                                      Constants.refreshNews == false) {
                                    // Use sliders.other list
                                    final item =
                                        snapshot.data!.sliders.other[i];

                                    return SliderItem(
                                      id: item.id, // English comments
                                      image: Constants.sliderImageURLPrefix +
                                          item.img,
                                      title: item.title,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text("${snapshot.error}"),
                                    );
                                  }

                                  return const SkeltonSlider();
                                },
                              );
                            }).toList(),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  sampleImages.asMap().entries.map((entry) {
                                return GestureDetector(
                                  onTap: () => _carouselController.animateTo(
                                    double.parse(entry.key.toString()),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Constants.themeColor).withOpacity(
                                          _current == entry.key ? 0.9 : 0.4),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      // CATEGORY
                      SizedBox(
                        height: 30,
                        width: size.width,
                        child: FutureBuilder(
                          future:
                              listCategories, // *** English comment: category future ***
                          builder: (BuildContext context,
                              AsyncSnapshot<CategoryResponse> snapshot) {
                            if (snapshot.hasData &&
                                Constants.refreshNews == false) {
                              final postGroups = snapshot.data!.postGroups;

                              // *** English comment: collect all main groups + all children ***
                              List<CategoryItem> allCategories = [];

                              for (var group in postGroups) {
                                // If main group (parent_id = 0), add it
                                if (group.parentId == 0) {
                                  // Add the group itself as a CategoryItem
                                  allCategories.add(
                                    CategoryItem(
                                      id: group.id,
                                      lang: "ar",
                                      parentId: group.parentId,
                                      title: group.title,
                                      logo: "",
                                      source: "article",
                                      slug: "",
                                      firstPage: 1,
                                      show2site: 1,
                                      idShow: group.id,
                                    ),
                                  );

                                  // Add children categories
                                  allCategories.addAll(group.children);
                                }
                              }

                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: allCategories.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = allCategories[
                                      index]; // *** category item ***

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        Constants.changeCategory = false;
                                        gid =
                                            item.id; // *** use category id ***

                                        listNews = fetchNews(gid);
                                        selectedCategory = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: selectedCategory == index
                                                  ? Constants.themeColor
                                                  : Colors.transparent,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          item.title, // *** category title ***
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontFamily:
                                                Constants.regularFontFamily,
                                            fontSize: 17,
                                            fontWeight:
                                                selectedCategory == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color: selectedCategory == index
                                                ? Constants.themeColor
                                                : Constants.itemColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text("${snapshot.error}"));
                            }

                            return ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return const SkeltonCategory();
                              },
                            );
                          },
                        ),
                      ),

                      //News List
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: size.width - 20,
                        child: FutureBuilderNews(listNews: listNews),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Lottie.asset(
                './Assets/animations/Animation-network.json',
                width: 200,
              ),
            ),
    );
  }
}

class FutureBuilderNews extends StatelessWidget {
  const FutureBuilderNews({
    super.key,
    required this.listNews,
  });

  final Future<PostNews>? listNews;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listNews,
      builder: (BuildContext context, AsyncSnapshot<PostNews> snapshot) {
        if (snapshot.hasData &&
            Constants.changeCategory == true &&
            Constants.refreshNews == false) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.posts.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return NewsCard(
                dataTime: snapshot.data!.posts[index].dateTime.toString(),
                id: snapshot.data!.posts[index].id,
                image:
                    Constants.imageURLPrefix + snapshot.data!.posts[index].img,
                title: snapshot.data!.posts[index].title,
                sw: '',
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const SkeltonNews();
          },
        );
      },
    );
  }
}

class SliderItem extends StatelessWidget {
  final String image;
  final String title;
  final int id;

  const SliderItem({
    super.key,
    required this.image,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: NewsContent(
              newsId: id,
              sw: '',
            ),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Stack(
          children: <Widget>[
            Container(
              clipBehavior: Clip.antiAlias,
              width: size.width,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Image.network(
                image,
                height: 220,
                fit: BoxFit.cover,

                // Frame builder (for decoration)
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: child,
                  );
                },

                // Show default image when URL fails
                errorBuilder: (context, error, stackTrace) {
                  // This widget is shown when the image URL is invalid or fails to load
                  return Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Image.asset(
                        "./Assets/images/logo-bn.png", // Default image
                        fit: BoxFit.contain,
                        height: 130,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 60,
              right: 0,
              left: 0,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Constants.themeColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 90,
                    right: 10,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: Constants.boldFontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
