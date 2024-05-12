import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {
  final String? documentId; // Used for editing existing entries

  const CreateScreen({Key? key, this.documentId}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final uploaderNameController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load existing data if editing
    if (widget.documentId != null) {
      loadExistingData();
    }
  }

  void loadExistingData() async {
    setState(() => isLoading = true);
    try {
      var document = await FirebaseFirestore.instance
          .collection('entries')
          .doc(widget.documentId)
          .get();
      var data = document.data();
      if (data != null) {
        titleController.text = data['title'];
        descriptionController.text = data['description'];
        uploaderNameController.text = data['uploaderName'];
      }
    } catch (e) {
      print("Error loading document: $e");
    }
    setState(() => isLoading = false);
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        var collection = FirebaseFirestore.instance.collection('entries');
        var dateTimeNow = DateTime.now();
        var data = {
          'title': titleController.text,
          'description': descriptionController.text,
          'uploaderName': uploaderNameController.text,
          'createdAt': dateTimeNow,
          // Optionally add profilePicture if required
        };

        if (widget.documentId == null) {
          await collection.add(data);
        } else {
          await collection.doc(widget.documentId).update(data);
        }
        Navigator.pop(context);
      } catch (e) {
        print("Error saving to Firestore: $e");
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? 'Create Entry' : 'Edit Entry'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: uploaderNameController,
                decoration: InputDecoration(labelText: 'Uploader Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an uploader name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text(widget.documentId == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    uploaderNameController.dispose();
    super.dispose();
  }
}
