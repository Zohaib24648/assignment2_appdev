import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {
  final String? documentId;

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
    if (widget.documentId != null) {
      loadExistingData();
    }
  }

  void loadExistingData() async {
    setState(() => isLoading = true);
    try {
      var document = await FirebaseFirestore.instance.collection('model').doc(widget.documentId).get();
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
      var collection = FirebaseFirestore.instance.collection('model');
      var dateTimeNow = DateTime.now();
      var profilePictureUrl = ''; // Generate or fetch the profile picture URL
      var data = {
        'title': titleController.text,
        'description': descriptionController.text,
        'uploaderName': uploaderNameController.text,
        'profilePicture': profilePictureUrl,
        'createdAt': dateTimeNow,
      };

      try {
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

  void handleDelete() async {
    if (widget.documentId != null) {
      setState(() => isLoading = true);
      await FirebaseFirestore.instance.collection('model').doc(widget.documentId).delete();
      Navigator.pop(context);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentId == null ? 'Create Entry' : 'Edit Entry'),
        actions: [
          if (widget.documentId != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: handleDelete,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: uploaderNameController,
                  decoration: InputDecoration(
                    labelText: 'Uploader Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an uploader name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(widget.documentId == null ? 'Create' : 'Update'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // full width
                  ),
                ),
                if (widget.documentId != null)
                  SizedBox(height: 10),
                if (widget.documentId != null)
                  ElevatedButton(
                    onPressed: handleDelete,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50), // full width
                    ),
                  ),
              ],
            ),
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