import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:recipes_app/widgets/header.dart';
import 'package:get/get.dart';

class Fridge extends StatefulWidget {
  const Fridge({super.key});

  @override
  State<Fridge> createState() => _FridgePageState();
}

class _FridgePageState extends State<Fridge> {
  final user = FirebaseAuth.instance.currentUser!;

  final CollectionReference _ingredients =
      FirebaseFirestore.instance.collection('ingredients');

  String searchVal = "";
  final TextEditingController _nameController = TextEditingController();
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
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
                ElevatedButton(
                  child: Text('update'.tr),
                  onPressed: () async {
                    final String name = _nameController.text;
                    await _ingredients
                        .doc(documentSnapshot!.id)
                        .update({"name": name});
                    _nameController.text = '';
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String ingredientId) async {
    await _ingredients.doc(ingredientId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have sucessfully deleted the ingredient.")));
  }

  void searchRecipeOnButtonTap() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
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
                ElevatedButton(
                  child: Text('add'.tr),
                  onPressed: () async {
                    final String name = _nameController.text;
                    await _ingredients
                        .add({"name": name, "user_uid": user.uid});
                    _nameController.text = '';
                  },
                )
              ],
            ),
          );
        });
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
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, mainAxisExtent: 400),
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Column(children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.asset(
                                              '../lib/images/anime-girl-with-bow-hair_603843-157.webp')),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 8),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(documentSnapshot['name'],
                                                    style: const TextStyle(
                                                        fontSize: 20)),
                                                Text('Description test',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[700]))
                                              ])),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text("Quantity: 5"),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 10,
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
                                                  onPressed: () =>
                                                      _update(documentSnapshot),
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  iconSize: 20,
                                                  onPressed: () => _delete(
                                                      documentSnapshot.id),
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ))
                            ]);
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
