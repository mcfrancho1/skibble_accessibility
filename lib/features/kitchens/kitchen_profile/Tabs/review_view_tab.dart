import 'package:flutter/material.dart';

class ReviewViewTab extends StatefulWidget {
  const ReviewViewTab({super.key});

  @override
  State<ReviewViewTab> createState() => _ReviewViewTabState();
}

class _ReviewViewTabState extends State<ReviewViewTab> {
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
            SliverToBoxAdapter(child: FutureBuilder(
                builder: (context, snapshot) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reviews",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 7,),
                      reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),
                        reviewContainer(context),
                       Divider(color: Colors.grey.shade300,),

                    ],
                  ),
                ),
              );
            }, future: null,))
          ]));
    }
    );
  }

  Container reviewContainer(BuildContext context) {
    return Container(
                  height: 110,
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                image:  DecorationImage(
                                     image: AssetImage(
                                       'assets/images/reviewperson.png'
                                        ),
                                       fit: BoxFit.cover
                                        ),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Great North",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF233748),
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  starIcon(),
                                  starIcon(),
                                  starIcon(),
                                  starIcon(),
                                  starIcon(),
                                  SizedBox(width: 2),
                                  Text(
                                    "4.0",
                                    style: TextStyle(
                                      color: Color(0xFF919BA4),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                     SizedBox(height: 5,),
                      descriptionText(
                        text: "I love getting my food with skibble cause the process is so"
                      ),
                      descriptionText(
                        text: "seamless straight forward and within a short time it is ready"
                      ),
                      descriptionText(
                        text: "for delivery"
                      )
                    ],
                  ),
                );
  }
   Icon starIcon() {
    return Icon(
      Icons.star_outline_rounded,
      size: 17,
      color: Color(0xFFECD400),
    );
  }

  Text descriptionText({text}) {
    return Text(
      text,
      style: TextStyle(color: Color(0xFF919BA4), fontSize: 13),
    );
  }
}
