import 'package:flutter/material.dart';

class UsedProductDetailsScreen extends StatefulWidget {
  const UsedProductDetailsScreen({super.key});

  @override
  State<UsedProductDetailsScreen> createState() =>
      _UsedProductDetailsScreenState();
}

class _UsedProductDetailsScreenState extends State<UsedProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70,
              color: Color(0xff870081),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        Text(
                          '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
           
           
           Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/tv.jpeg'))),
                    ),
                  ),
                   Text("""simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.""")
                  ,  SizedBox(height: 20,),

                  Text('Price : ₹${29281}', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
        
               ],
        ),
      ),
    );
  }
}
