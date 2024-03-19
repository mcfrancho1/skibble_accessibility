import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RecipeViewTab extends StatefulWidget {
  const RecipeViewTab({super.key});

  @override
  State<RecipeViewTab> createState() => _RecipeViewTabState();
}

class _RecipeViewTabState extends State<RecipeViewTab> {
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
                        "Recipes",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      SizedBox(
                        height: 7,
                      ),
                      recipeContainer(context),
                      
                      
                    ],
                  ),
                ),
              );
            }, future: null,))
          ]));
    });
  }

  Container recipeContainer(BuildContext context) {
    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFEFEFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 111,
                      child: Row(
                        children: [
                          Container(
                            height: 111,
                            width: 88,
                            decoration: BoxDecoration(
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Asparagus Bruschetta",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFF233748),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Icon(
                                            Icons.more_vert,
                                            color: Color(0xFF233748),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4,),
                                       Text("Crispy fresh bread slices topped with\nasparagus and cheese ...",
                                  style: TextStyle(
                                    color: Color(0xFF919BA4),
                                    fontSize: 11
                                  ),
                                  ),
                                    ],
                                  ),
                                  
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.favorite_border,
                                          color: Color(0xFF919BA4),
                                          ),
                                          SizedBox(width: 5,),
                                          Text("23k",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF233748)
                                          ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 30,),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.message,
                                            size: 20,
                                          color: Color(0xFF919BA4),
                                          ),
                                          SizedBox(width: 5,),
                                          Text("90k",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF233748)
                                          ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 30,),
                                      Row(
                                        children: [
                                          Icon(Icons.bookmark_border_outlined,
                                          color: Color(0xFF919BA4),
                                          ),
                                          SizedBox(width: 5,),
                                          Text("108",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF233748)
                                          ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
  }
}
