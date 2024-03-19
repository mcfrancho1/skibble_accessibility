import 'package:flutter/material.dart';
import 'package:skibble/features/kitchens/kitchen_profile/cart_screen.dart';

class FeaturedItemDetailsPage extends StatefulWidget {
  const FeaturedItemDetailsPage({super.key});

  @override
  State<FeaturedItemDetailsPage> createState() =>
      _FeaturedItemDetailsPageState();
}

class _FeaturedItemDetailsPageState extends State<FeaturedItemDetailsPage> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count < 1) {
      return;
    }
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/foodd.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  GestureDetector(
                    onTap: (() => Navigator.pop(context)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Color(0xFF00BF6D),
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: Color(0xFFFF6565),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Asparagus Bruschetta",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF233748),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        starIcon(),
                        starIcon(),
                        starIcon(),
                        starIcon(),
                        starIcon(),
                        SizedBox(width: 10),
                        Text(
                          "4.0",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "(20)",
                          style: TextStyle(color: Color(0xFF919BA4)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$200.00",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF233748),
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: _decrement,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFF00BF6D),
                                    ),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Color(0xFF00BF6D),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${_count}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF00BF6D),
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: _increment,
                              child: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Color(0xFF00BF6D),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Food Description",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF233748),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    descriptionText(
                        text:
                            "The flesh is juicy and sweet, with a tangy aftertaste that"),
                    descriptionText(
                        text:
                            "lingers on the tongue. The large, smooth pit in the center is"),
                    descriptionText(
                        text:
                            "easily removed to reveal more of the luscious flesh. Perfect"),
                    descriptionText(
                        text:
                            "as a snack on its own, or paired with a creamy vanilla ice"),
                    descriptionText(text: "cream for a delicious dessert."),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Ingredients",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF233748),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        ingredientContainer(
                          text: "Rice",
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ingredientContainer(
                          text: "Chicken",
                          width: 70.0,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ingredientContainer(
                          text: "Salt",
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ingredientContainer(
                          text: "Egg",
                          width: 50.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        ingredientContainer(
                          text: "Tomato",
                          width: 70.0,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ingredientContainer(
                          text: "Onion",
                          width: 60.0,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        ingredientContainer(
                          text: "Pepper",
                          width: 70.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "See Reviews",
                          style: TextStyle(
                            color: Color(0xFF00BF6D),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF00BF6D),
                        )
                      ],
                    ),
                  ],
                ),
              ),
             Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                       child: ListView(
                        padding: EdgeInsets.only(top: 0.0),
                         scrollDirection: Axis.vertical,
                         children: [
                           reviewContainer(context),
                            reviewContainer(context),
                             reviewContainer(context),
                             reviewContainer(context),
                           
                         ],
                       ),
                     ),
                      InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFF00BF6D),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
             
            ]),
          ),
          // InkWell(
          //   // onTap: () {
          //   //   // Navigator.of(context)
          //   //   //     .push(MaterialPageRoute(builder: (context) => CartScreen()));
          //   // },
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Container(
          //         height: 48,
          //         width: MediaQuery.of(context).size.width,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF00BF6D),
          //           borderRadius: BorderRadius.circular(24),
          //         ),
          //         child: Center(
          //           child: Text(
          //             "Add to Cart",
          //             style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w700,
          //                 color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
    
      );
  }

  Container reviewContainer(BuildContext context) {
    return Container(
                    height: 110,
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  );
  }

  Container ingredientContainer({text, width}) {
    return Container(
      height: 36,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF919BA4)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Color(0xFF919BA4), fontSize: 14),
        ),
      ),
    );
  }

  Text descriptionText({text}) {
    return Text(
      text,
      style: TextStyle(color: Color(0xFF919BA4), fontSize: 13),
    );
  }

  Icon starIcon() {
    return Icon(
      Icons.star_outline_rounded,
      size: 17,
      color: Color(0xFFECD400),
    );
  }
}
