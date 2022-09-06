import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/viewmodels/checklist_viewmodel.dart';
import 'package:recipes_app/widgets/app_bar.dart';
import 'package:recipes_app/widgets/header.dart';
import 'package:get/get.dart';

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<Checklist> {
  final user = FirebaseAuth.instance.currentUser!;

  String searchVal = "";
  int selectedImageIndex = 1;
  final TextEditingController _nameController = TextEditingController();

  void searchRecipeOnButtonTap() {
    setState(() {
      searchVal = _nameController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ChecklistViewModel());
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: customAppBar(context),
        floatingActionButton: GetBuilder<ChecklistViewModel>(
            init: Get.find<ChecklistViewModel>(),
            builder: (controller) => FloatingActionButton(
                onPressed: () => controller.createIngredientFromFirestore(
                    _nameController, selectedImageIndex, context),
                backgroundColor: Colors.white,
                child: const Icon(Icons.add))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: GetBuilder<ChecklistViewModel>(
          init: Get.find<ChecklistViewModel>(),
          builder: (controller) => controller.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Header(text: "cart".tr)),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600))),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: StreamBuilder(
                            stream: (searchVal != "")
                                ? controller.checklists
                                    .where('user_uid', isEqualTo: user.uid)
                                    .where('name',
                                        isGreaterThanOrEqualTo: searchVal,
                                        isLessThan: searchVal.substring(
                                                0, searchVal.length - 1) +
                                            String.fromCharCode(
                                                searchVal.codeUnitAt(
                                                        searchVal.length - 1) +
                                                    1))
                                    .orderBy('name')
                                    .snapshots()
                                : controller.checklists
                                    .where('user_uid', isEqualTo: user.uid)
                                    .orderBy('name')
                                    .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
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
                                              left: 50,
                                              right: 50,
                                              top: 10,
                                              bottom: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[850],
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                  documentSnapshot['image_url'],
                                                  width: 50,
                                                  height: 50),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    documentSnapshot['name'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      IconButton(
                                                          iconSize: 20,
                                                          onPressed: () => {
                                                                controller.updateChecklistFromFirestore(
                                                                    _nameController,
                                                                    selectedImageIndex,
                                                                    context,
                                                                    documentSnapshot),
                                                              },
                                                          icon: const Icon(
                                                              Icons.edit)),
                                                      IconButton(
                                                          iconSize: 20,
                                                          onPressed:
                                                              () => {
                                                                    controller.deleteChecklistFromFirestore(
                                                                        context,
                                                                        documentSnapshot)
                                                                  },
                                                          icon: const Icon(
                                                              Icons.check_box)),
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
        ));
  }
}
