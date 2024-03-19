import 'package:flutter/material.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/features/kitchens/kitchen_profile/order_tracking_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isVisible = true;
  bool issVisible = true;
  String? delivery;
  int _count = 1;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    if (_count <= 1) {
      return;
    }
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: (() => Navigator.pop(context)),
          child: Icon(
            Icons.arrow_back,
            color: Color(0xFF00BF6D),
          ),
        ),
        title: Text(
          "Cart",
          style: TextStyle(
              fontSize: 20,
              color: Color(0xFF233748),
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "(2 items)",
                    style: TextStyle(color: Color(0xFF233748)),
                  ),
                ],
              ),
              SizedBox(
                height: 9,
              ),
              cartContainer(context),
              SizedBox(
                height: 9,
              ),
              cartContainer(context),
              SizedBox(
                height: 9,
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 9,
              ),
              Text(
                "Payment",
                style: TextStyle(
                  color: Color(0xFF233748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    color: Color(0xFF233748),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Credit/Debit Card",
                    style: TextStyle(
                      color: Color(0xFF233748),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Delivery",
                style: TextStyle(
                  color: Color(0xFF233748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RadioListTile(
                activeColor: Color(0xFF00BF6D),
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                title: Text(
                  "Door delivery",
                  style: TextStyle(
                    color: Color(0xFF233748),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value: "Door delivery",
                groupValue: delivery,
                onChanged: (value) {
                  setState(() {
                    delivery = value.toString();
                    isVisible = !isVisible;
                  });
                },
              ),
              RadioListTile(
                activeColor: Color(0xFF00BF6D),
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                title: Text(
                  "Pickup",
                  style: TextStyle(
                    color: Color(0xFF233748),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value: "Pickup",
                groupValue: delivery,
                onChanged: (value) {
                  setState(() {
                    delivery = value.toString();
                    issVisible = !issVisible;
                    isVisible = !isVisible;
                  });
                },
              ),
              Visibility(
                visible: !isVisible,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                  visible: !isVisible,
                  child: Column(
                    children: [
                      doorDeliveryColumn(
                          text: "Recipient Name", textt: "Enter Name"),
                      SizedBox(
                        height: 15,
                      ),
                      doorDeliveryColumn(
                        text: "Recipient Address",
                        textt: "Enter Address",
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: !issVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pickup Address",
                        style: TextStyle(
                          color: Color(0xFF233748),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Robert Robertson, 1234 NW Bobcat Lane, St.",
                        style: TextStyle(
                          color: Color(0xFF919BA4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Robert, MO 65584-5678.",
                        style: TextStyle(
                          color: Color(0xFF919BA4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Use Coupon",
                    style: TextStyle(
                      color: Color(0xFF233748),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "(Optional)",
                    style: TextStyle(
                      color: Color(0xFF919BA4),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Input your code to get a discount on this order.",
                style: TextStyle(
                  color: Color(0xFF919BA4),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(children: [
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF00BF6D),
                      ),
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 4),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xFF233748),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          hintText: 'Coupon Code'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 45,
                    width: 139,
                    decoration: BoxDecoration(
                        color: Color(0xFF00BF6D),
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                        "Apply Coupon",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 15,
              ),
              Text(
                "Special Note",
                style: TextStyle(
                  color: Color(0xFF233748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 4),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF233748),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        hintText: 'Add a note to your order'),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Cart Total",
                style: TextStyle(
                  color: Color(0xFF233748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              cartRow(text: "Discount Price"),
              SizedBox(
                height: 7,
              ),
              cartRow(text: "Delivery Price"),
              SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(
                      color: Color(0xFF233748),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "\$48.00",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF233748),
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderTrackingPage(
                          skibbleUser: SkibbleUser(),
                        ))),
                child: Container(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF00BF6D),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column doorDeliveryColumn({text, textt}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color(0xFF233748),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "*",
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFF919BA4),
              ),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0xFF919BA4),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: textt),
            ),
          ),
        ),
      ],
    );
  }

  Row cartRow({text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF233748),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          "\$24.00",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF233748),
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Container cartContainer(BuildContext context) {
    return Container(
      height: 122,
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
                    image: AssetImage('assets/images/foodd.png'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 2, right: 5),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Asparagus Bruschetta",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF233748),
                                fontWeight: FontWeight.w700),
                          ),
                          Icon(
                            Icons.delete,
                            color: Color(0xFF919BA4),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Crispy fresh bread slices topped\nwith asparagus and cheese ...",
                        style: TextStyle(
                            fontSize: 13,
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
                                fontSize: 20,
                                color: Color(0xFF919BA4),
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: _decrement,
                                child: Container(
                                  height: 28,
                                  width: 28,
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
                                    fontSize: 16,
                                    color: Color(0xFF00BF6D),
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: _increment,
                                child: Container(
                                  height: 28,
                                  width: 28,
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
