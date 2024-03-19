import 'package:flutter/material.dart';

class DescriptionViewTab extends StatefulWidget {
  const DescriptionViewTab({super.key});

  @override
  State<DescriptionViewTab> createState() => _DescriptionViewTabState();
}

class _DescriptionViewTabState extends State<DescriptionViewTab> {
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
                        "Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text("Cooking is an hubby for me, a delicious one though. A chef\n and a foodie, what could be more pleasant than that?!!",
                      style: TextStyle(
                        fontSize: 13
                      ),
                      ),
                      SizedBox(height: 12,),
                      Text(
                        "Chef’s Specialty",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 10,),
                      Row(
                    children: [
                      ingredientContainer(
                        text: "African",
                        width: 64.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "American",
                        width: 79.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Asian",
                        width: 55.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Baked",
                        width: 60.0,
                      ),
                    ],
                  ),
                      SizedBox(height: 10,),
                      Row(
                    children: [
                      ingredientContainer(
                        text: "Barbeque",
                        width: 81.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Burger",
                        width: 63.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Burritos",
                        width: 69.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Cakes",
                        width: 59.0,
                      ),
                    ],
                  ),
                    SizedBox(height: 10,),
                    Row(
                    children: [
                      ingredientContainer(
                        text: "Caribbean",
                        width: 85.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Chinese",
                        width: 71.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "Cocktails",
                        width: 78.0,
                      ),
                     
                    ],
                  ),
                   SizedBox(height: 10,),
                    Row(
                    children: [
                      ingredientContainer(
                        text: "Eastern european",
                        width: 132.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "European",
                        width: 80.0,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      ingredientContainer(
                        text: "French",
                        width: 64.0,
                      ),
                     
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
}