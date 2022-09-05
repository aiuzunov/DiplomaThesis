import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:recipes_app/widgets/header.dart';
import 'package:get/get.dart';
import '../static/helper_functions.dart';
import '../widgets/grid_image.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  State<Fridge> createState() => _FridgePageState();
}

class _FridgePageState extends State<Fridge> {
  final user = FirebaseAuth.instance.currentUser!;

  final List<String> randomImages = [
    "../lib/images/banana.jpg",
    "../lib/images/melon.jpg",
    "../lib/images/orange.jpg",
    "../lib/images/pear.jpg",
    "../lib/images/cabage.jpg",
    "../lib/images/eggplant.jpg",
    "../lib/images/potato.jpg",
    "../lib/images/strawberry.jpg",
    "../lib/images/cherries.jpg",
    "../lib/images/burger.jpg",
    "../lib/images/pizza.jpg",
  ];

  final CollectionReference _ingredients =
      FirebaseFirestore.instance.collection('ingredients');

  String searchVal = "";
  int selectedImageIndex = 1;
  final TextEditingController _nameController = TextEditingController();
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    try {
      if (documentSnapshot != null) {
        _nameController.text = documentSnapshot['name'];
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
                builder: (BuildContext ctx, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'name'.tr),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Choose an image:"),
                    GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 10,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        children: [
                          for (int i = 1; i < randomImages.length; i++)
                            GestureDetector(
                                onTap: () => {
                                      setState(
                                        () {
                                          selectedImageIndex = i;
                                        },
                                      )
                                    },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            style: selectedImageIndex == i
                                                ? BorderStyle.solid
                                                : BorderStyle.none,
                                            width: 3,
                                            color: selectedImageIndex == i
                                                ? Colors.white
                                                : Colors.transparent)),
                                    child: GridViewImage(
                                        imageUrl: randomImages[i])))
                        ]),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text('update'.tr),
                      onPressed: () async {
                        final String name = _nameController.text;
                        await _ingredients.doc(documentSnapshot!.id).update({
                          "name": name,
                          "image_url": randomImages[selectedImageIndex]
                        });
                        _nameController.text = '';
                      },
                    ),
                  ],
                ),
              );
            });
          });
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
  }

  Future<void> _delete(String ingredientId) async {
    try {
      await _ingredients.doc(ingredientId).delete();
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }

    if (!mounted) return;

    showSucessMessage("You have sucessfully deleted the ingredient.", context);
  }

  void searchRecipeOnButtonTap() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    try {
      _nameController.text = '';
      if (documentSnapshot != null) {
        _nameController.text = documentSnapshot['name'];
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) {
            return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'name'.tr),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Choose an image:"),
                      GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 10,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          children: [
                            for (int i = 1; i < randomImages.length; i++)
                              GestureDetector(
                                  onTap: () => {
                                        setState(
                                          () {
                                            selectedImageIndex = i;
                                          },
                                        )
                                      },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              style: selectedImageIndex == i
                                                  ? BorderStyle.solid
                                                  : BorderStyle.none,
                                              width: 3,
                                              color: selectedImageIndex == i
                                                  ? Colors.white
                                                  : Colors.transparent)),
                                      child: GridViewImage(
                                          imageUrl: randomImages[i])))
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text('add'.tr),
                        onPressed: () async {
                          final String name = _nameController.text;
                          await _ingredients.add({
                            "name": name,
                            "user_uid": user.uid,
                            "image_url": randomImages[selectedImageIndex]
                          });
                          _nameController.text = '';
                        },
                      )
                    ],
                  ),
                );
              },
            );
          });
    } catch (e) {
      showErrorMessage("Temporary error, please try again later!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: customAppBar(context),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          backgroundColor: Colors.white,
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: Header(text: "ingredients".tr)),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchVal = val;
                });
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: searchRecipeOnButtonTap,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.search),
                  ),
                  hintText: "find_ingredient".tr,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: StreamBuilder(
                  stream: (searchVal != "")
                      ? FirebaseFirestore.instance
                          .collection('ingredients')
                          .where('user_uid', isEqualTo: user.uid)
                          .where('name',
                              isGreaterThanOrEqualTo: searchVal,
                              isLessThan: searchVal.substring(
                                      0, searchVal.length - 1) +
                                  String.fromCharCode(searchVal
                                          .codeUnitAt(searchVal.length - 1) +
                                      1))
                          .orderBy('name')
                          .snapshots()
                      : _ingredients
                          .where('user_uid', isEqualTo: user.uid)
                          .orderBy('name')
                          .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 50, right: 50, top: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Image.network(documentSnapshot['image_url'],
                                        width: 50, height: 50),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(documentSnapshot['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                iconSize: 20,
                                                onPressed: () => {
                                                      _update(documentSnapshot),
                                                    },
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                iconSize: 20,
                                                onPressed: () => {
                                                      _delete(
                                                          documentSnapshot.id)
                                                    },
                                                icon: const Icon(Icons.delete)),
                                          ],
                                        )),
                                  ],
                                ));
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }))
        ],
      ),
    );
  }
}
