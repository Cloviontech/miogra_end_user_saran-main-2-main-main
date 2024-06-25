import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/usedProducts/controllers/user_product_form_controllers.dart';
import 'package:miogra/features/usedProducts/widgets/user_products_item.dart';

class UsedProductUpload extends StatefulWidget {
  const UsedProductUpload({super.key});

  @override
  State<UsedProductUpload> createState() => _UsedProductUploadState();
}

class _UsedProductUploadState extends State<UsedProductUpload> {
  TextEditingController? sellingPriceTextEditingController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Product Details Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Product Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFf3e3e3e)),
              ),
            ),
            const SizedBox(height: 20),
            const ProductDetailsForm(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFC4F00),
                              blurRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Color(0xFFFC4F00),
                            size: 35,
                          ),
                          Text(
                            "Primary\nImage",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFC4F00),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFC4F00),
                              blurRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Color(0xFFFC4F00),
                            size: 35,
                          ),
                          Text(
                            "Other\nImages",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFC4F00),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Custom Description",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFf3e3e3e)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        textEditingControllers.add(
                            [TextEditingController(), TextEditingController()]);
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: Color(0xFFFC4F00),
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Custom Description Form
            SizedBox(
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: textEditingControllers.length,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: textEditingControllers[index][0],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Title"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: textEditingControllers[index][1],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Value",
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  textEditingControllers.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Pricing Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFf3e3e3e)),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(child: Center(child: Text("Selling Price"))),
                  Expanded(
                    child: TextField(
                      controller: sellingPriceTextEditingController,
                      decoration: const InputDecoration( 
                        border: OutlineInputBorder()
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: (){},
              child: Container( 
                height: 60,
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration:const BoxDecoration( 
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: const Text("Submit", style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500),),
              ),
              
            ),

            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

// Product Details Form
class ProductDetailsForm extends StatefulWidget {
  const ProductDetailsForm({super.key});

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          productDetailsFormTextField(
              controller: brandController, label: "Brand"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: modelNameController, label: "Model Name"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: productDescriptionController,
              label: "Product Description"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: contactController, label: "Contact"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: districtController, label: "District"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: yearAndMonthController,
              label: "Year and Month Of Purchase"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
