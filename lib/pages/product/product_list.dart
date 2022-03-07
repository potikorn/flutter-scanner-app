import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:scanner_app/pages/product/product_detail.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController =
      ScrollController(); // set controller on scrolling
  bool _show = true;

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloatingButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloatingButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloatingButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloatingButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                ),
              ),
            ),
            Container(
              height: 1.0,
              color: const Color.fromRGBO(196, 196, 196, 0.25),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: 40,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10.0,
                  ),
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const ProductDetailPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(196, 196, 196, 0.25),
                              width: 1.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              color: Colors.grey.withOpacity(0.3),
                              width: 48.0,
                              height: 48.0,
                            ),
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("item ${index + 1}"),
                                Text("Price at index ${index + 1}"),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _show ? 1.0 : 0,
        duration: const Duration(milliseconds: 300),
        child: Visibility(
          visible: _show,
          child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
      ),
      // floatingActionButton: FloatingActionBubble(
      //   items: [
      //     Bubble(
      //         icon: Icons.edit,
      //         iconColor: Colors.white,
      //         title: 'Scan Barcode',
      //         titleStyle: const TextStyle(),
      //         bubbleColor: CustomTheme.bringooprimary,
      //         onPress: () {})
      //   ],
      //   iconData: Icons.add,
      //   // animation: const Animation(),
      //   backGroundColor: CustomTheme.bringooprimary,
      //   iconColor: Colors.white,
      //   onPress: () {},
      // ),
    );
  }

  Widget _buildEmptyProduct() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 70.0,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'No Product data available',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              'you can add the products by scan barcode or manual add, the products will be displayed in this page.',
              style: TextStyle(color: Colors.black.withOpacity(0.25)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
