import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';

class MenuViewTab extends StatefulWidget {
  const MenuViewTab({super.key});

  @override
  State<MenuViewTab> createState() => _MenuViewTabState();
}

class _MenuViewTabState extends State<MenuViewTab> {
  String dropdownvalue = 'Most Popular';
  var items = [
    'Most Popular',
    'Burger',
    'Pizzas',
    'Veggies & Salad',
  ];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menus",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            height: 34,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kPrimaryColor
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 5.0, left: 15.0),
                                child: DropdownButton(
                                  icon: Icon(Icons.keyboard_arrow_down,color: kPrimaryColor,),
                                  value: dropdownvalue,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      cartContainer(context)
                    ],
                  ),
                ),
              );
            }, future: null,))
          ]));
    });
  }

  Container cartContainer(BuildContext context) {
    return Container(
                      height: 96,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/foodd.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 6, right: 5),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Asparagus Bruschetta",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF233748),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$200.00",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF919BA4),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                color: Color(0xFF919BA4),
                                              ),
                                              SizedBox(width: 20,),
                                             Container(
                                        height: 30,
                                        width: 92,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                           color: kPrimaryColor,
                                        ),
                                        child: Center(
                                          child: Text("Add to Cart",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12
                                          ),
                                          ),
                                        ),
                                       
                                      )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
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
