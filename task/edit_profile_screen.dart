import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.username;
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_imageFile == null) return null;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('$uid.jpg');

    await storageRef.putFile(_imageFile!);
    return await storageRef.getDownloadURL();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage("❌ Kein Benutzer angemeldet");
      setState(() => _isLoading = false);
      return;
    }

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final oldEmail = user.email;

    try {
      if (newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      if (newEmail != oldEmail) {
        await user.updateEmail(newEmail);
      }

      final imageUrl = await _uploadProfileImage(user.uid);

      final dataToUpdate = {
        'username': newName,
        'email': newEmail,
        if (imageUrl != null) 'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(dataToUpdate, SetOptions(merge: true));

      final userProvider = context.read<UserProvider>();
      await userProvider.setUsername(newName);
      if (imageUrl != null) {
        await userProvider.setProfileImageUrl(imageUrl);
      }

      await userProvider.loadUserDataFromFirebase();

      if (mounted) {
        _showMessage("✅ Profil erfolgreich aktualisiert");
        Navigator.pop(context);
      }
    } catch (e) {
      _showMessage("❌ Fehler: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _changePassword() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        _showMessage("📧 Passwort-Reset-Link gesendet");
      } else {
        _showMessage("❌ Keine E-Mail gefunden");
      }
    } catch (e) {
      _showMessage("❌ Fehler beim Zurücksetzen des Passworts");
    }
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profil bearbeiten")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (userProvider.profileImageUrl != null
                          ? NetworkImage(userProvider.profileImageUrl!)
                          : null) as ImageProvider?,
                  child: _imageFile == null && userProvider.profileImageUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().length < 3
                        ? 'Mindestens 3 Zeichen'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || !value.contains('@')
                        ? 'Ungültige E-Mail'
                        : null,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _changePassword,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text("Passwort zurücksetzen"),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Änderungen speichern"),
                        onPressed: _saveChanges,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
