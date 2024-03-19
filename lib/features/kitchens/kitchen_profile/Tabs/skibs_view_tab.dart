import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SkibsViewTab extends StatefulWidget {
  const SkibsViewTab({super.key});

  @override
  State<SkibsViewTab> createState() => _SkibsViewTabState();
}

class _SkibsViewTabState extends State<SkibsViewTab> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
                child: FutureBuilder(builder: (context, snapshot) {
                  return Container(
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Skibs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              skibContainer(image: AssetImage('assets/images/skib.png')),
                              skibContainer(image: AssetImage('assets/images/skibbb.png')),
                              skibContainer(image: AssetImage('assets/images/skibbbb.png')),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              skibContainer(image: AssetImage('assets/images/skibbb.png')),
                              skibContainer(image: AssetImage('assets/images/skibbbb.png')),
                              skibContainer(image: AssetImage('assets/images/skib.png')),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              skibContainer(image: AssetImage('assets/images/skibbbb.png')),
                              skibContainer(image: AssetImage('assets/images/skib.png')),
                              skibContainer(image: AssetImage('assets/images/skibbb.png')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }, future: null,))
          ]));
    });
  }

  skibContainer({image}) {
    return Container(
      height: 113,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: image, fit: BoxFit.cover),
      ),
      child: Container(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(15)),
          child: Icon(Iconsax.picture_frame4,
          size: 17,
          color: Colors.white,
          ),
          ),
        ),
      ),
    );
  }
}
