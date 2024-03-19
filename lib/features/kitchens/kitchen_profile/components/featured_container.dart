import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../featured_items_details_page.dart';

class FeaturedContainer extends StatelessWidget {
  const FeaturedContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FeaturedItemDetailsPage()));
      },
      child: Container(
        height: 207,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                      image: AssetImage('assets/images/foodd.png'),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Asparagus Brus...",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF233748)),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Crispy fresh bread slices topped\nwith asparagus and cheese ...",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF919BA4)),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$200.00",
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF919BA4),
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 27,
                    width: 81,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: kPrimaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
