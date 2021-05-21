import 'package:RecipeApp/provider/add_category_provider.dart';
import 'package:RecipeApp/provider/app_provider.dart';
import 'package:RecipeApp/provider/loading_provider.dart';

import 'package:RecipeApp/widget/homepagewidget/custom_app_bar.dart';
import 'package:RecipeApp/widget/homepagewidget/image_picker_widget.dart';
import 'package:RecipeApp/widget/homepagewidget/loading_modal.dart';
import 'package:RecipeApp/widget/homepagewidget/recipe_form_field.dart';
import 'package:RecipeApp/widget/homepagewidget/submit_button_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatelessWidget {
  final categoryNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoadingModal(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_add_category.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            CustomAppBar(
              title: "Add Category",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ListView(
                      children: <Widget>[
                        RecipeFormField(
                          // TODO: Remove Controller and work with onSave
                          textEditingController: categoryNameController,
                          validator: (value) {
                            return value.isEmpty
                                ? "Please add a category name"
                                : null;
                          },
                          hintText: "Category name",
                        ),
                        SizedBox(height: 20),
                        Consumer<AddCategoryProvider>(
                          builder: (_, provider, __) {
                            return ImagePickerWidget(
                              onPressed: () async {
                                provider.selectImage();
                              },
                              image: provider.image,
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Builder(
                          builder: (context) {
                            return SubmitButton(
                              onPressed: () async {
                                final loadingProvider =
                                    Provider.of<LoadingProvider>(context,
                                        listen: false);

                                loadingProvider.startLoading();

                                if (_formKey.currentState.validate()) {
                                  var appProvider = Provider.of<AppProvider>(
                                      context,
                                      listen: false);
                                  var addCategoryProvider =
                                      Provider.of<AddCategoryProvider>(context,
                                          listen: false);
                                  bool savedSuccessful =
                                      await addCategoryProvider.saveCategory(
                                          appProvider,
                                          categoryNameController.text);

                                  loadingProvider.stopLoading();

                                  if (savedSuccessful) {
                                    Navigator.pop(context);
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.error_outline),
                                            SizedBox(width: 10.0),
                                            Text(
                                                "This category exists already"),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }
                                loadingProvider.stopLoading();
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
